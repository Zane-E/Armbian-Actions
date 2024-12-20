### 通过 GitHub Actions 构建 Armbian 固件和内核
- 内核配置：启用 eBPF 支持，支持 DAE 代理，适用于 mesons64、rockchip64 和 rk35xx-vendor。
- 针对 Nanopc-T4：
  - 小核超频至 1.8GHz，大核超频至 2.2GHz。
  - 启用 PCIe 2.1 x4 支持。
  - CPU 温度达到 40°C 时启动风扇，65°C 时风扇全速运转。
- 针对 Rock5C Lite：
  - 移除 U-Boot 对 GPU 的检测，启用 GPU 节点。
  - 重命名网络接口：将 end0 重命名为 eth0。
  - 风扇策略：
    - 温度 >= 40°C  -> 风扇转速 40%
    - 温度 >= 50°C  -> 风扇转速 55%
    - 温度 >= 60°C  -> 风扇转速 75%
    - 温度 >= 70°C  -> 风扇转速 88%
    - 温度 >= 75°C  -> 风扇转速 100%
  - 不支持 WiFi，启用 eBPF 后可能导致驱动程序安装失败。
- 其他修改：
  - 移除内核版本后缀信息。
  - 增加 cpuinfo 中的 model name 信息，更直观地了解硬件配置。
  - 增加 armbian-apt armbian-update 命令，方便换源及更新内核。

### 相关链接
- [Armbian Build](https://github.com/armbian/build)
- [DAE Universe](https://github.com/daeuniverse/dae)
