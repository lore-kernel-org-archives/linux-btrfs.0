From: Ilya Shestopalov <yast4ik@yahoo.com>
Subject: Re: Re: Segmentation fault on partition mount
Date: Tue, 4 May 2010 10:52:14 -0700 (PDT)
Message-ID: <484550.49271.qm@web58307.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Please fix this bug (SEGFAULT), I can't access to my partition. Image o=
f partition you can download here:

http://narod.ru/disk/20400152000/btrfs_dump.z.html

> kernel BUG at fs/btrfs/tree-log.c:809!
> invalid opcode: 0000 [#1] PREEMPT SMP=20
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1f.2/host3/target3:0:0/3:0:0:0/scsi_l=
evel
> Modules linked in: btrfs zlib_deflate crc32c libcrc32c fuse
> usbhid hid snd_hda_codec_analog snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_seq_device snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore
> snd_page_alloc rtc_cmos rtc_core rtc_lib uhci_hcd
> asus_atk0110 nvidia(P) agpgart firewire_ohci firewire_core
> crc_itu_t ehci_hcd usbcore i2c_i801 i2c_core iTCO_wdt
> iTCO_vendor_support thermal button processor sky2 x38_edac
> edac_core sg evdev pcspkr ext4 mbcache jbd2 crc16 sr_mod
> sd_mod cdrom floppy pata_jmicron ata_piix pata_acpi
> ata_generic libata scsi_mod
>=20
> Pid: 2889, comm: mount Tainted: P=9A =9A =9A
> =9A =9A=9A=9A2.6.33-ARCH #1 P5E/P5E
> EIP: 0060:[<f9f468b9>] EFLAGS: 00010246 CPU: 1
> EIP is at add_inode_ref+0x3e9/0x400 [btrfs]
> EAX: 00000000 EBX: 00000097 ECX: 00000000 EDX: 000000a9
> ESI: 00000002 EDI: f6ea4b40 EBP: f69e9c40 ESP: f69e9be4
> DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Process mount (pid: 2889, ti=3Df69e8000 task=3Df653e1a0
> task.ti=3Df69e8000)
> Stack:
> f69e9bf8 f69e9bf8 c102ade0 f6ea4b40 00000011 f69e9c00
> f9f3991c f69e9c40
> <0> f9f2e36f f69e9c30 00000000 f6ea5000 f6df83dc
> 00000004 00000000 f6ea4b40
> <0> f6810000 f6810800 fffa3000 fffa3000 00000097
> 00000002 f6ea4b40 f69e9ca4
> Call Trace:
> [<c102ade0>] ? kunmap_atomic+0x70/0x80
> [<f9f3991c>] ? unmap_extent_buffer+0xc/0x10 [btrfs]
> [<f9f2e36f>] ? btrfs_item_size+0xdf/0xf0 [btrfs]
> [<f9f477fe>] ? replay_one_buffer+0x23e/0x310 [btrfs]
> [<f9f44d70>] ? walk_down_log_tree+0x210/0x510
> [btrfs]
> [<f9f45111>] ? walk_log_tree+0xa1/0x1c0 [btrfs]
> [<f9f4962b>] ? btrfs_recover_log_trees+0x1cb/0x290
> [btrfs]
> [<f9f475c0>] ? replay_one_buffer+0x0/0x310 [btrfs]
> [<f9f14f58>] ? open_ctree+0x10b8/0x15d0 [btrfs]
> [<c1185249>] ? strlcpy+0x39/0x50
> [<f9ef8760>] ? btrfs_get_sb+0x310/0x3f0 [btrfs]
> [<c10ed24a>] ? __alloc_percpu+0xa/0x10
> [<c110be56>] ? alloc_vfsmnt+0xe6/0x140
> [<c10f69b1>] ? vfs_kern_mount+0x61/0x1b0
> [<c110ac87>] ? get_fs_type+0x97/0xb0
> [<c10f6b59>] ? do_kern_mount+0x39/0xe0
> [<c110d398>] ? do_mount+0x358/0x700
> [<c10cf0c4>] ? strndup_user+0x44/0x80
> [<c110d9e6>] ? sys_mount+0x66/0xa0
> [<c100371f>] ? sysenter_do_call+0x12/0x28
> Code: 8b 45 e4 e8 ca 39 fb ff 8b 45 d4 e8 e2 15 1c c7 8b 45
> cc e8 da 15 1c c7 31 c0 83 c4 50 5b 5e 5f 5d c3 b8 fe ff ff
> ff eb f1 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b
> 8d 74 26 00 8d bc 27 00 00=20
> EIP: [<f9f468b9>] add_inode_ref+0x3e9/0x400 [btrfs]
> SS:ESP 0068:f69e9be4
> ---[ end trace 1d3c13495ff7bd0e ]---
>=20
>=20
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
