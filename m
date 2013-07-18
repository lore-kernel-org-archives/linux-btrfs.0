Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:25668 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3GRJAX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 05:00:23 -0400
Message-ID: <51E7AEA5.6080508@giantdisaster.de>
Date: Thu, 18 Jul 2013 11:00:21 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Gareth Pye <gareth@cerberos.id.au>
CC: Dan van der Ster <dan@vanderster.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: unfinished convert to raid6, enospc
References: <CABZ+qqnM4g9H1d4dCw9Ao3Kj7tKGJ7M1_oPkGjFKcheMrD=HMQ@mail.gmail.com> <CABZ+qqmm4X7FEWr=BuPwF_uPJ8Rdg9Le3d-iLnYfB+if3N-mzQ@mail.gmail.com> <51E7044C.2030805@giantdisaster.de> <CA+WRLO98iTCTSXLR5UqHY+8Az8BEdHsu=QbmNgGwfwF76bfdLw@mail.gmail.com>
In-Reply-To: <CA+WRLO98iTCTSXLR5UqHY+8Az8BEdHsu=QbmNgGwfwF76bfdLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 18 Jul 2013 09:01:26 +1000, Gareth Pye wrote:
> So I'm reading:
> 
> * Progs support for parity rebuild.  Missing drives upset the progs
> today, but the kernel does rebuild parity properly.
> 
> 
> wrong? As that sounds like the programs will bork but it can be
> mounted and it'll rebuild.

"No protection" like I wrote was wrong. The parity code is there. But the known and documented issue is that the current code rewrites disk blocks while they are referenced. This is the power loss issue. Until the improved RAID5/6 code is published, I cannot recommend to use Btrfs RAID5/6 if you like your data.

And I've seen that two failing disks on a Btrfs RAID6 filesystem caused a corrupt filesystem, the log of such a case is attached.

If you look at the log, sdu and sdi fail, some minutes later the "btrfs bad tree block start" messages occur. The two reported EIO errors on sdz seem to be the result since no hardware errors for sdz are reported (there are no related mpt2sas messages for sdz, and there are no Btrfs device statistic messages for sdz). Eventually, it was not possible to mount the filesystem anymore.


May 27 17:43:45 btrfs: setting 8 feature flag
May 27 17:43:45 btrfs: use lzo compression
May 27 17:43:45 btrfs: enabling inode map caching
May 27 17:43:45 btrfs: disk space caching is enabled
May 27 17:43:45 btrfs flagging fs with big metadata feature
[...]
May 30 15:07:19  sd 6:0:18:0: [sdu] Synchronizing SCSI cache
May 30 15:07:19  sd 6:0:18:0: [sdu]
May 30 15:07:19  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 30 15:07:19  mpt2sas0: removing handle(0x001c), sas_addr(0x50030480008b7bd6)
May 30 15:11:52  btrfs: bdev /dev/sdu errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
May 30 15:11:52  lost page write due to I/O error on /dev/sdu
May 30 15:11:52  btrfs: bdev /dev/sdu errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
[...]
May 30 15:12:56  sd 6:0:6:0: [sdi] Synchronizing SCSI cache
May 30 15:12:56  sd 6:0:6:0: [sdi]
May 30 15:12:56  Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
May 30 15:12:56  mpt2sas0: removing handle(0x0010), sas_addr(0x50030480008b7bca)
May 30 15:13:06  btrfs: bdev /dev/sdi errs: wr 0, rd 0, flush 1, corrupt 0, gen 0
May 30 15:13:07  lost page write due to I/O error on /dev/sdi
May 30 15:13:07  btrfs: bdev /dev/sdi errs: wr 1, rd 0, flush 1, corrupt 0, gen 0
[...]
May 30 15:13:36  btrfs: bdev /dev/sdu errs: wr 474, rd 0, flush 159, corrupt 0, gen 0
May 30 15:13:36  btrfs: bdev /dev/sdi errs: wr 165, rd 0, flush 56, corrupt 0, gen 0
May 30 15:14:12  btrfs bad tree block start 5363727999388487864 306642944
May 30 15:14:12  btrfs bad tree block start 6661525506344239944 306642944
May 30 15:14:12  btrfs bad tree block start 2349785282384153232 323960832
May 30 15:14:12  btrfs bad tree block start 343678018170920118 323960832
May 30 15:14:12  btrfs bad tree block start 2003655791289495711 323960832
May 30 15:14:12  btrfs bad tree block start 9327219462809738085 323960832
May 30 15:14:15  btrfs bad tree block start 10356026150932229840 323960832
May 30 15:14:15  btrfs bad tree block start 1515852799129945386 323960832
May 30 15:14:15  ------------[ cut here ]------------
May 30 15:14:15  WARNING: at fs/btrfs/super.c:254 __btrfs_abort_transaction+0xdd/0xf0 [btrfs]()
May 30 15:14:15  Hardware name: X8SIL
May 30 15:14:15  Modules linked in: mptctl mptbase btrfs raid6_pq xor bonding raid1 mpt2sas scsi_transport_sas raid_class
May 30 15:14:15  Pid: 21611, comm: btrfs-transacti Tainted: G        W    3.9.0+ #82
May 30 15:14:15  Call Trace:
May 30 15:14:15   [<ffffffffa00a7d00>] ? __btrfs_abort_transaction+0xa0/0xf0 [btrfs]
May 30 15:14:15   [<ffffffff81087a0a>] warn_slowpath_common+0x7a/0xc0
May 30 15:14:15   [<ffffffff81087af1>] warn_slowpath_fmt+0x41/0x50
May 30 15:14:15   [<ffffffffa00a7d3d>] __btrfs_abort_transaction+0xdd/0xf0 [btrfs]
May 30 15:14:15   [<ffffffffa00c1f6c>] btrfs_run_delayed_refs+0x49c/0x570 [btrfs]
May 30 15:14:15   [<ffffffffa00d2922>] btrfs_commit_transaction+0x82/0xb70 [btrfs]
May 30 15:14:15   [<ffffffff810acbd0>] ? wake_up_bit+0x40/0x40
May 30 15:14:15   [<ffffffffa00ca9f5>] transaction_kthread+0x1b5/0x230 [btrfs]
May 30 15:14:15   [<ffffffffa00ca840>] ? check_leaf.isra.108+0x340/0x340 [btrfs]
May 30 15:14:15   [<ffffffff810ac616>] kthread+0xd6/0xe0
May 30 15:14:15   [<ffffffff810e6d0d>] ? trace_hardirqs_on+0xd/0x10
May 30 15:14:15   [<ffffffff810ac540>] ? kthread_create_on_node+0x130/0x130
May 30 15:14:15   [<ffffffff81994dac>] ret_from_fork+0x7c/0xb0
May 30 15:14:15   [<ffffffff810ac540>] ? kthread_create_on_node+0x130/0x130
May 30 15:14:15  ---[ end trace 66a995824fe81c3c ]---
May 30 15:14:15  BTRFS error (device sdz) in btrfs_run_delayed_refs:2630: errno=-5 IO failure
May 30 15:14:15  BTRFS info (device sdz): forced readonly
May 30 15:14:15  BTRFS error (device sdz) in btrfs_run_delayed_refs:2630: errno=-5 IO failure
[...]
May 31 09:33:43  btrfs: open /dev/sdu failed
May 31 09:33:43  btrfs: open /dev/sdi failed
May 31 09:33:43  btrfs: allowing degraded mounts
May 31 09:33:43  btrfs: disk space caching is enabled
May 31 09:33:43  btrfs: bdev /dev/sdu errs: wr 513, rd 0, flush 171, corrupt 0, gen 0
May 31 09:33:43  btrfs: bdev /dev/sdi errs: wr 204, rd 0, flush 68, corrupt 0, gen 0
May 31 09:33:43  btrfs bad tree block start 11069366888604640046 627949568
May 31 09:33:43  Failed to read block groups: -5
May 31 09:33:43  btrfs: open_ctree failed



