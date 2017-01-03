Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45578 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760159AbdACSEN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 13:04:13 -0500
Date: Tue, 3 Jan 2017 19:03:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fb.com,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [PULL REQUEST FOR NEXT PATCH 00/26] Patches from Fujitsu for
 next version
Message-ID: <20170103180356.GU12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161230010036.28099-1-quwenruo@cn.fujitsu.com>
 <20170102164738.GK12081@twin.jikos.cz>
 <0928a79c-d6ec-6cf3-d2ae-b224aa6a697d@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0928a79c-d6ec-6cf3-d2ae-b224aa6a697d@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 03, 2017 at 08:53:54AM +0800, Qu Wenruo wrote:
> 
> 
> At 01/03/2017 12:47 AM, David Sterba wrote:
> > On Fri, Dec 30, 2016 at 09:00:36AM +0800, Qu Wenruo wrote:
> >> Hi, please fetch the following branch for next branch:
> >> https://github.com/adam900710/linux.git fujitsu_for_next
> >>
> >> This branch contains most of Fujitsu unmerged patches for for-next branch.
> >>
> >> Latest David's for-next-20161219 branch can cause kernel panic so I don't
> >> use it as base, but v4.10-rc1.
> >
> > The for-next branch will be reassembled again as we're past rc1 now.
> >
> >> I ran the full xfstests test cases, with both default mount options and
> >> compress=lzo options.
> >> Fixes are working and no new regression.
> >>
> >> So I thing it should be good enough to act as a base for for-next branch.
> >>
> >> This big patch set contains the following fixes:
> >>
> >> 1) Wang's fixes for compression ENOSPC
> >
> > AFAIK, the patches have been reviewed only partially and used to be part
> > of for-next until the merge conflicts became unbearable. Patches
> > touching space handling need review before merging and at least some
> > sort of ack in case of for-next.
> >
> >> 2) Qgroup reserved space fix and WARN_ON
> >
> > Similar situation here.
> 
> Hopes comments from Chandan would help to merge some of the qgroup patches.
> (I just forgot to add his tags, sorry Chandan)
> 
> btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
> https://patchwork.kernel.org/patch/9457621/
> 
> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> btrfs: qgroup: Fix qgroup reserved space underflow by only freeing 
> reserved ranges
> https://patchwork.kernel.org/patch/9457619/
> 
> Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Great that Chandan does the review here, these two patches depend on
several more (roughly counting 2-3). I'll go through them and see which
could be merged earlier so it's more clear which still require review.
Thanks for patience.
