Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55170 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754190Ab3LUXkh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Dec 2013 18:40:37 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unmountable Array After Drive Failure During Device Deletion
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52B62166.2080407@gmail.com>
Date: Sat, 21 Dec 2013 16:40:36 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <1B0DC9ED-47DA-42D9-AE18-9A2724F5806A@colorremedies.com>
References: <52B2BBE1.8090306@gmail.com> <724763DD-956D-4A88-A6DA-E178E246536B@colorremedies.com> <52B38A05.9060407@gmail.com> <A2FBF80C-4BD4-43CD-ACA2-A2125027E701@colorremedies.com> <52B62166.2080407@gmail.com>
To: Chris Kastorff <encryptio@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 21, 2013, at 4:16 PM, Chris Kastorff <encryptio@gmail.com> wrote:
>> 
>> 1. btrfs-image -c 9 -t <#cores> (see man page)
>> This is optional but one of the devs might want to see this because it should be a more rare case that either normal mount fix ups or additional recovery fix ups can't deal with this problem.
> 
> This fails:
> 
> deep# ./btrfs-image -c 9 -t 4 /dev/sda btrfsimg
> warning, device 14 is missing
> warning devid 14 not found already
> parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
> parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
> Ignoring transid failure
> parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
> Ignoring transid failure
> Error going to next leaf -5
> create failed (Bad file descriptor)

Well, that's unfortunate. Someone else is going to have to comment on the confusion of the tools trying to fix the file system while a device is missing, which cannot be removed due to the fact the file system can't be mounted, because it needs to be fixed first. Circular problem.

> 
>> 3. Try to mount again with -o degraded,recovery and report back.
> 
> Since btrfs-zero-log (probably) didn't modify anything, the error
> message is the same:
> 
> btrfs: allowing degraded mounts
> btrfs: enabling auto recovery
> btrfs: disk space caching is enabled
> btrfs: bdev (null) errs: wr 344288, rd 230234, flush 0, corrupt 0, gen 0
> btrfs: bdev /dev/sdm1 errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> btrfs: bdev /dev/sdg errs: wr 0, rd 0, flush 0, corrupt 4, gen 0
> parent transid verify failed on 87601117097984 wanted 4893969 found 4892460
> Failed to read block groups: -5
> btrfs: open_ctree failed

How about:

-o skip_balance,degraded,recovery

If that fails, try:


-o skip_balance,degraded,recovery,ro

The ro file system probably doesn't let you delete missing, but it's worth a shot because the seems to be limiting repairs due to the missing device.

If you still have failure, it's worth repeating with the absolute latest kernel you can find or even build.

After that it gets really aggressive to dangerous and I'm not sure what to recommend next except avoid btrfs check --repair until dead last. I'd sooner go for the ro mount and use btrfs send/receive to get the current data you want off the file system, and create a new one from scratch. 

> 
> btrfs-zero-log's "Unable to find block group for 0" combined with the
> earlier kernel message on mount attempts "btrfs: failed to read the
> system array on sdc" and btrfsck's "Couldn't map the block %ld" tells me
> the (first) underlying problem is that the block group tree(?) in the
> system allocated data is screwed up.
> 
> I have no idea where to go from here, aside from grabbing a compiler and
> having at the disk structures myself.

There are some other options but they get progressively and quickly into possibly making things a lot worse. At a certain point it's an extraction operation rather than repair and continue.

Chris Murphy

