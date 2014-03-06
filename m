Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35157 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbaCFHl3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Mar 2014 02:41:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLSvm-0003ec-Ny
	for linux-btrfs@vger.kernel.org; Thu, 06 Mar 2014 08:41:26 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 08:41:26 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Mar 2014 08:41:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Thu, 6 Mar 2014 07:41:01 +0000 (UTC)
Message-ID: <pan$23ceb$3bedfe62$bfb976de$e16d8fde@cox.net>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
	<20140303183911.GL13899@carfax.org.uk>
	<DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
	<73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com>
	<loom.20140305T190503-404@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Russo posted on Wed, 05 Mar 2014 22:13:10 +0000 as excerpted:

> Chris Murphy <lists <at> colorremedies.com> writes:
> 
>> You could also try a full defragment by specifying -r on the mount
>> point with a small -t value to effectively cause everything to be
>> subject to defragmenting. If this still doesn't permit soft rebalance,
>> then maybe filefrag can find files that have more than 1 extent and
>> just copy them (make duplicates, delete the original). Any copy will be
>> allocated into chunks with the new profile.
> 
> I would think so too.  But it doesn't seem to be happening.
> Here is an example with one file:
> 
> root@ossy:/mymedia# filefrag output.wav output.wav: 2 extents found
> root@ossy:/mymedia# /usr/src/btrfs-progs/btrfs fi de -t 1
> /mymedia/output.wav root@ossy:/mymedia# filefrag output.wav output.wav:
> 2 extents found
> 
> btrfs does not defrag the file. And copying the file usually doesn't
> defrag it either:
> 
> root@ossy:/mymedia# cp output.wav output.wav.bak root@ossy:/mymedia#
> filefrag output.wav.bak output.wav.bak: 2 extents found
> 
> I even tried copying a large file to another filesystem (/dev/shm),
>  removing the original, and copying it back, and more often than not
> it still had more than 1 extent.

This was covered in one thread recently, but looking back in this one I 
didn't find it covered here, so...

What are your mount options?  Do they include compress and/or compress-
force?  Because filefrag doesn't understand btrfs compression yet and 
counts each 128 KiB (I believe) compression block as a separate extent.  
I'm not sure whether that's 128 KiB pre-compression or post-compression 
size, and I'm not even positive it's 128 KiB, but certainly, if the file 
is large enough and btrfs is compressing it, filefrag will false-positive 
report multiple extents.  That's a known issue with it ATM.

Meanwhile, there's ongoing work to teach filefrag about btrfs compression 
so it can report fragmentation accurately, but from what I've read 
they're working on a general kernel-VFS-level API for that so the same 
general API can be used by other filesystems, and getting proper 
agreement on that API, and having both the kernel and filefrag implement 
it isn't a simple single-kernel-cycle project.  There's a lot of 
filesystems other than btrfs that could potentially use this sort of 
thing, and getting a solution that will work well for all of them is hard 
work, both technically and politically.  But once it's implemented, /
correctly/, the entire Linux kernel filesystem space will benefit, just 
as btrfs is getting the benefit of the filefrag tool that ships with 
e2fsprogs, and the filesystem testing that ships as xfstests. =:^)

But if you're not using compression, /that/ can't explain it...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