> 
> On Thu, Jul 18, 2013 at 6:53 AM, Stefan Behrens
> <sbehrens@giantdisaster.de> wrote:
>> On 07/17/2013 21:56, Dan van der Ster wrote:
>>>
>>> Well, I'm trying a balance again with -dconvert=raid6 -dusage=5 this
>>> time. Will report back...
>>>
>>> On Wed, Jul 17, 2013 at 3:34 PM, Dan van der Ster <dan@vanderster.com>
>>> wrote:
>>>>
>>>> Hi,
>>>> Two days ago I decided to throw caution to the wind and convert my
>>>> raid1 array to raid6, for the space and redundancy benefits. I did
>>>>
>>>> # btrfs fi balance start -dconvert=raid6 /media/btrfs
>>>>
>>>> Eventually today the balance finished, but the conversion to raid6 was
>>>> incomplete:
>>>>
>>>> # btrfs fi df /media/btrfs
>>>> Data, RAID1: total=693.00GB, used=690.47GB
>>>> Data, RAID6: total=6.36TB, used=4.35TB
>>>> System, RAID1: total=32.00MB, used=1008.00KB
>>>> System: total=4.00MB, used=0.00
>>>> Metadata, RAID1: total=8.00GB, used=6.04GB
>>>>
>>>> A recent btrfs balance status (before finishing) said:
>>>>
>>>> # btrfs balance status /media/btrfs
>>>> Balance on '/media/btrfs' is running
>>>> 4289 out of about 5208 chunks balanced (4988 considered),  18% left
>>>>
>>>> and at the end I have:
>>>>
>>>> [164935.053643] btrfs: 693 enospc errors during balance
>>>>
>>>> Here is the array:
>>>>
>>>> # btrfs fi show /dev/sdb
>>>> Label: none  uuid: 743135d0-d1f5-4695-9f32-e682537749cf
>>>> Total devices 7 FS bytes used 5.04TB
>>>> devid    2 size 2.73TB used 2.73TB path /dev/sdh
>>>> devid    1 size 2.73TB used 2.73TB path /dev/sdg
>>>> devid    5 size 1.36TB used 1.31TB path /dev/sde
>>>> devid    6 size 1.36TB used 1.31TB path /dev/sdf
>>>> devid    4 size 1.82TB used 1.82TB path /dev/sdd
>>>> devid    3 size 1.82TB used 1.82TB path /dev/sdc
>>>> devid    7 size 1.82TB used 1.82TB path /dev/sdb
>>>>
>>>>
>>>> I'm running latest stable, plus the patch "free csums when we're done
>>>> scrubbing an extent" (otherwise I get OOM when scrubbing).
>>>>
>>>> # uname -a
>>>> Linux dvanders-webserver 3.10.1+ #1 SMP Mon Jul 15 17:07:19 CEST 2013
>>>> x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>> I still have plenty of free space:
>>>>
>>>> # df -h /media/btrfs
>>>> Filesystem      Size  Used Avail Use% Mounted on
>>>> /dev/sdd         14T  5.8T  2.2T  74% /media/btrfs
>>>>
>>>> Any idea how I can get out of this? Thanks!
>>
>>
>> You know the limitations of the current Btrfs RAID5/6 implementation, don't
>> you? No protection against power loss or disk failures. No support for
>> scrub. These limits are explained very explicitly in the commit message:
>>
>> http://lwn.net/Articles/536038/
>>
>> I'd recommend Btrfs RAID1 for the time being.

