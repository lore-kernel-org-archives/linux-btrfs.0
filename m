From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: NOCOW + compress-force = bug
Date: Tue, 13 Mar 2012 14:36:00 -0400
Message-ID: <4F5F9390.3050909@suse.de>
References: <4F38B8F0.5020506@yahoo.com> <4F38BE53.4080204@parallels.com> <20120213141040.GG15350@twin.jikos.cz> <20120216195515.643f4aa7@natsu> <20120216175815.GM21896@shiny> <4F5F8DB9.40208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Roman Mamedov <rm@romanrm.ru>, dave@jikos.cz,
	dima <dolenin@parallels.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F5F8DB9.40208@suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/13/2012 02:11 PM, Jeff Mahoney wrote:
> On 02/16/2012 12:58 PM, Chris Mason wrote:
>> On Thu, Feb 16, 2012 at 07:55:15PM +0600, Roman Mamedov wrote:
>>> Hello,
>>> 
>>> Please be aware that there seems to be a possible problem with 
>>> using NOCOW flag on files situated on a filesystem mounted
>>> with compress-force(=lzo, in my case).
>>> 
>>> Since experimenting with NOCOW, I started regularly hitting
>>> this BUG at extent-tree.c:5813
>>> 
>>> 5813                 BUG_ON(!(flags & 
>>> BTRFS_BLOCK_FLAG_FULL_BACKREF));
>>> 
>>> I was unable to make netconsole work over a bridged interface,
>>> so can only post screenshots of this OOPS: 
>>> http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-1.jpg 
>>> http://romanrm.ru/pics/2012/2012-02-16-btrfs-bug-2.jpg
>>> 
>>> This happened four times already, and always on snapshot
>>> creation (but not every case). I have hourly snapshots in
>>> crontab, and only one case out of about ten fails with this
>>> problem. Did not try to deliberately reproduce it yet by
>>> manually making snapshots very often, etc.
> 
>> Interesting, NOCOW and compression don't really mix.  We always
>> cow for compression.  I'll try to reproduce it.
> 
> I hit this one today without nocow or compression. The only thing 
> non-default was that I mounted with -ossd. The backing store was a
> 1GB non-sparse loopback file on tmpfs.
> 
> I had kdump enabled and with 16GB, I wasn't waiting around for the 
> dump to complete. If it happens again, I'll have a full stack
> trace. My test case was filling the disk while making snapshots.

Well that didn't take long.

