From: David Sterba <dave@jikos.cz>
Subject: Re: BUG at fs/btrfs/tree-log.c:3106 (Re: new integration-danger branch pushed out (kernel))
Date: Tue, 1 Nov 2011 17:16:29 +0100
Message-ID: <20111101161629.GH12759@twin.jikos.cz>
References: <20111101024957.GH4468@shiny> <20111101103637.GD12759@twin.jikos.cz> <20111101105650.GB9554@shiny>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Chris Mason <chris.mason@oracle.com>, liubo2009@cn.fujitsu.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101105650.GB9554@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 06:56:50AM -0400, Chris Mason wrote:
> On Tue, Nov 01, 2011 at 11:36:37AM +0100, David Sterba wrote:
> > xfstests/214
> > 
> > [ 3142.654774] ------------[ cut here ]------------
> > [ 3142.656017] kernel BUG at fs/btrfs/tree-log.c:3106!
> 
> What kind of hardware are you running this on?  I'm passing 214 here.

this is some old piece of hw, intel 2x 2.2Ghz CPU, 2GB memory, ICH8, SATA
controller is 82801HBM/HEM.

partition setup:

SCRATCH
Label: none  uuid: b3aabfae-69f6-4b9b-9dc0-e1ec3472183c
        Total devices 1 FS bytes used 11.32MB
        devid    1 size 104.00MB used 104.00MB path /dev/sda9

TEST
Label: none  uuid: d0e2fc5f-8a72-4c54-bee3-3c8ae1766ade
        Total devices 4 FS bytes used 15.16MB
        devid    4 size 10.00GB used 1.01GB path /dev/sda8
        devid    3 size 10.00GB used 1.01GB path /dev/sda7
        devid    2 size 10.00GB used 2.00GB path /dev/sda6
        devid    1 size 10.00GB used 2.02GB path /dev/sda5

mkfs was default.


the second box, which reproduced this same BUG, is 8 CPU AMD,
partition setup is:

Label: none  uuid: 686f0422-2bc5-4265-a4a7-f17f21cdcfd0
        Total devices 1 FS bytes used 11.31MB
        devid    1 size 104.00MB used 104.00MB path /dev/sda9

Label: none  uuid: c17552f9-4727-411d-9b75-5d84a1c5ba66
        Total devices 4 FS bytes used 13.18MB
        devid    4 size 30.00GB used 30.00GB path /dev/sda8
        devid    3 size 30.00GB used 30.00GB path /dev/sda7
        devid    2 size 30.00GB used 30.00GB path /dev/sda6
        devid    1 size 30.00GB used 30.00GB path /dev/sda5

and the crashdump is

