### 通过 GitHub Actions 构建 Armbian 固件和内核
- 内核配置：启用 eBPF 支持，支持 DAE 代理，适用于 mesons64、rockchip64 和 rk35xx-vendor。
- 针对 Nanopc-T4：
  - CPU 小核频率 1.5GHz，CPU 大核频率 2.0GHz。
  - 启用 PCIe 2.1 x4 支持。
  - CPU 温度达到 45°C 时启动风扇，65°C 时风扇全速运转。
- 针对 Rock5C Lite：
  - 移除 U-Boot 对 GPU 的检测，启用 GPU 节点。
  - 重命名网络接口：将 end* 重命名为 eth0。
  - 风扇策略：
    - 温度 >= 40°C  -> 风扇转速 40%
    - 温度 >= 50°C  -> 风扇转速 55%
    - 温度 >= 60°C  -> 风扇转速 75%
    - 温度 >= 70°C  -> 风扇转速 88%
    - 温度 >= 75°C  -> 风扇转速 100%
  - 默认不支持 WiFi，请自行安装[驱动](https://github.com/radxa-pkg/aic8800)。
- 针对 Panther-X2：
  - CPU 频率 2.0GHz。
  - vendor 固件支持 jellyfin 硬件转码。
  - 重命名网络接口：将 end* 重命名为 eth0。
- 其他修改： 
  - 移除内核版本后缀信息。
  - Aml-s9xx-box 固件的默认配置针对斐讯 N1 盒子，直接将固件解压写入U盘设备即可。
  - 增加 cpuinfo 中的 model name 信息，更直观地了解硬件配置。
  - 增加 armbian-apt armbian-update armbian-sync [命令](https://github.com/Zane-E/Armbian-Actions/blob/main/screenshot/screenshot.png)，方便换源，更新内核，同步脚本。

### 相关链接
- [Armbian Build](https://github.com/armbian/build)
- [DAE Universe](https://github.com/daeuniverse/dae)
