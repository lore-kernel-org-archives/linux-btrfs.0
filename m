Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:60667 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaEABwk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 21:52:40 -0400
From: Russell Coker <russell@coker.com.au>
To: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: Help with space
Date: Thu, 01 May 2014 11:52:33 +1000
Message-ID: <2809235.lZD2oazSeA@xev>
In-Reply-To: <20140228103436.2dfd2669@natsu>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <20140228103436.2dfd2669@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 28 Feb 2014 10:34:36 Roman Mamedov wrote:
> > I've a 18 tera hardware raid 5 (areca ARC-1170 w/ 8 3 gig drives) in
> 
> Do you sleep well at night knowing that if one disk fails, you end up with
> basically a RAID0 of 7x3TB disks? And that if 2nd one encounters unreadable
> sector during rebuild, you lost your data? RAID5 actually stopped working 5
> years ago, apparently you didn't get the memo. :)
> http://hardware.slashdot.org/story/08/10/21/2126252/why-raid-5-stops-working
> -in-2009

I've just been doing some experiments with a failing disk used for backups (so 
I'm not losing any real data here).  The "dup" option for metadata means that 
the entire filesystem structure is intact in spite of having lots of errors 
(in another thread I wrote about getting 50+ correctable errors on metadata 
while doing a backup).

My experience is that in the vast majority of disk failures that don't involve 
dropping a disk the majority of disk data will still be readable.  For example 
one time I had a workstation running RAID-1 get too hot in summer and both 
disks developed significant numbers of errors, enough that it couldn't 
maintain a Linux Software RAID-1 (disks got kicked out all the time).  I wrote 
a program to read all the data from disk 0 and read from disk 1 any blocks 
that couldn't be read from disk 0, the result was that after running e2fsck on 
the result I didn't lose any data.

So if you have BTRFS configured to "dup" metadata on a RAID-5 array (either 
hardware RAID or Linux Software RAID) then the probability of losing metadata 
would be a lot lower than for a filesystem which doesn't do checksums and 
doesn't duplicate metadata.  To lose metadata you would need to have two 
errors that line up with both copies of the same metadata block.

One problem with many RAID arrays is that it seems to only be possible to 
remove a disk and generate a replacement from parity.  I'd like to be able to 
read all the data from the old disk which is readable and write it to the new 
disk.  Then use the parity from other disks to recover the blocks which 
weren't readable.  That way if you have errors on two disks it won't matter 
unless they both happen to be on the same stripe.  Given that BTRFS RAID-5 
isn't usable yet it seems that the only way to get this result is to use RAID-
Z on ZFS.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

