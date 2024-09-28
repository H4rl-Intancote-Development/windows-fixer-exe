package reg

import "core:fmt"
import "core:strings"
import "core:sys/windows"


lowercase := strings.to_lower

@(private = "file")
match_restriction :: proc(value: string) -> windows.DWORD {
	switch lowercase(value) {
	case "rrf_rt_any":
		return windows.RRF_RT_ANY
	case "rrf_rt_dword":
		return windows.RRF_RT_DWORD
	case "rrf_rt_qword":
		return windows.RRF_RT_QWORD
	case "rrf_rt_reg_binary":
		return windows.RRF_RT_REG_BINARY
	case "rrf_rt_reg_dword":
		return windows.RRF_RT_REG_DWORD
	case "rrf_rt_reg_expand_sz":
		return windows.RRF_RT_REG_EXPAND_SZ
	case "rrf_rt_reg_multi_sz":
		return windows.RRF_RT_REG_MULTI_SZ
	case "rrf_rt_reg_none":
		return windows.RRF_RT_REG_NONE
	case "rrf_rt_reg_qword":
		return windows.RRF_RT_REG_QWORD
	case "rrf_rt_reg_sz":
		return windows.RRF_RT_REG_SZ
	}
	return windows.REG_NONE
}

@(private = "file")
match_regtype :: proc(value: string) -> windows.DWORD {
	switch lowercase(value) {
	case "reg_binary":
		return windows.REG_BINARY
	case "reg_dword":
		return windows.REG_DWORD
	case "reg_expand_sz":
		return windows.REG_EXPAND_SZ
	case "reg_multi_sz":
		return windows.REG_MULTI_SZ
	case "reg_none":
		return windows.REG_NONE
	case "reg_qword":
		return windows.REG_QWORD
	case "reg_sz":
		return windows.REG_SZ
	}
	return windows.REG_NONE
}

@(private = "file")
match_key :: proc(value: string) -> windows.HKEY {
	switch lowercase(value) {
	case "hkey_classes_root":
		return windows.HKEY_CLASSES_ROOT
	case "hkey_current_user":
		return windows.HKEY_CURRENT_USER
	case "hkey_local_machine":
		return windows.HKEY_LOCAL_MACHINE
	case "hkey_users":
		return windows.HKEY_USERS
	case "hkey_performance_data":
		return windows.HKEY_PERFORMANCE_DATA
	case "hkey_current_config":
		return windows.HKEY_CURRENT_CONFIG
	case "hkey_dyn_data":
		return windows.HKEY_DYN_DATA
	}
	return windows.HKEY_CURRENT_USER
}


get_value :: proc(path: string) {
	key_handle: windows.HKEY
	mainKey := match_key("HKEY_LOCAL_MACHINE")
	subKey := windows.L(
		"SOFTWARE\\Microsoft\\WindowsRuntime\\ActivatableClassId\\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter",
	)
	valueName := windows.L("ActivationType")

	flag := match_restriction("RRF_RT_DWORD")

	dwType := match_regtype("REG_DWORD")
	data: u32
	pcbData: u32 = size_of(data)

	open_key_result: windows.LSTATUS = windows.RegOpenKeyExW(
		mainKey,
		subKey,
		0,
		windows.KEY_READ,
		&key_handle,
	)

	if open_key_result != cast(i32)windows.ERROR_SUCCESS {
		fmt.printf("Key Handle: %d, Open Key Result: %d\n", key_handle, open_key_result)
		return
	}

	fmt.printf("Key Handle: %d, Open Key Result: %d\n", key_handle, open_key_result)

	result: windows.LSTATUS = windows.RegGetValueW(
		mainKey,
		subKey,
		valueName,
		flag,
		&dwType,
		&data,
		&pcbData,
	)

	if result != cast(i32)windows.ERROR_SUCCESS {
		fmt.printf("Value: %d, pcbData: %d, result: %d\n", data, pcbData, result)
		return
	}

	close_key_result := windows.RegCloseKey(key_handle)
	if close_key_result != cast(i32)windows.ERROR_SUCCESS {
		fmt.printf("Close Key Result: %d\n", close_key_result)
		return
	}

	fmt.printf("Value: %d, pcbData: %d, Result: %d\n", data, pcbData, result)
}

/* powershell.exe -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c takeown /f \"%1\" && icacls \"%1\" /grant *S-1-3-4:F /c /l & pause' -Verb runAs" */
