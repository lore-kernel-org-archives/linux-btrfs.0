Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48635 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750746AbaB1FtZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Feb 2014 00:49:25 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140228042132.GB13647@dastard>
Date: Thu, 27 Feb 2014 22:49:20 -0700
Cc: otakujunction@gmail.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <C5E96FD5-8D97-4B24-83D2-79BDCE32557D@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com> <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com> <B2988EF9-46EB-4804-A024-EE3B3A9E8771@gmail.com> <819E17EB-E4C2-4BD7-8D55-8C8DF9B8573B@colorremedies.com> <20140228001250.GA13647@dastard> <C6A844E6-3258-4405-9024-282D1EBD06CB@colorremedies.com> <20140228042132.GB13647@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 27, 2014, at 9:21 PM, Dave Chinner <david@fromorbit.com> wrote:
>> 
>> http://lists.centos.org/pipermail/centos/2011-April/109142.html
> 
> <sigh>
> 
> No, he didn't fill it with 16TB of data and then have it fail. He
> made a new filesystem *larger* than 16TB and tried to mount it:
> 
> | On a CentOS 32-bit backup server with a 17TB LVM logical volume on
> | EMC storage.  Worked great, until it rolled 16TB.  Then it quit
> | working.  Altogether.  /var/log/messages told me that the
> | filesystem was too large to be mounted. Had to re-image the VM as
> | a 64-bit CentOS, and then re-attached the RDM's to the LUNs
> | holding the PV's for the LV, and it mounted instantly, and we
> | kept on trucking.
> 
> This just backs up what I told you originally - that XFS has always
> refused to mount >16TB filesystems on 32 bit systems.

That isn't how I read that at all. It was a 17TB LV, working great (i.e. mounted) until it was filled with 16TB, then it quite working and could not subsequently be mounted until put on a 64-bit kernel.

I don't see how it's "working great" if it's not mountable.



> 
>>> I said that it was limited on XFS, not that the limit was a
>>> result of a user making a filesystem too large and then finding
>>> out it didn't work. Indeed, you can't do that on XFS - mkfs will
>>> refuse to run on a block device it can't access the last block
>>> on, and the kernel has the same "can I access the last block of
>>> the filesystem" sanity checks that are run at mount and growfs
>>> time.
>> 
>> Nope. What I reported on the XFS list, I had used mkfs.xfs while
>> running 32bit kernel on a 20TB virtual disk. It did not fail to
>> make the file system, it failed only to mount it.
> 
> You said no such thing. All you said was you couldn't mount a
> filesystem > 16TB - you made no mention of how you made the fs, what
> the block device was or any other details.

All correct. It wasn't intended as a bug report, it seemed normal. What I reported = the mount failure.

VBox 25TB VDI as a single block device, as well as 5x 5TB VDIs in an 20TB linear LV, as well as a 100TB virtual size LV using LVM thinp - all can be formatted with default mkfs.xfs with no complaints.

3.13.4-200.fc20.i686+PAE
xfsprogs-3.1.11-2.fc20.i686


> 
>> It was the same
>> booted virtual machine, I created the file system and immediately
>> mounted it. If you want the specifics, I'll post on the XFS list
>> with versions and reproduce steps.
> 
> Did you check to see whether the block device silently wrapped at
> 16TB? There's a real good chance it did - but you might have got
> lucky because mkfs.xfs uses direct IO and *maybe* that works
> correctly on block devices on 32 bit systems. I wouldn't bet on it,
> though, given it's something we don't support and therefore never
> test….

I did not check to see if any of the block devices silently wrapped, I don't know how to do that although I have a strace of the mkfs on the 100TB virtual LV here:

https://dl.dropboxusercontent.com/u/3253801/mkfsxfs32bit100TBvLV.txt


Chris Murphy