[  626.100684] ------------[ cut here ]------------
[  626.104053] kernel BUG at
/usr/src/packages/BUILD/kernel-default-3.0.23/linux-3.0/fs/btrfs/extent-tree.c:6091!
[  626.104053] invalid opcode: 0000 [#1] SMP
[  626.104053] CPU 8
[  626.104053] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
autofs4 edd nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 ipv6_lib
af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave
powernow_k8 mperf microcode fuse loop dm_mod igb i2c_piix4 i2c_core
k10temp sg dca rtc_cmos pcspkr button serio_raw ext3 jbd mbcache
ohci_hcd ehci_hcd usbcore sd_mod usb_common crc_t10dif processor
thermal_sys hwmon ata_generic ahci libahci pata_atiixp libata scsi_mod
[  626.104053] Supported: Yes
[  626.104053]
[  626.104053] Pid: 14214, comm: btrfs Not tainted
3.0.23-0.0.0.0.4dd40bc-default #1 HP ProLiant DL165 G7
[  626.104053] RIP: 0010:[<ffffffffa03cd623>]  [<ffffffffa03cd623>]
alloc_reserved_tree_block+0x1e3/0x1f0 [btrfs]
[  626.104053] RSP: 0018:ffff88020766fae8  EFLAGS: 00010246
[  626.104053] RAX: ffff880434b76000 RBX: 0000000000000e2c RCX:
0000000000000000
[  626.104053] RDX: ffff880000000000 RSI: 0000000000000000 RDI:
ffff880404690678
[  626.104053] RBP: ffff880436e7f670 R08: ffff88020766faa8 R09:
0000000000001000
[  626.104053] R10: 0000000000000e2b R11: b000000000000000 R12:
ffff880404690678
[  626.104053] R13: 0000000000000d9d R14: ffff880432ac15a0 R15:
ffff880437a01c80
[  626.104053] FS:  00007fabeaf13740(0000) GS:ffff88043fc00000(0000)
knlGS:0000000000000000
[  626.104053] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  626.104053] CR2: 00007fabea61bb50 CR3: 0000000402dc1000 CR4:
00000000000006e0
[  626.104053] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  626.104053] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  626.104053] Process btrfs (pid: 14214, threadinfo ffff88020766e000,
task ffff8802389260c0)
[  626.104053] Stack:
[  626.104053]  ffff88020766fb28 0000000000000000 0000000000000000
0000000004d3e000
[  626.104053]  ffff8800b220c000 ffff8804357bd000 0000003300000000
ffff88043977c540
[  626.104053]  ffff880437a01c80 ffff880432ac15a0 ffff8800b220c000
0000000000000001
[  626.104053] Call Trace:
[  626.104053]  [<ffffffffa03cdecc>] run_delayed_tree_ref+0xfc/0x150
[btrfs]
[  626.104053]  [<ffffffffa03ce21e>] run_clustered_refs+0xce/0x310 [btrfs]
[  626.104053]  [<ffffffffa03ce599>]
btrfs_run_delayed_refs+0x139/0x2e0 [btrfs]
[  626.104053]  [<ffffffffa03de553>]
btrfs_commit_transaction+0x433/0x8a0 [btrfs]
[  626.104053]  [<ffffffffa040a361>] create_snapshot+0x1a1/0x1c0 [btrfs]
[  626.104053]  [<ffffffffa040aa60>] btrfs_mksubvol+0x150/0x1e0 [btrfs]
[  626.104053]  [<ffffffffa040ac5b>]
btrfs_ioctl_snap_create_transid+0x16b/0x1a0 [btrfs]
[  626.104053]  [<ffffffffa040ad98>]
btrfs_ioctl_snap_create_v2+0x108/0x110 [btrfs]
[  626.104053]  [<ffffffffa040fbb7>] btrfs_ioctl+0x697/0x7d0 [btrfs]
[  626.104053]  [<ffffffff81162b7b>] do_vfs_ioctl+0x8b/0x3b0
[  626.104053]  [<ffffffff81162f41>] sys_ioctl+0xa1/0xb0
[  626.104053]  [<ffffffff8144ad12>] system_call_fastpath+0x16/0x1b
[  626.104053] DWARF2 unwinder stuck at system_call_fastpath+0x16/0x1b
[  626.104053]
[  626.104053] Leftover inexact backtrace:
[  626.104053]
[  626.104053] Code: 4c 89 e7 e8 50 76 02 00 e9 6b ff ff ff 48 8b 44
24 78 48 c7 c7 30 94 43 a0 48 8b 50 09 48 8b 30 31 c0 e8 47 2b 07 e1
0f 0b eb fe <0f> 0b eb fe 66 0f 1f 84 00 00 00 00 00 41 57 41 56 41 55
41 54
[  626.104053] RIP  [<ffffffffa03cd623>]
alloc_reserved_tree_block+0x1e3/0x1f0 [btrfs]
[  626.104053]  RSP <ffff88020766fae8>


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPX5OQAAoJEB57S2MheeWyxisP/37vZAl8f9N9OWwXKHiqybla
6nKCLN2DN0XaNNP/2hmjXh/V8AdU1ZQOR4apS1qrLIHXCZOoF3kJlTR5vrEwUxtW
GbkWr6t5TfSpdit+eSceADbGM9Yy7pi6AY830D7qj059dliLfbKHIw7k4gCbWQXa
STnh2ukeFYO75a9w7RbxxlK4I2Lt7Nf5Qmd8XZkyAJyvNqYrMhu/SXkpwz8rym3U
S0VH44zlKsLKSMNvn0dQYwKDZ5z1TbNgna9Wg1CpRYihVfAIjva58YXobkXHgZAb
eIuOoBuPEvdw+ZNSfKlB1a/TblcHUvgSteJYfcJu/EzgGIBKlzzIrR+TQZDegVnR
b4I/Jad/2Xm+1L9OZQHhJAaRetiY15aDtJ+R6+KewsQgYYILNXlIOMjA9+X646Wm
ypWQ6q6XjJ4XMEEGzXGEBfrJpUXeuWEXpQkRfxI7xvGmrXT8/r4yiEqrUVbWOoUa
EKMeN5u61HTXcUCdB0HtjAppO2mqFnuAVH/A4CkO3gRxVaOjPTFKIZszuxE/aJT5
Rs1VZMUoJtbLPu+npQpg2OLMUI8tdyt3RshSWEdynZaAk0utlH0lZa37shkniwe1
cK+tZwZJLQL8YLnBpF+BV9xn9dJTM82acjnOA5akSqyCXgrJcU5jrHYbiyqe44L6
I5rH1gzrESJKc9qU59Pz
=SpJv
-----END PGP SIGNATURE-----
