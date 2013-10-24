Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42358 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3JXKIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 06:08:51 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 008DE7C068F
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Oct 2013 04:08:51 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>,
        Bob Marley <bobmarley@shiftmail.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <5268059E.707@giantdisaster.de>
CC: Wang Shilong <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <1382156250-2336-1-git-send-email-wangshilong1991@gmail.com>
 <526247E3.9000804@giantdisaster.de>
 <CAP9B-Qncw5aCJzbQapy6i4iRrJ-mYh_yhkorY7+p9wZtzJodTQ@mail.gmail.com>
 <5262914D.7030306@giantdisaster.de>
 <B9B7D38F-3E92-4347-A41F-FA4D80D31745@gmail.com>
 <52663960.4060905@giantdisaster.de> <5266AE1F.6030304@shiftmail.org>
 <5268059E.707@giantdisaster.de>
Message-ID: <20131024100842.14051.45479@localhost.localdomain>
Subject: Re: [PATCH] Btrfs: fix race condition between writting and scrubing supers
Date: Thu, 24 Oct 2013 06:08:42 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Stefan Behrens (2013-10-23 13:21:34)
> On Tue, 22 Oct 2013 18:55:59 +0200, Bob Marley wrote:
> > On 22/10/2013 10:37, Stefan Behrens wrote:
> >> I don't believe that this issue can ever happen. I don't believe that
> >> somewhere on the path to the flash memory, to the magnetic disc or to
> >> the drive's cache memory, someone interrupts a 4KB write in the middle
> >> of operation to read from this 4KB area. This is not an issue IMHO.
> > 
> > I think I have read that unfortunately it can happen.
> > SAS and SATA specs for disks do not mandate that if a write is in-flight
> > but still not completed, reads from the same sector should return the
> > value it is being written; they can return the old value.
> > I also think that Linux does not check either.
> 
> If the _old_ 4KB block is returned, that's fine and won't cause a
> checksum error.
> 
> The patch in question addresses the case that Btrfs submits a write
> request for a 4KB block, and a concurrent read request for that 4KB
> block reads partially the old block and partially the new block,
> resulting in a checksum error reported in the scrub statistic counters.

Concurrent reads and writes to the device are completely undefined, and
Any combination of old, new, random memory corruption wouldn't
surprise me...I'd rather avoid them ;)

Doing the transaction join during the super read is probably the least
complex choice.

-chris
