Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33686 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbaB0VLW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 16:11:22 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Help with space
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <B2988EF9-46EB-4804-A024-EE3B3A9E8771@gmail.com>
Date: Thu, 27 Feb 2014 14:11:19 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <819E17EB-E4C2-4BD7-8D55-8C8DF9B8573B@colorremedies.com>
References: <CAAmRLYx1L=o7a2PMSAiJbr7qH_JiuYG2-ncHG-mHLyLcM3Z-GQ@mail.gmail.com> <DCDC90E8-4834-416A-AC00-B11FC9A66281@colorremedies.com> <82E08C64-154E-460E-A052-E60BC00D662C@colorremedies.com> <B2988EF9-46EB-4804-A024-EE3B3A9E8771@gmail.com>
To: otakujunction@gmail.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 27, 2014, at 1:49 PM, otakujunction@gmail.com wrote:

> Yes it's an ancient 32 bit machine.  There must be a complex bug involved as the system, when originally mounted, claimed the correct free space and only as used over time did the discrepancy between used and free grow.  I'm afraid I chose btrfs because it appeared capable of breaking the 16 tera limit on a 32 bit system.  If this isn't the case then it's incredible that I've been using this file system for about a year without difficulty until now.

Yep, it's not a good bug. This happened some years ago on XFS too, where people would use the file system for a long time and then at 16TB+1byte written to the volume, kablewy! And then it wasn't usable at all, until put on a 64-bit kernel.

http://oss.sgi.com/pipermail/xfs/2014-February/034588.html

I can't tell you if there's a work around for this other than to go to a 64bit kernel. Maybe you could partition the raid5 into two 9TB block devices, and then format the two partitions with -d single -m raid1. That way it behaves as one volume, and alternates 1GB chunks to the two partitions. This should be decent performing for large files, but otherwise it's possible that you will sometimes have the allocator writing to two data chunks on what it thinks are two drives, atthe same time, but it's actually writing to the physical device (array) at the same time. Hardware raid should optimize some of this, but I don't know what the penalty will be, if it'll work for your use case.

And I definitely don't know if the kernel page cache limit applies to the block device (partition) or if it applies to the file system. It sounds like it applies to the block device, so this might be a way around this if you had to stick to a 32bit system.


Chris Murphy