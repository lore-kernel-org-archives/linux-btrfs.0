Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wendy.routify.me ([192.3.10.38]:46812 "EHLO wendy.routify.me"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbbKKUcL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 15:32:11 -0500
Date: Wed, 11 Nov 2015 15:24:03 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Jim Murphy <srlinuxadmin@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Potential to loose data in case of disk failure
Message-ID: <20151111202403.GA19245@wheatley.student.rit.edu>
References: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKJi5fik1RsPQ7SA1P6=VmTwr06jrGFAA1cSWrVm0xoCrnhujA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2015 at 11:30:57AM -0600, Jim Murphy wrote:
> Hi all,
> 
> What am I missing or misunderstanding?  I have a newly
> purchased laptop I want/need to multi boot different OSs
> on.  As a result after partitioning I have ended up with two
> partitions on each of the two internal drives(sda3, sda8,
> sdb3 and sdb8).  FWIW, sda3 and sdb3 are the same size
> and sda8 and sdb8 are the same size.  As an end result
> I want one btrfs raid1 filesystem.  For lack of better terms,
> sda3 and sda8 "concatenated" together, sdb3 and sdb8
> "concatenated" together and then mirroring "sda" to "sdb"
> using only btrfs.  So far have found no use-case to cover
> this.
> 
> If I create a raid1 btrfs volume using all 4 "devices" as I
> understand it I would loose data if I were to loose a drive
> because two mirror possibilities would be:
> 
> sda3 mirrored to sda8
> sdb3 mirrored to sdb8
> 
> Is what I want to do possible without using MD-RAID and/or
> LVM?  If so would someone point me to the documentation
> I missed.  For whatever reason, I don't want to believe that
> this can't be done.  I want to believe that the code in btrfs
> is smart enough to know that sda3 and sda8 are on the same
> drive and would not try to mirror data between them except in
> a test setup.  I hope  I just missed some documentation,
> somewhere.
> 
> Thanks in advance for your help.  And last but not least,
> thanks to all for your work on btrfs.
> 
> Jim

That's a pretty unusual setup, so I'm not surprised there's no quick and
easy answer. The best solution in my opinion would be to shuffle your
partitions around and combine sda3 and sda8 into a single partition.
There's generally no reason to present btrfs with two different
partitions on the same disk.

If there's something that prevents you from doing that, you may be able
to use RAID10 or RAID6 somehow. I'm not really sure, though, so I'll
defer to others on the list for implementation details.

--Sean
