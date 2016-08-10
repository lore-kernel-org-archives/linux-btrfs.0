Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54113 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932287AbcHJVkl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 17:40:41 -0400
Date: Wed, 10 Aug 2016 17:39:07 -0400
From: Tejun Heo <htejun@fb.com>
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <jack@suse.com>, <viro@zeniv.linux.org.uk>,
        <dchinner@redhat.com>, <hch@lst.de>
Subject: Re: [PATCH 2/2] writeback: allow for dirty metadata accounting
Message-ID: <20160810213907.GA6139@mtj.duckdns.org>
References: <1470769707-26079-1-git-send-email-jbacik@fb.com>
 <1470769707-26079-3-git-send-email-jbacik@fb.com>
 <20160810201233.GB3398@mtj.duckdns.org>
 <16022b26-5cc4-1cd9-c0f1-9b9b873fbce9@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <16022b26-5cc4-1cd9-c0f1-9b9b873fbce9@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Josef.

On Wed, Aug 10, 2016 at 05:16:03PM -0400, Josef Bacik wrote:
> > It bothers me a bit that sb's can actually be off bdi->sb_list while
> > sb_list_lock is released.  Can we make this explicit?  e.g. keep
> > separate bdi sb list for sb's pending metadata writeout (like b_dirty)
> > or by just walking the list in a smart way?
> > 
> 
> Yeah I wasn't super thrilled with this either, but since I'm only using it
> for writeback I figured it was ok for now.  I suppose I could make it less
> sb_list and just make it dirty_sb_list, and only add if the super says it
> has dirty metadata.  Does that sound better?  Then us being off of the list
> during writeback isn't that big of a deal.

Yeah, that feels more logical to me.

> > I can't find where sb's are actually added to the list.  Is that
> > supposed to happen from specific filesystems?  Also, it might make
> > sense to split up additions of sb_list and stat into separate patches.
> > 
> 
> I was going to be lazy and only add it if we cared about writing out
> metadata, and then we could expand it to everybody if somebody else had a
> usecase.  But I think maybe the b_sb_dirty list idea is a better fit overall
> so I can just do that so it makes more sense.  I can split up these patches
> as well, thanks,

b_sb_dirty list sounds good and we wouldn't have to worry too much
about lifetime issues either as the list would be linked iff the sb is
dirty.  It might still make sense to ensure that the list is unlinked
when sb is putting the bdi tho.

Thanks.

-- 
tejun
