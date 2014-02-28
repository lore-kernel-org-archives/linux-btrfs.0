Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60781 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752715AbaB1A1u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 19:27:50 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140228001250.GA13647@dastard>
Date: Thu, 27 Feb 2014 17:27:48 -0700
Cc: otakujunction@gmail.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <C6A844E6-3258-4405-9024-282D1EBD06CB@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com> <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com> <B2988EF9-46EB-4804-A024-EE3B3A9E8771@gmail.com> <819E17EB-E4C2-4BD7-8D55-8C8DF9B8573B@colorremedies.com> <20140228001250.GA13647@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 27, 2014, at 5:12 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Feb 27, 2014 at 02:11:19PM -0700, Chris Murphy wrote:
>> 
>> On Feb 27, 2014, at 1:49 PM, otakujunction@gmail.com wrote:
>> 
>>> Yes it's an ancient 32 bit machine.  There must be a complex bug
>>> involved as the system, when originally mounted, claimed the
>>> correct free space and only as used over time did the
>>> discrepancy between used and free grow.  I'm afraid I chose
>>> btrfs because it appeared capable of breaking the 16 tera limit
>>> on a 32 bit system.  If this isn't the case then it's incredible
>>> that I've been using this file system for about a year without
>>> difficulty until now.
>> 
>> Yep, it's not a good bug. This happened some years ago on XFS too,
>> where people would use the file system for a long time and then at
>> 16TB+1byte written to the volume, kablewy! And then it wasn't
>> usable at all, until put on a 64-bit kernel.
>> 
>> http://oss.sgi.com/pipermail/xfs/2014-February/034588.html
> 
> Well, no, that's not what I said.

What are you thinking I said you said? I wasn't quoting or paraphrasing anything you've said above. I had done a google search on this early and found some rather old threads where some people had this experience of making a large file system on a 32-bit kernel, and only after filling it beyond 16TB did they run into the problem. Here is one of them:

http://lists.centos.org/pipermail/centos/2011-April/109142.html



> I said that it was limited on XFS,
> not that the limit was a result of a user making a filesystem too
> large and then finding out it didn't work. Indeed, you can't do that
> on XFS - mkfs will refuse to run on a block device it can't access the
> last block on, and the kernel has the same "can I access the last
> block of the filesystem" sanity checks that are run at mount and
> growfs time.

Nope. What I reported on the XFS list, I had used mkfs.xfs while running 32bit kernel on a 20TB virtual disk. It did not fail to make the file system, it failed only to mount it. It was the same booted virtual machine, I created the file system and immediately mounted it. If you want the specifics, I'll post on the XFS list with versions and reproduce steps.


> 
> IOWs, XFS has *never* allowed >16TB on 32 bit systems on Linux.

OK that's fine, I've only reported what other people said they experienced, and it comes as no surprise they might have been confused. Although not knowing the size of one's file system would seem to be rare.


Chris Murphy

