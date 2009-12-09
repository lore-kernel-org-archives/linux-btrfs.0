From: Jian Lin <mail@linjian.org>
Subject: Re: BtrFS does not respond after doing 'fstest' on both original and
	cloned file
Date: Wed, 9 Dec 2009 11:55:07 +0800
Message-ID: <603eac2a0912081955t6e8e67d1qec22c09454caee77@mail.gmail.com>
References: <603eac2a0912081753j39528ca4id374aa835e5f701a@mail.gmail.com>
	 <3d0408630912081819r52dfb101uaa4644eada0671ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Yan, Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630912081819r52dfb101uaa4644eada0671ae@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

=46ull msg in /var/log/messages:

Dec  9 08:38:42 node34 kernel: ------------[ cut here ]------------
Dec  9 08:38:42 node34 kernel: kernel BUG at fs/btrfs/tree-log.c:2661!
Dec  9 08:38:42 node34 kernel: invalid opcode: 0000 [#1] SMP
Dec  9 08:38:42 node34 kernel: last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
Dec  9 08:38:42 node34 kernel: CPU 0
Dec  9 08:38:42 node34 kernel: Modules linked in: nls_utf8 hfsplus
autofs4 i2c_dev i2c_core sunrpc dm_mirror dm_multipath scsi_dh video
output sbs sbshc battery acpi_memhotplug ac ipv6 parport_pc lp parport
joydev ide_cd_mod cdrom serio_raw floppy button tg3 libphy hpilo
ata_piix libata e752x_edac rtc_cmos edac_core rtc_core rtc_lib pcspkr
dm_region_hash dm_log dm_mod shpchp cciss sd_mod scsi_mod ext3 jbd
uhci_hcd ohci_hcd ehci_hcd [last unloaded: freq_table]
Dec  9 08:38:42 node34 kernel: Pid: 7354, comm: fstest-mod Not tainted
2.6.32 #1 ProLiant DL380 G4
Dec  9 08:38:42 node34 kernel: RIP: 0010:[<ffffffff81168606>]
[<ffffffff81168606>] copy_items+0x2c2/0x2ff
Dec  9 08:38:42 node34 kernel: RSP: 0018:ffff880001fdfcb8  EFLAGS: 0001=
0282
Dec  9 08:38:42 node34 kernel: RAX: 00000000ffffffef RBX:
ffff88005d494010 RCX: 0000000000000000
Dec  9 08:38:42 node34 kernel: RDX: 0000000000000003 RSI:
ffff88007ab10250 RDI: ffff88007e657240
Dec  9 08:38:42 node34 kernel: RBP: ffff88005d494000 R08:
ffff880001fdfa28 R09: ffff880001fdfa20
Dec  9 08:38:42 node34 kernel: R10: 000000011b982800 R11:
ffff88005a138ce0 R12: 0000000000196000
Dec  9 08:38:42 node34 kernel: R13: ffff88006df62370 R14:
ffff88007ab10370 R15: 000000000c302000
Dec  9 08:38:42 node34 kernel: FS:  00007fccfb4ba6e0(0000)
GS:ffff880003c00000(0000) knlGS:0000000000000000
Dec  9 08:38:42 node34 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000=
08005003b
Dec  9 08:38:42 node34 kernel: CR2: 0000000000f58000 CR3:
0000000045fbe000 CR4: 00000000000006f0
Dec  9 08:38:42 node34 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Dec  9 08:38:42 node34 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Dec  9 08:38:42 node34 kernel: Process fstest-mod (pid: 7354,
threadinfo ffff880001fde000, task ffff88007f10c870)
Dec  9 08:38:42 node34 kernel: Stack:
Dec  9 08:38:42 node34 kernel:  ffff88007ab102e0 0000003300000000
ffff88001b982800 ffff88005a138ce0
Dec  9 08:38:42 node34 kernel: <0> ffff8800594e2000 0000003300000547
000000034b163000 ffff8800594e242f
Dec  9 08:38:42 node34 kernel: <0> 0000000000000560 0000000000000065
ffff8800594e20cc 000000338115061d
Dec  9 08:38:42 node34 kernel: Call Trace:
Dec  9 08:38:42 node34 kernel:  [<ffffffff81169273>] ?
btrfs_log_inode+0x32c/0x467
Dec  9 08:38:42 node34 kernel:  [<ffffffff81146000>] ? btrfs_writepage+=
0x0/0x4e
Dec  9 08:38:42 node34 kernel:  [<ffffffff81169587>] ?
btrfs_log_inode_parent+0x1d9/0x2a7
Dec  9 08:38:42 node34 kernel:  [<ffffffff8114cc59>] ?
btrfs_sync_file+0xd6/0x14d
Dec  9 08:38:42 node34 kernel:  [<ffffffff810e4456>] ? vfs_fsync_range+=
0x73/0x9e
Dec  9 08:38:42 node34 kernel:  [<ffffffff810e44ff>] ? do_fsync+0x27/0x=
3a
Dec  9 08:38:42 node34 kernel:  [<ffffffff810e4530>] ? sys_fsync+0xb/0x=
10
Dec  9 08:38:42 node34 kernel:  [<ffffffff8100b8eb>] ?
system_call_fastpath+0x16/0x1b
Dec  9 08:38:42 node34 kernel: Code: 24 10 4c 89 f6 e8 5a 16 fc ff 48
8b 7c 24 20 eb 29 48 8d 6b f0 48 8b 74 24 10 48 8b 7c 24 18 48 89 ea
e8 00 4b fd ff 85 c0 74 04 <0f> 0b eb fe 48 89 df e8 c2 a9 05 00 48 89
ef e8 d2 93 f5 ff 48
Dec  9 08:38:42 node34 kernel: RIP  [<ffffffff81168606>] copy_items+0x2=
c2/0x2ff
Dec  9 08:38:42 node34 kernel:  RSP <ffff880001fdfcb8>
Dec  9 08:38:42 node34 kernel: ---[ end trace 3ea0fce179abe088 ]---


On Wed, Dec 9, 2009 at 10:19 AM, Yan, Zheng <yanzheng@21cn.com> wrote:
> On Wed, Dec 9, 2009 at 9:53 AM, Jian Lin <mail@linjian.org> wrote:
>> Hi,
>>
>> I am using Linux 2.6.32 on X86_64 with BtrFS compiled in the kernel.
>> For my experimental application, I want to evaluate reliability of C=
OW
>> feature of BtrFS.
>> I chose a small tool called fstest (http://code.google.com/p/fstest/=
)
>> and modified it:
>>
>> [root@node34 fstest-0.1.3]# diff fstest.c fstest-mod.c
>> 315c315
>> < =A0 =A0 unlink(p->filename);
>> ---
>>> =A0 =A0 //unlink(p->filename);
>> 317c317
>> < =A0 =A0 *file=3Dopen(p->filename, O_RDWR|O_CREAT|O_EXCL, 0777);
>> ---
>>> =A0 =A0 *file=3Dopen(p->filename, O_RDWR|O_CREAT/*|O_EXCL*/, 0777);
>> 360c360
>> < =A0 =A0 unlink(p.filename);
>> ---
>>> =A0 =A0 //unlink(p.filename);
>>
>> So, fstest-mod will ramdomly write and read blocks in a specific fil=
e,
>> and check whether it is consistent.
>> Then I made a zero-filled file and a clone of it, ran fstest-mod
>> respectively on the original and the cloned file:
>>
>> dd if=3D/dev/zero of=3Dtestbase bs=3D100 count=3D$((1024*1024))
>> cp --reflink testbase testbase-ref
>> [One Terminal] ./fstest-mod testbase $((100*1024*1024))
>> [Another Terminal] ./fstest-mod testbase-ref $((100*1024*1024))
>>
>> When the test files were small (~100M), both fstest-mod programs ret=
urned OK.
>> However, when I used bigger test files (2G), BtrFS did not respond
>> after a period of time.
>> It said:
>>
>> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
>> node34 kernel: ------------[ cut here ]------------
>> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
>> node34 kernel: invalid opcode: 0000 [#1] SMP
>> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
>> node34 kernel: last sysfs file:
>> /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
>> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
>> node34 kernel: Stack:
>> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
>> node34 kernel: Call Trace:
>> Message from syslogd@ at Wed Dec =A09 08:38:42 2009 ...
>> node34 kernel: Code: 24 10 4c 89 f6 e8 5a 16 fc ff 48 8b 7c 24 20 eb
>> 29 48 8d 6b f0 48 8b 74 24 10 48 8b 7c 24 18 48 89 ea e8 00 4b fd ff
>> 85 c0 74 04 <0f> 0b eb fe 48 89 df e8 c2 a9 05 00 48 89 ef e8 d2 93 =
f5
>> ff 48
>>
>
> Please send full messages of this oops, you can find them in /var/log=
/messages.
>
> Regards
> Yan Zheng
>



--=20
Jian Lin
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
