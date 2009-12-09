From: Jian Lin <mail@linjian.org>
Subject: Re: BtrFS does not respond after doing 'fstest' on both original and
	cloned file
Date: Wed, 9 Dec 2009 17:09:01 +0800
Message-ID: <603eac2a0912090109l3de723afpf00143739834609d@mail.gmail.com>
References: <603eac2a0912081753j39528ca4id374aa835e5f701a@mail.gmail.com>
	 <3d0408630912081819r52dfb101uaa4644eada0671ae@mail.gmail.com>
	 <603eac2a0912081955t6e8e67d1qec22c09454caee77@mail.gmail.com>
	 <3d0408630912082101g166c896j107134d0f93b19f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630912082101g166c896j107134d0f93b19f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

This problem can be reproduced on both my Dell and HP servers (X86_64,
CentOS5, 2.6.32) when test file is 2G or larger, and the error
messages are almost the same everytime. (about syslogd,
fs/btrfs/tree-log.c)

On Wed, Dec 9, 2009 at 1:01 PM, Yan, Zheng <yanzheng@21cn.com> wrote:
> On Wed, Dec 9, 2009 at 11:55 AM, Jian Lin <mail@linjian.org> wrote:
>> Full msg in /var/log/messages:
>> Dec =A09 08:38:42 node34 kernel: ------------[ cut here ]-----------=
-
>> Dec =A09 08:38:42 node34 kernel: kernel BUG at fs/btrfs/tree-log.c:2=
661!
>> Dec =A09 08:38:42 node34 kernel: invalid opcode: 0000 [#1] SMP
>> Dec =A09 08:38:42 node34 kernel: last sysfs file:
>> /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
>> Dec =A09 08:38:42 node34 kernel: CPU 0
>> Dec =A09 08:38:42 node34 kernel: Modules linked in: nls_utf8 hfsplus
>> autofs4 i2c_dev i2c_core sunrpc dm_mirror dm_multipath scsi_dh video
>> output sbs sbshc battery acpi_memhotplug ac ipv6 parport_pc lp parpo=
rt
>> joydev ide_cd_mod cdrom serio_raw floppy button tg3 libphy hpilo
>> ata_piix libata e752x_edac rtc_cmos edac_core rtc_core rtc_lib pcspk=
r
>> dm_region_hash dm_log dm_mod shpchp cciss sd_mod scsi_mod ext3 jbd
>> uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
>> Dec =A09 08:38:42 node34 kernel: Pid: 7354, comm: fstest-mod Not tai=
nted
>> 2.6.32 #1 ProLiant DL380 G4
>> Dec =A09 08:38:42 node34 kernel: RIP: 0010:[<ffffffff81168606>]
>> [<ffffffff81168606>] copy_items+0x2c2/0x2ff
>> Dec =A09 08:38:42 node34 kernel: RSP: 0018:ffff880001fdfcb8 =A0EFLAG=
S: 00010282
>> Dec =A09 08:38:42 node34 kernel: RAX: 00000000ffffffef RBX:
>> ffff88005d494010 RCX: 0000000000000000
>> Dec =A09 08:38:42 node34 kernel: RDX: 0000000000000003 RSI:
>> ffff88007ab10250 RDI: ffff88007e657240
>> Dec =A09 08:38:42 node34 kernel: RBP: ffff88005d494000 R08:
>> ffff880001fdfa28 R09: ffff880001fdfa20
>> Dec =A09 08:38:42 node34 kernel: R10: 000000011b982800 R11:
>> ffff88005a138ce0 R12: 0000000000196000
>> Dec =A09 08:38:42 node34 kernel: R13: ffff88006df62370 R14:
>> ffff88007ab10370 R15: 000000000c302000
>> Dec =A09 08:38:42 node34 kernel: FS: =A000007fccfb4ba6e0(0000)
>> GS:ffff880003c00000(0000) knlGS:0000000000000000
>> Dec =A09 08:38:42 node34 kernel: CS: =A00010 DS: 0000 ES: 0000 CR0: =
000000008005003b
>> Dec =A09 08:38:42 node34 kernel: CR2: 0000000000f58000 CR3:
>> 0000000045fbe000 CR4: 00000000000006f0
>> Dec =A09 08:38:42 node34 kernel: DR0: 0000000000000000 DR1:
>> 0000000000000000 DR2: 0000000000000000
>> Dec =A09 08:38:42 node34 kernel: DR3: 0000000000000000 DR6:
>> 00000000ffff0ff0 DR7: 0000000000000400
>> Dec =A09 08:38:42 node34 kernel: Process fstest-mod (pid: 7354,
>> threadinfo ffff880001fde000, task ffff88007f10c870)
>> Dec =A09 08:38:42 node34 kernel: Stack:
>> Dec =A09 08:38:42 node34 kernel: =A0ffff88007ab102e0 000000330000000=
0
>> ffff88001b982800 ffff88005a138ce0
>> Dec =A09 08:38:42 node34 kernel: <0> ffff8800594e2000 00000033000005=
47
>> 000000034b163000 ffff8800594e242f
>> Dec =A09 08:38:42 node34 kernel: <0> 0000000000000560 00000000000000=
65
>> ffff8800594e20cc 000000338115061d
>> Dec =A09 08:38:42 node34 kernel: Call Trace:
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff81169273>] ?
>> btrfs_log_inode+0x32c/0x467
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff81146000>] ? btrfs_wri=
tepage+0x0/0x4e
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff81169587>] ?
>> btrfs_log_inode_parent+0x1d9/0x2a7
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff8114cc59>] ?
>> btrfs_sync_file+0xd6/0x14d
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff810e4456>] ? vfs_fsync=
_range+0x73/0x9e
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff810e44ff>] ? do_fsync+=
0x27/0x3a
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff810e4530>] ? sys_fsync=
+0xb/0x10
>> Dec =A09 08:38:42 node34 kernel: =A0[<ffffffff8100b8eb>] ?
>> system_call_fastpath+0x16/0x1b
>> Dec =A09 08:38:42 node34 kernel: Code: 24 10 4c 89 f6 e8 5a 16 fc ff=
 48
>> 8b 7c 24 20 eb 29 48 8d 6b f0 48 8b 74 24 10 48 8b 7c 24 18 48 89 ea
>> e8 00 4b fd ff 85 c0 74 04 <0f> 0b eb fe 48 89 df e8 c2 a9 05 00 48 =
89
>> ef e8 d2 93 f5 ff 48
>> Dec =A09 08:38:42 node34 kernel: RIP =A0[<ffffffff81168606>] copy_it=
ems+0x2c2/0x2ff
>> Dec =A09 08:38:42 node34 kernel: =A0RSP <ffff880001fdfcb8>
>> Dec =A09 08:38:42 node34 kernel: ---[ end trace 3ea0fce179abe088 ]--=
-
>
> btrfs_csum_file_blocks return -EEXIST, looks like a race.
>



--=20
Jian Lin
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
