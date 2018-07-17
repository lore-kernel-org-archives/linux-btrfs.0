Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730185AbeGQQeR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 12:34:17 -0400
Date: Tue, 17 Jul 2018 18:00:49 +0200
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] btrfs: add support for 3-copy replication (raid1c3)
Message-ID: <20180717160049.GD3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1531503452.git.dsterba@suse.com>
 <7b570d84f5232322564e49f88990b733234c372c.1531503452.git.dsterba@suse.com>
 <16e66925-bf9e-57d6-b6c0-a8b03c8d38c9@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <16e66925-bf9e-57d6-b6c0-a8b03c8d38c9@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 13, 2018 at 11:02:03PM +0200, Goffredo Baroncelli wrote:
> As general comment, good to hear that something is moving around raid5/6 + write hole and multiple mirroring.
> However I am guessing if this is time to simplify the RAID code. There are a lot of "if" which could be avoided using 
> the values stored in the array "btrfs_raid_array[]".

I absolutely agree and had the same impression during implementing the
feature. For this patchset I did only a minimal prep work, the
suggestions you give below make sense to me.

Enhancing the table would make a lot of code go away and just use one
formula to calculate the results that are now opencoded. I'll be going
through the raid code so I'll get to the cleanups eventually.

> Below some comments:

> > @@ -5075,6 +5093,8 @@ static inline int btrfs_chunk_max_errors(struct map_lookup *map)
> >  			 BTRFS_BLOCK_GROUP_RAID5 |
> >  			 BTRFS_BLOCK_GROUP_DUP)) {
> >  		max_errors = 1;
> > +	} else if (map->type & BTRFS_BLOCK_GROUP_RAID1C3) {
> > +		max_errors = 2;
> >  	} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
> >  		max_errors = 2;
> >  	} else {
> 
> Even in this case the ifs above could be replaced with something like:
> 
> 	index = btrfs_bg_flags_to_raid_index(map->type)
> 	max_errors = btrfs_raid_array[index].ncopies-1;

There's .tolerated_failures that should equal ncopies - 1 in general,
but does not for DUP so the semantics of the function and caller needs
to be verified.
