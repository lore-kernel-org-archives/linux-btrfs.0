Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbcGOJpw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 05:45:52 -0400
Date: Fri, 15 Jul 2016 11:45:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs-progs: fix btrfs-map-logical to only print extent
 mapping info
Message-ID: <20160715094556.GS10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1468546827-28501-1-git-send-email-bo.li.liu@oracle.com>
 <f12ae244-0b15-fb93-eda1-8f758694afde@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f12ae244-0b15-fb93-eda1-8f758694afde@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2016 at 10:22:52AM +0800, Qu Wenruo wrote:
> 
> 
> At 07/15/2016 09:40 AM, Liu Bo wrote:
> > I have a valid btrfs image which contains,
> > ...
> >         item 10 key (1103101952 BLOCK_GROUP_ITEM 1288372224) itemoff 15947 itemsize 24
> >                 block group used 655360 chunk_objectid 256 flags DATA|RAID5
> >         item 11 key (1103364096 EXTENT_ITEM 131072) itemoff 15894 itemsize 53
> >                 extent refs 1 gen 11 flags DATA
> >                 extent data backref root 5 objectid 258 offset 0 count 1
> >         item 12 key (1103888384 EXTENT_ITEM 262144) itemoff 15841 itemsize 53
> >                 extent refs 1 gen 15 flags DATA
> >                 extent data backref root 1 objectid 256 offset 0 count 1
> >         item 13 key (1104281600 EXTENT_ITEM 262144) itemoff 15788 itemsize 53
> >                 extent refs 1 gen 15 flags DATA
> >                 extent data backref root 1 objectid 257 offset 0 count 1
> > ...
> >
> > The extent [1103364096, 131072) has length 131072, but if we run
> >
> > "btrfs-map-logical -l 1103364096 -b $((65536 * 3)) /dev/sda"
> >
> > it will return mapping info 's of  non-existing extents.
> >
> > It's because it assumes that extents's are contiguous on logical address,
> > when it's not true, after one loop (cur_logical += cur_len) and mapping
> > the next extent, we can get an extent that is out of our search range and
> > we end up with a negative @real_len and printing all mapping infos till
> > the disk end.
> >
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Reviewed-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Applied, thanks.
