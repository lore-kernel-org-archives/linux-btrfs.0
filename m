Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcEQNsF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:48:05 -0400
Date: Tue, 17 May 2016 15:47:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: bo.li.liu@oracle.com, Qu Wenruo <quwenruo@cn.fujitsu.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, vegard.nossum@oracle.com
Subject: Re: [PATCH 1/2] Btrfs: add more valid checks for superblock
Message-ID: <20160517134732.GS511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <9fa04dd7-13c4-6c24-dddc-4521eccea65c@cn.fujitsu.com>
 <20160504132329.GT29353@twin.jikos.cz>
 <20160504174436.GB14909@localhost.localdomain>
 <a7811da3-06f5-2ff2-06e4-19be9fd31410@cn.fujitsu.com>
 <20160506143529.GD29353@twin.jikos.cz>
 <47023701-8dd4-6c38-b242-230a372890e7@cn.fujitsu.com>
 <20160513181412.GA27734@localhost.localdomain>
 <a1cc8a93-c4a8-61f3-e5b6-5feceb8c838d@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a1cc8a93-c4a8-61f3-e5b6-5feceb8c838d@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 14, 2016 at 07:42:26AM +0800, Qu Wenruo wrote:
> > For fsck code, we can go forth and back to fix them.  In fact I don't
> > think fsck could work out anything, as superblock checksum has _matched_
> > but the values inside superblock are invalid, in this case we cannot trust
> >  other parts in this FS image, then how can we expect fsck to fix it by reading
> > other parts?
> 
> For rw fsck, that may cause huge problem and I agree with you on error out.
> But for ro fsck, it's a little overkilled for me.
> 
> Currently, if we found error in extent tree, we still continue checking 
> fstree, to shows what is really wrong.
> 
> And for case like btrfs-image restored images, its dev extents doesn't 
> even match with its chunk (may be it's already fixed?), but that's not a 
> big problem for ro btrfsck, and we can go on without problem.
> 
> So the same case is here for ro btrfsck.
> As long as that's ro btrfsck, we could just continue as we don't really 
> need the total_bytes in superblock.

AFAICS super_block->total_bytes is used in btrfs_alloc_chunk and in
several places in mkfs, but 'check' does not look at the value at all,
so warning for the read-only should be ok.
