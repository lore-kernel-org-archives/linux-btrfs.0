Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55187 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbcGOSpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 14:45:38 -0400
Subject: Re: Data recovery from a linear multi-disk btrfs file system
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
From: Matt <langelino@gmx.net>
In-Reply-To: <179e2713-cd97-213c-3476-82f0b48c6442@gmail.com>
Date: Fri, 15 Jul 2016 20:45:32 +0200
Cc: linux-btrfs@vger.kernel.org
Message-Id: <1378A988-195F-4E68-B6DE-30CEDFAC8474@gmx.net>
References: <A06BAA26-44FF-4947-B552-26ED228B5BF6@gmx.net> <179e2713-cd97-213c-3476-82f0b48c6442@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 15 Jul 2016, at 14:10, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> 
> On 2016-07-15 05:51, Matt wrote:
>> Hello
>> 
>> I glued together 6 disks in linear lvm fashion (no RAID) to obtain one large file system (see below).  One of the 6 disk failed. What is the best way to recover from this?
>> 
> The tool you want is `btrfs restore`.  You'll need somewhere to put the files from this too of course.  That said, given that you had data in raid0 mode, you're not likely to get much other than very small files back out of this, and given other factors, you're not likely to get what you would consider reasonable performance out of this either.

Thanks so much for pointing me towards btrfs-restore. I surely will give it a try.  Note that the FS is not a RAID0 but  linear (“JPOD") configuration. This is why  it somehow did not occur to me to try btrfs-restore.  The good news about in this configuration  the files are *not* distributed across disks. We can  read most of the files just fine.  The failed disk was actually smaller than the others five so that we should be able to recover more than 5/6 of the data, shouldn’t we?  My trouble is that the IO errors due to the missing disk  cripple the transfer speed of both rsync and dd_rescue.

> Your best bet to get a working filesystem again would be to just recreate it from scratch, there's not much else that can be done when you've got a raid0 profile and have lost a disk.

This is what I plan to do if there if btrfs-restore turns out to be too slow and nobody on this list has any better idea.  It will, however, require  transferring  >15TB across the Atlantic (this is were the “backup” reside).  This can be tedious which is why I would love to avoid it.

Matt

