Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:6417 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753553AbdCBAoz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Mar 2017 19:44:55 -0500
Subject: Re: [4.7.2] btrfs_run_delayed_refs:2963: errno=-17 Object already
 exists
To: Marc Joliet <marcec@gmx.de>, <linux-btrfs@vger.kernel.org>
References: <20160828152908.6e1325b5@jupiter.sol.kaishome.de>
 <11009787.rdtfuSitqF@thetick>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <185b5213-f036-04f8-cf8f-fbe5f3351139@cn.fujitsu.com>
Date: Thu, 2 Mar 2017 08:43:53 +0800
MIME-Version: 1.0
In-Reply-To: <11009787.rdtfuSitqF@thetick>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 02/02/2017 08:01 PM, Marc Joliet wrote:
> On Sunday 28 August 2016 15:29:08 Kai Krakow wrote:
>> Hello list!
>
> Hi list
[kernel message snipped]
>
>> Btrfs --repair refused to repair the filesystem telling me something
>> about compressed extents and an unsupported case, wanting me to take an
>> image and send it to the devs. *sigh*
>
> I haven't tried a repair yet; it's a big file system, and btrfs-check is still
> running:
>
> # btrfs check -p /dev/sdd2
> Checking filesystem on /dev/sdd2
> UUID: f97b3cda-15e8-418b-bb9b-235391ef2a38
> parent transid verify failed on 3829276291072 wanted 224274 found 283858
> parent transid verify failed on 3829276291072 wanted 224274 found 283858
> parent transid verify failed on 3829276291072 wanted 224274 found 283858
> parent transid verify failed on 3829276291072 wanted 224274 found 283858

Normal transid error, can't say much about if it's harmless, but at 
least some thing went wrong.

> Ignoring transid failure
> leaf parent key incorrect 3829276291072
> bad block 3829276291072

That's some what a big problem for that tree block.

If this tree block is extent tree block, no wonder why kernel output 
kernel warning and abort transaction.

You could try "btrfs-debug-tree -b 3829276291072 <device>" to show the 
content of the tree block.

If it's an extent tree block, then I'm afraid that's the problem.
Not sure if repair can repair such problem, but at least from what I see 
in btrfs-progs fsck self testcases, it doesn't handle extent tree error 
well.

>
> ERROR: errors found in extent allocation tree or chunk allocation
> block group 4722282987520 has wrong amount of free space
> failed to load free space cache for block group 4722282987520
> checking free space cache [O]
> root 32018 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32089 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32091 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32092 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32107 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32189 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32190 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32191 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32265 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32266 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32409 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32410 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32411 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32412 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32413 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32631 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32632 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32633 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32634 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32635 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32636 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32718 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096
> root 32732 inode 95066 errors 100, file extent discount
> Found file extent holes:
>         start: 413696, len: 4096

File extent holes are completely fine, one of the few problems we can 
fix safely in btrfs-check.

But previous extent tree one is not.

If lowmem mode also reports the same problems only (file extent discount 
+ extent tree error), then there is a chance that --init-extent-tree may 
help.

But it will be super time consuming though.

Thanks,
Qu

> checking fs roots [o]
>
> I know that the "file extend discount" errors are fixable from my previous
> email to this ML, but what about the rest?  From looking through the ML
> archives it seems that --repair won't be able to fix the transid failures.  It
> seems that one person had success with the "usebackuproot" mount option, which
> I haven't tried yet.
>
>> System is kernel 4.7.2, Gentoo Linux, latest VirtualBox stable.
>> VirtualBox was using VDI image format without nocow. I now reverted
>> back to using nocow on VDI files and hope it doesn't strike again too
>> soon. I didn't try again yet, first I need to refresh my backup which
>> takes a while.
>>
>> The filesystem runs on 3x SATA 1TB mraid1 draid0 through bcache in
>> writeback mode, backed by a 500GB 850 Evo - if that matters.
>>
>> The problem occurred during high IO on 4.7.2. I previously ran 4.6.6
>> which didn't show this problem. Part of the culprit may be that I was
>> using bfq patches - I removed them for now and went back to deadline io
>> scheduler. The bfq patches froze my system a few times when I booted
>> 4.7.2 which may already have broken my btrfs (although it shouldn't,
>> right? btrfs is transactional). Last time this happened (on an earlier
>> kernel), bfq may have been part of the problem, too. So I think bfq
>> does something to btrfs which may break the fs, or at least interferes
>> badly with the transaction as otherwise it shouldn't break. You may
>> want to run your test suites with bfq also (or different io schedulers
>> in general).
>>
>> My home partition is mounted as a subvolume:
>> /dev/bcache0 on /home type btrfs
>> (rw,noatime,compress=lzo,nossd,space_cache,autodefrag,subvolid=261,subvol=/
>> home)
>
> The system the drive runs on is:
>
> % uname -a
> Linux diefledermaus 4.9.7-gentoo #1 SMP Wed Feb 1 23:52:56 CET 2017 x86_64
> Intel(R) Core(TM)2 CPU T5600 @ 1.83GHz GenuineIntel GNU/Linux
>
> However during the crash it was running 4.9.6-gentoo.  The system uses the
> standard CFQ scheduler, so perhaps BFQ is not at fault in Kai's case.
>
> The system I am running btrfs-check on is:
>
> % uname -a
> Linux thetick 4.9.6-gentoo #1 SMP PREEMPT Fri Jan 27 00:50:02 CET 2017 x86_64
> AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD GNU/Linux
>
> Both have btrfs-progs 4.9:
>
> % /sbin/btrfs --version
> btrfs-progs v4.9
>
> And the file system in question:
>
> % sudo /sbin/btrfs fi show /dev/sdd2
> Label: 'MARCEC_BACKUP'  uuid: f97b3cda-15e8-418b-bb9b-235391ef2a38
>         Total devices 1 FS bytes used 842.50GiB
>         devid    1 size 976.56GiB used 877.31GiB path /dev/sdd2
>
> The file system is mounted with "noatime,compress,comment=systemd.automount".
>
> In my case the crash also happened during high I/O load (three btrfs-
> send/receive backups running at the same time).  If "usebackuproot" (now
> called "recovery"?) fails, then I'll just wipe the FS and start the backups
> from scratch.
>
> Since I would like to have that done by Saturday: is there any information I
> can provide that might help fix whatever bug(s) caused this?  Should I file a
> bug if one doesn't exist yet (I haven't checked yet, sorry)?
>
> Greetings
>


