Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbbJLNWq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:22:46 -0400
Date: Mon, 12 Oct 2015 15:21:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Warren Hughes <wsh@warrenhughes.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS with 8TB SMR drives
Message-ID: <20151012132136.GE27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+wwUFBKOxHSXOn9rcG+k5CTaKMPWGnx2a5dNo=CCfzawRLKGg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 12, 2015 at 07:43:50AM +1300, Warren Hughes wrote:
> Hi guys, just added a new Seagate Archive 8TB drive to my BTRFS volume
> and I'm getting a tonne of errors when balancing or scrubbing.
> 
> A short smartctl test reports fine, running a long one now. Will also
> run seatools from a bootable DOS USB while at work today.
> 
> Running latest firmware on my 9240-8i which explicitly supports this drive.
> 
> I'm finding it very hard to tell if SMR drives are OK with BTRFS
> currently - anyone chime in?

I assume you have the host-managed SMR drives. This type needs tweaks to
the operating system so the write patterns play well with the SMR
constraints. Btrfs does not support that out of the box, but my
colleague Hannes Reinecke managed to get it working with some minor
changes to the allocator and disabled writing of superblock copies.

For full support of SMR we'd have to change more than that, currently
nothing prevents to write "backwards" in a given chunk that is allowed
to be written only in the append way. So you can get mixed results when
trying to use the SMR devices but I'd say it will mostly not work.

But, btrfs has all the fundamental features in place, we'd have to make
adjustments to follow the SMR constraints:

* we can map the blockgroups to the SMR chunks (in some multiples)
* remember the write pointers and do only append writes (easy with COW)
* if the chunk is getting full, mark it read-only, rebalance the live
  data somewhere else and reset the chunk and the pointer

I have some notes at
https://github.com/kdave/drafts/blob/master/btrfs/smr-mode.txt
