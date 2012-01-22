From: Marek Otahal <markotahal@gmail.com>
Subject: kernel BUG at fs/btrfs/transaction.c:1220! btrfs defragment crash on 3.2 kernel
Date: Sun, 22 Jan 2012 18:15:11 +0100
Message-ID: <3320254.3GQBPHz6nM@beruska>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, 
I was running btrfs fi defragment on my partitions, one went all fine and saved me some space, 
other crashed on some files..

[marek@beruska ~]$ uname -a
Linux beruska 3.2.1-1-ARCH #1 SMP PREEMPT Fri Jan 13 08:19:09 UTC 2012 i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux

btrfs-progs 0.19.20120110-2

btrfs mounted on dm-crypt/luks with these options:
mount 
/dev/mapper/storeDevice on /mnt/store type btrfs (rw,nosuid,nodev,noexec,relatime,thread_pool=4,nospace_cache)

After this, i think, these processes keep running: 
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                            
16669 root      20   0     0    0    0 D 17.8  0.0  75:27.36 btrfs-delayed-m                                    
16668 root      20   0     0    0    0 R 17.5  0.0  75:19.55 btrfs-delayed-m                                    
16670 root      20   0     0    0    0 D 17.5  0.0  34:53.62 btrfs-delayed-m                                    
31441 root      20   0     0    0    0 R 17.5  0.0  51:43.67 btrfs-delayed-m

thank you, Mark

[528547.210588] ------------[ cut here ]------------
[528547.210920] kernel BUG at fs/btrfs/transaction.c:1220!
[528547.211219] invalid opcode: 0000 [#3] PREEMPT SMP 
[528547.211519] Modules linked in: snd_seq snd_seq_device nls_cp437 vfat fat tg3 b43 ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables rfcomm ipv6 bnep cpufreq_ondemand zram(C) fuse btrfs zlib_deflate crc32c libcrc32c uas ums_realtek usb_storage uvcvideo btusb bluetooth videodev media joydev snd_hda_codec_realtek snd_hda_intel snd_hda_codec uhci_hcd snd_pcm snd_page_alloc ehci_hcd snd_hwdep usbcore psmouse snd_timer snd iTCO_wdt iTCO_vendor_support ideapad_laptop usb_common serio_raw i2c_i801 pcspkr libphy wmi thermal soundcore sparse_keymap arc4 battery evdev ac ssb mmc_core pcmcia mac80211 cfg80211 rfkill pcmcia_core acpi_cpufreq mperf processor freq_table sha256_generic sha512_generic aes_i586 ext4 crc16 jbd2 mbcache aes_generic xts gf12
 8mul dm_crypt dm_mod sd_mod ata_piix libata scsi_mod i915 video button i2c_algo_bit drm_kms_helper drm i2c_core intel_agp intel_gtt agpgart [last unloaded: tg3]
[528547.213821] 
[528547.213821] Pid: 15370, comm: sync Tainted: G      D WC   3.2.1-1-ARCH #1 LENOVO                           41875QG         /Kuril                           
[528547.213821] EIP: 0060:[<f9c87385>] EFLAGS: 00010286 CPU: 0
[528547.213821] EIP is at btrfs_commit_transaction+0x795/0x7e0 [btrfs]
[528547.213821] EAX: ffffffe4 EBX: f39c6688 ECX: 631b7740 EDX: 00000000
[528547.213821] ESI: f39c66dc EDI: 143d6ef8 EBP: eb0fbf4c ESP: eb0fbf00
[528547.213821]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[528547.213821] Process sync (pid: 15370, ti=eb0fa000 task=c08655e0 task.ti=eb0fa000)
[528547.213821] Stack:
[528547.213821]  00000000 eb0fbf18 00000000 00000000 f39cb5d0 f4b34c00 00000000 c08655e0
[528547.213821]  c0167e00 eb0fbf24 eb0fbf24 00000000 f4b34c00 f4b36c00 00000001 00000001
[528547.213821]  f4b36c00 00000001 00000001 eb0fbf68 f9c62cc5 eb0fbf54 f4b34c00 f4b36c00
[528547.213821] Call Trace:
[528547.213821]  [<c0167e00>] ? abort_exclusive_wait+0x80/0x80
[528547.213821]  [<f9c62cc5>] btrfs_sync_fs+0x55/0xf0 [btrfs]
[528547.213821]  [<c024afcf>] __sync_filesystem+0x5f/0x90
[528547.213821]  [<c024b017>] sync_one_sb+0x17/0x20
[528547.213821]  [<c0225de8>] iterate_supers+0x78/0xc0
[528547.213821]  [<c024b000>] ? __sync_filesystem+0x90/0x90
[528547.213821]  [<c024b0af>] sys_sync+0x3f/0x60
[528547.213821]  [<c047be1f>] sysenter_do_call+0x12/0x28
[528547.213821] Code: e9 35 ff ff ff 0f b7 06 83 ea 02 83 c6 02 66 89 07 83 c7 02 e9 90 fd ff ff 0f b6 06 b2 ca 83 c6 01 88 07 83 c7 01 e9 72 fd ff ff <0f> 0b ba bb 04 00 00 b8 62 ca cd f9 89 4d b8 e8 c7 24 4c c6 8b 
[528547.213821] EIP: [<f9c87385>] btrfs_commit_transaction+0x795/0x7e0 [btrfs] SS:ESP 0068:eb0fbf00
[528547.251313] ---[ end trace 015799c07e7725cd ]---


-- 

Marek Otahal :o)