[ 5326.176937] ------------[ cut here ]------------
[ 5326.180791] kernel BUG at fs/btrfs/tree-log.c:3106!
[ 5326.180791] invalid opcode: 0000 [#1] SMP
[ 5326.180791] CPU 5
[ 5326.180791] Modules linked in: btrfs zlib_deflate crc32c libcrc32c edd nfs lockd fscache auth_rpcgss nfs_acl sunrpc af_packet bridge ipv6 stp llc cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 mperf microcode fuse loop dm_mod kvm_amd kvm tpm_infineon tg3 amd64_edac_mod edac_core shpchp edac_mce_amd i2c_piix4 i2c_core pcspkr tpm_tis tpm tpm_bios pci_hotplug sg sr_mod k10temp cdrom rtc_cmos button mptctl ext3 jbd mbcache ohci_hcd ehci_hcd usbcore sd_mod crc_t10dif fan thermal processor thermal_sys hwmon ide_pci_generic serverworks ide_core ata_generic sata_svw pata_serverworks libata mptsas mptscsih mptbase scsi_transport_sas scsi_mod [last unloaded: floppy]
[ 5326.180791]
[ 5326.180791] Pid: 17588, comm: xfs_io Tainted: G        W   3.1.0-default+ #3
[ 5326.180791] RIP: 0010:[<ffffffffa05e0504>]  [<ffffffffa05e0504>] btrfs_log_inode+0x4c4/0x680 [btrfs]
[ 5326.180791] RSP: 0018:ffff880054857d18  EFLAGS: 00010282
[ 5326.180791] RAX: 00000000ffffffef RBX: 0000000000000353 RCX: ffff88011d703300
[ 5326.180791] RDX: 000000000000002e RSI: 0000000000000001 RDI: 0000000000000286
[ 5326.180791] RBP: ffff880054857e38 R08: ffff880054857aa8 R09: 0000000000001000
[ 5326.180791] R10: 00000000000000da R11: 0000000000000000 R12: ffff8801297eb400
[ 5326.180791] R13: 0000000000000003 R14: ffff880024d781e0 R15: ffff88011861f1d8
[ 5326.180791] FS:  00007f2c3354e700(0000) GS:ffff88012fc80000(0000) knlGS:0000000000000000
[ 5326.180791] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5326.180791] CR2: 00007f4d712f8c30 CR3: 0000000127a31000 CR4: 00000000000006e0
[ 5326.180791] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5326.180791] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5326.180791] Process xfs_io (pid: 17588, threadinfo ffff880054856000, task ffff880076a26300)
[ 5326.180791] Stack:
[ 5326.180791]  ffff880000000000 0007ffffffffffff ffff880054857d78 00000000810e85e0
[ 5326.180791]  ffff88007ba7f000 ffff8801101e8108 0000000000000000 0000000000000c23
[ 5326.180791]  0000000000000c23 ffff88011861f0e0 ffff880110030ac0 0000001c00000000
[ 5326.180791] Call Trace:
[ 5326.180791]  [<ffffffff810e9db3>] ? filemap_fdatawait_range+0x93/0x150
[ 5326.180791]  [<ffffffffa05e080c>] btrfs_log_inode_parent+0x14c/0x2d0 [btrfs]
[ 5326.180791]  [<ffffffffa05ac55f>] ? join_transaction+0x1f/0x250 [btrfs]
[ 5326.180791]  [<ffffffffa05e0a44>] btrfs_log_dentry_safe+0x44/0x70 [btrfs]
[ 5326.180791]  [<ffffffffa05badbf>] btrfs_sync_file+0x16f/0x1c0 [btrfs]
[ 5326.180791]  [<ffffffff81172283>] vfs_fsync_range+0x23/0x30
[ 5326.180791]  [<ffffffff811722a7>] vfs_fsync+0x17/0x20
[ 5326.180791]  [<ffffffff811724b5>] do_fsync+0x35/0x60
[ 5326.180791]  [<ffffffff8117250b>] sys_fsync+0xb/0x10
[ 5326.180791]  [<ffffffff814232d2>] system_call_fastpath+0x16/0x1b
[ 5326.180791] Code: 3c ff ff ff 45 89 e9 48 8b bd 08 ff ff ff 4c 89 f1 4c 89 fe 89 14 24 48 8b 95 30 ff ff ff e8 e4 f6 ff ff 85 c0 0f 84 c5 fc ff ff <0f> 0b eb fe 0f 1f 84 00 00 00 00 00 45 85 ed 74 33 8b 85 fc fe
[ 5326.180791] RIP  [<ffffffffa05e0504>] btrfs_log_inode+0x4c4/0x680 [btrfs]
[ 5326.180791]  RSP <ffff880054857d18>
[ 5326.482211] ---[ end trace 0a323c63265b6de4 ]---

[while writing this mail, testbox1 just tripped over the BUG again]

In both cases, the xfstests suite was run on clean mkfs and from test 001 on.

I see that process "rm -f /mnt/sda5/ouch2" is stuck at

$ cat /proc/17594/stack
[<ffffffff81152ae1>] vfs_unlink+0x61/0x120
[<ffffffff81156723>] do_unlinkat+0x1d3/0x1e0
[<ffffffff811568ad>] sys_unlinkat+0x1d/0x40
[<ffffffff814232d2>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

So, bug is reproducible quite reliably.


david
