Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv1.eu ([88.198.9.132]:36253 "EHLO srv1.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbcIBPFy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 11:05:54 -0400
Received: from localhost (localhost [127.0.0.1])
        by srv1.eu (Postfix) with ESMTP id 58ABBD10005
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2016 16:58:58 +0200 (CEST)
Received: from srv1.eu ([IPv6:::ffff:127.0.0.1])
        by localhost (mail.srv1.eu [::ffff:127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id c5dLQTQpsx5k for <linux-btrfs@vger.kernel.org>;
        Fri,  2 Sep 2016 16:58:43 +0200 (CEST)
Received: from [129.206.37.145] (dhcp37-145.laptop-wlc.uni-heidelberg.de [129.206.37.145])
        by srv1.eu (Postfix) with ESMTPSA id 89061D10003
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Sep 2016 16:58:43 +0200 (CEST)
From: stek14@srv1.eu
Subject: kernel BUG at fs/btrfs/ctree.c:5213
To: linux-btrfs@vger.kernel.org
Message-ID: <82bc05ea-f3eb-422f-6688-be8404d12a12@srv1.eu>
Date: Fri, 2 Sep 2016 16:58:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

since a few weeks ago, my BTRFS (the root file system) sporadically 
crashes leaving a "kernel BUG" message in dmesg. I also noticed some 
files behaving like this:

$ ls -lai
ls: cannot access 'nlpsolver.jar': Stale file handle
ls: cannot access 'EvolutionarySolver.jar': Stale file handle
ls: cannot access 'description-en-US.txt': Stale file handle
ls: cannot access 'components.rdb': Stale file handle
ls: cannot access 'description.xml': Stale file handle
total 0
1546821 drwxr-xr-x 1 root root 230 Apr 17 11:44 .
1546727 drwxr-xr-x 1 root root  68 Apr 17 11:44 ..
       ? -????????? ? ?    ?      ?            ? components.rdb
       ? -????????? ? ?    ?      ?            ? description-en-US.txt
       ? -????????? ? ?    ?      ?            ? description.xml
       ? -????????? ? ?    ?      ?            ? EvolutionarySolver.jar
1546828 drwxr-xr-x 1 root root  58 Apr 17 11:44 help
1546829 drwxr-xr-x 1 root root 268 Apr 17 11:44 locale
1546825 drwxr-xr-x 1 root root  24 Apr 17 11:44 META-INF
       ? -????????? ? ?    ?      ?            ? nlpsolver.jar
1546826 drwxr-xr-x 1 root root  14 Apr 17 11:44 registration


Every time I try to access them, I get the following in dmesg, always 
with the same numbers:

[  274.448070] BTRFS error (device sda8): parent transid verify failed 
on 31042928640 wanted 18412968017025564884 found 135380


Then suddenly, usually while doing something unrelated like loading a 
website in my browser, a "kernel BUG" appears in dmesg, most programs 
freeze and I can only recover by rebooting. It was still possible to 
save the output of dmesg, which I copied below. I guess that even if my 
file system is currupted, this should not happen?

In addition to reporting this bug, I would like to ask what I can do to 
repair the file system? btrfs scrub does not return any errors, and the 
usual articles describing the "parent transid verify failed" error 
assume the "wanted" and "found" IDs differ only by a small number, so I 
guess they don't apply to my situation? Can someone give me some advice? 
If I can't repair it, it would at least be good to have a list which 
files are currupt, so I can set up a new file system and restore them 
from a backup.

Thank you!

Florian



Here is some more information:

dmesg output:
[18101.021285] BTRFS error (device sda8): parent transid verify failed 
on 31042928640 wanted 18412968017025564884 found 135380
[18101.021479] BTRFS error (device sda8): parent transid verify failed 
on 31042928640 wanted 18412968017025564884 found 135380
[27168.533582] verify_parent_transid: 12 callbacks suppressed
[27168.533587] BTRFS error (device sda8): parent transid verify failed 
on 31042928640 wanted 18412968017025564884 found 135380
[27168.533627] ------------[ cut here ]------------
[27168.534696] kernel BUG at fs/btrfs/ctree.c:5213!
[27168.535684] invalid opcode: 0000 [#1] PREEMPT SMP
[27168.536613] Modules linked in: sha256_ssse3 sha256_generic hmac drbg 
ansi_cprng ctr ccm joydev snd_hda_codec_hdmi mousedev 
snd_hda_codec_realtek snd_hda_codec_generic mei_wdt dell_wmi 
sparse_keymap iTCO_wdt iTCO_vendor_support ppdev intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm arc4 
irqbypass crct10dif_pclmul crc32_pclmul dell_laptop ghash_clmulni_intel 
dell_smbios nls_iso8859_1 dcdbas dell_smm_hwmon nls_cp437 vfat i915 fat 
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd 
intel_cstate iwlmvm intel_rapl_perf uvcvideo mac80211 evdev input_leds 
mac_hid videobuf2_vmalloc drm_kms_helper pcspkr videobuf2_memops 
videobuf2_v4l2 videobuf2_core psmouse btusb serio_raw btrtl drm btbcm 
btintel iwlwifi videodev snd_hda_intel i2c_i801 snd_hda_codec bluetooth 
intel_gtt
[27168.539869]  syscopyarea media sysfillrect sysimgblt cfg80211 
snd_soc_rt5640 fb_sys_fops i2c_algo_bit mei_me crc16 e1000e lpc_ich mei 
snd_hda_core snd_soc_rl6231 parport_pc snd_soc_ssm4567 ptp snd_soc_core 
parport pps_core snd_hwdep shpchp wmi snd_compress thermal battery 
int3403_thermal dell_smo8800 fan snd_pcm_dmaengine ac97_bus snd_pcm 
snd_soc_sst_acpi snd_soc_sst_match snd_timer elan_i2c fjes i2c_hid 
8250_dw snd hid soundcore spi_pxa2xx_platform processor_thermal_device 
i2c_designware_platform dell_rbtn int3406_thermal i2c_designware_core 
int3400_thermal video tpm_tis acpi_als kfifo_buf industrialio tpm 
int3402_thermal acpi_pad int340x_thermal_zone intel_soc_dts_iosf ac 
button acpi_thermal_rel rfkill sch_fq_codel ip_tables x_tables btrfs xor 
raid6_pq sd_mod atkbd libps2 crc32c_intel ahci libahci
[27168.543479]  libata scsi_mod ehci_pci ehci_hcd xhci_pci xhci_hcd 
sdhci_pci usbcore usb_common i8042 serio sdhci_acpi sdhci led_class mmc_core
[27168.546045] CPU: 2 PID: 1012 Comm: mozStorage #1 Tainted: G 
U          4.7.2-1-ARCH #1
[27168.547318] Hardware name: Dell Inc. Latitude E7450/0D8H72, BIOS A06 
08/31/2015
[27168.548587] task: ffff8800c2afaac0 ti: ffff8800c1344000 task.ti: 
ffff8800c1344000
[27168.549845] RIP: 0010:[<ffffffffa01f5661>] [<ffffffffa01f5661>] 
btrfs_search_forward+0x251/0x330 [btrfs]
[27168.551109] RSP: 0018:ffff8800c1347a90  EFLAGS: 00010246
[27168.552368] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000000
[27168.553644] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 
ffff8800da2251a0
[27168.554910] RBP: ffff8800c1347af8 R08: 0000000701400000 R09: 
0000000741400000
[27168.556176] R10: 0000000000000000 R11: ffffffff81a7ba4d R12: 
ffff8800b310fc40
[27168.557447] R13: 0000000000000001 R14: 0000000000000000 R15: 
000000000003a9f1
[27168.558718] FS:  00007f616b2ff700(0000) GS:ffff88021e500000(0000) 
knlGS:0000000000000000
[27168.560040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[27168.561308] CR2: 00007f615d790000 CR3: 00000001f7432000 CR4: 
00000000003406e0
[27168.562574] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[27168.563841] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[27168.565087] Stack:
[27168.566321]  01b16b0056bdd1d0 00ff480000000000 ffff8800c1347bc3 
ffff880214045000
[27168.567561]  46000000000000b1 010000000000431b 0000000000000000 
00000000f358f9a8
[27168.568797]  ffff8801f2660a50 ffff8800da101688 ffff8801f2660a50 
ffff8800b310fc40
[27168.570033] Call Trace:
[27168.571270]  [<ffffffffa029b2cd>] btrfs_log_inode+0x394/0xb57 [btrfs]
[27168.572498]  [<ffffffffa021af50>] ? do_async_commit+0x40/0x40 [btrfs]
[27168.573723]  [<ffffffffa029bc81>] log_new_dir_dentries+0x1f1/0x528 
[btrfs]
[27168.574946]  [<ffffffffa025e385>] btrfs_log_inode_parent+0x8b5/0x960 
[btrfs]
[27168.576163]  [<ffffffffa0217a98>] ? 
wait_current_trans.isra.8+0x58/0x110 [btrfs]
[27168.577384]  [<ffffffffa02173c2>] ? 
join_transaction.isra.2+0x112/0x410 [btrfs]
[27168.578606]  [<ffffffffa025f422>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
[27168.579811]  [<ffffffffa023230f>] btrfs_sync_file+0x2af/0x3f0 [btrfs]
[27168.580986]  [<ffffffff8122db6b>] vfs_fsync_range+0x4b/0xb0
[27168.582158]  [<ffffffff8122dc2d>] do_fsync+0x3d/0x70
[27168.583363]  [<ffffffff8122dee3>] SyS_fdatasync+0x13/0x20
[27168.584593]  [<ffffffff815de7b2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[27168.585759] Code: 48 8b 55 a8 48 8b 7d b0 4d 89 f8 44 89 e9 4c 89 e6 
e8 44 fb ff ff 85 c0 0f 85 c1 00 00 00 4c 89 e7 e8 d4 7d ff ff e9 f8 fd 
ff ff <0f> 0b 48 8d 04 92 43 89 54 ac 40 48 8d 75 bf b9 11 00 00 00 48
[27168.587061] RIP  [<ffffffffa01f5661>] 
btrfs_search_forward+0x251/0x330 [btrfs]
[27168.588311]  RSP <ffff8800c1347a90>
[27168.595772] ---[ end trace a1ed8484eb98289b ]---
[27393.213272] systemd[1]: systemd-journald.service: State 
'stop-sigabrt' timed out. Terminating.

$ uname -a
Linux dell 4.7.2-1-ARCH #1 SMP PREEMPT Sat Aug 20 23:02:56 CEST 2016 
x86_64 GNU/Linux
$ btrfs --version
btrfs-progs v4.7
$ btrfs fi show
$ btrfs fi df /
Data, single: total=107.01GiB, used=78.94GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=2.01GiB, used=639.95MiB
GlobalReserve, single: total=224.00MiB, used=0.00B

