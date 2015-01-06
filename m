Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pl1.haspere.com ([209.177.156.123]:55960 "EHLO pl1.haspere.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbbAFO6h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 09:58:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 06 Jan 2015 08:58:36 -0600
From: Dyweni - BTRFS <Y4BwxfPC4k5h@dyweni.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, chris@colorremedies.com
Subject: Re: BTRFS: Transaction aborted (error -5)
Reply-To: Y4BwxfPC4k5h@dyweni.com
In-Reply-To: <CAJCQCtSqTzOywjiZXeSdrw2nLYzyMZBnWSMmzbtVgeZthizv4w@mail.gmail.com>
References: <4ac53d9eeb92abf031b2b68c1b130215@pl1.haspere.com>
 <CAJCQCtSqTzOywjiZXeSdrw2nLYzyMZBnWSMmzbtVgeZthizv4w@mail.gmail.com>
Message-ID: <38283e0340cace0d4f9a640cfc634b43@localhost>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

>> [32079.815291] BTRFS info (device sdd1): disk space caching is enabled
>> [32082.419524] BTRFS: sdd1 checksum verify failed on 588447744 wanted
>> F90C810B found 6E0D3115 level 0
>> [32114.418433] BTRFS: sdd1 checksum verify failed on 588447744 wanted
>> F90C810B found 6E0D3115 level 0
>> [32125.951446] BTRFS: sdd1 checksum verify failed on 588447744 wanted
>> F90C810B found 6E0D3115 level 0
>> [32125.959497] BTRFS: sdd1 checksum verify failed on 588447744 wanted
>> F90C810B found 24492BB3 level 0
> 
> Well I'm no expert, but it seems suspicious to me it doesn't find what
> it wants on a particular block twice, but then on the 3rd attempt it
> finds something different on the same block which also isn't what it
> wants. So that sounds like a device problem to me. Is this an SSD?
> What are your mount options (are you using discard)? And what's the
> metadata profile, is it single or DUP? I'm gonna guess it's an SSD
> with single copy of metadata which is why this isn't self-correcting.
> 


So I finished testing the drive using 'badblocks -n -s -v' (the
non-destructive read-write mode).  It came back clean, no bad blocks
found.  This I did with the entire drive unmounted.

Yet, still, the file system reports the errors shortly after mounting.
(See below)

This drive is an older spinning type drive.  This is the drive as
reported by 'lsscsi':

[3:0:0:0]    disk    ATA      WDC WD1001FALS-0 1D05  /dev/sdd

Newegg lists it as a 'Western Digital WD Black WD1001FALS 1TB 7200 RPM
32MB Cache SATA 3.0Gb/s 3.5" Internal Hard Drive Bare Drive'

The disk is attached to the system via this, as reported by 'lspci':

01:09.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial 
ATA Controller (rev 02)

(Not sure why it lists it as a raid controller or a pci-x controller, as
I used it a simple sata controller and it plugs into a regular 32bit
pci slot).

The motherboard is a Micro-Star MS-6570, with an AMD Athlon XP 3000+
(2171 MHz) processor and 2GB of RAM.

Mount options are only: noatime

BTRFS Profile is:

# btrfs fi df /var/lib/ceph/osd/ceph-1/
Data, single: total=185.01GiB, used=183.39GiB
System, DUP: total=8.00MiB, used=48.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=1.00GiB, used=367.19MiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=128.00MiB, used=0.00B






[162288.768747] BTRFS info (device sdc1): disk space caching is enabled
[162290.463003] BTRFS info (device sdd1): disk space caching is enabled
[162335.594094] BTRFS: sdd1 checksum verify failed on 588447744 wanted 
F90C810B found 6E0D3115 level 0
[162335.595476] BTRFS: sdd1 checksum verify failed on 588447744 wanted 
F90C810B found 6E0D3115 level 0
[162335.602066] BTRFS: sdd1 checksum verify failed on 588447744 wanted 
F90C810B found 24492BB3 level 0
[162335.602075] ------------[ cut here ]------------
[162335.602085] WARNING: CPU: 0 PID: 31841 at fs/btrfs/super.c:260 
__btrfs_abort_transaction+0x43/0x110()
[162335.602086] BTRFS: Transaction aborted (error -5)
[162335.602087] Modules linked in: iscsi_trgt(O)
[162335.602094] CPU: 0 PID: 31841 Comm: btrfs-cleaner Tainted: G         
   O   3.18.1-gentoo-20150104-0921 #1
[162335.602096] Hardware name:    /MS-6570, BIOS 6.00 PG 11/07/2003
[162335.602097]  e68a5e68 e68a5e68 e68a5e28 c14e48a4 e68a5e58 c10345a0 
c15cbefc e68a5e84
[162335.602101]  00007c61 c15d895b 00000104 c11cff13 c11cff13 fffffffb 
f4d23800 c150d330
[162335.602104]  e68a5e70 c10345ee 00000009 e68a5e68 c15cbefc e68a5e84 
e68a5e9c c11cff13
[162335.602108] Call Trace:
[162335.602117]  [<c14e48a4>] dump_stack+0x16/0x18
[162335.602122]  [<c10345a0>] warn_slowpath_common+0x70/0x90
[162335.602125]  [<c11cff13>] ? __btrfs_abort_transaction+0x43/0x110
[162335.602127]  [<c11cff13>] ? __btrfs_abort_transaction+0x43/0x110
[162335.602130]  [<c10345ee>] warn_slowpath_fmt+0x2e/0x30
[162335.602133]  [<c11cff13>] __btrfs_abort_transaction+0x43/0x110
[162335.602138]  [<c11ea884>] btrfs_run_delayed_refs.part.73+0xd4/0x1d0
[162335.602140]  [<c11ea98f>] btrfs_run_delayed_refs+0xf/0x20
[162335.602143]  [<c11f96f4>] btrfs_should_end_transaction+0x34/0x50
[162335.602146]  [<c11e8ef9>] btrfs_drop_snapshot+0x1c9/0x740
[162335.602149]  [<c11fb152>] btrfs_clean_one_deleted_snapshot+0x62/0x90
[162335.602152]  [<c11f2a49>] cleaner_kthread+0xd9/0x110
[162335.602155]  [<c11f2970>] ? btrfs_destroy_pinned_extent+0x120/0x120
[162335.602160]  [<c1047415>] kthread+0x95/0xb0
[162335.602164]  [<c14e9100>] ret_from_kernel_thread+0x20/0x30
[162335.602166]  [<c1047380>] ? kthread_worker_fn+0xb0/0xb0
[162335.602168] ---[ end trace ba640116f371d2ff ]---
[162335.602171] BTRFS: error (device sdd1) in 
btrfs_run_delayed_refs:2792: errno=-5 IO failure
[162335.602173] BTRFS info (device sdd1): forced readonly







