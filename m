Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50751 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751526AbeBAPJL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Feb 2018 10:09:11 -0500
Date: Thu, 1 Feb 2018 16:06:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 3/3] btrfs-progs: check: Cleanup all checkpatch error
 and warning
Message-ID: <20180201150657.GK18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180201064541.14603-1-wqu@suse.com>
 <20180201064541.14603-4-wqu@suse.com>
 <a3275ec5-c4af-88e0-b1b6-022ff820a9b4@cn.fujitsu.com>
 <56a60440-c066-4f24-257d-21e7efa0ff38@gmx.com>
 <88127c19-73ba-a376-327c-6be93a63d251@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <88127c19-73ba-a376-327c-6be93a63d251@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 01, 2018 at 10:28:13AM +0200, Nikolay Borisov wrote:
> >>> @@ -3175,7 +3184,8 @@ static int check_extent_data_backref(struct
> >>> btrfs_fs_info *fs_info,
> >>>               btrfs_header_owner(leaf) != root_id)
> >>>               goto next;
> >>>           btrfs_item_key_to_cpu(leaf, &key, slot);
> >>> -        if (key.objectid != objectid || key.type !=
> >>> BTRFS_EXTENT_DATA_KEY)
> >>> +        if (key.objectid != objectid || key.type !=
> >>> +            BTRFS_EXTENT_DATA_KEY)
> >> if (key.objectid != objectid ||
> >>     key.type != BTRFS_EXTENT_DATA_KEY)
> >> is more better.
> >> Other changes are nice.
> > 
> > I also thought about that, but that leaves too much space in previous line.
> > 
> > Not sure what should be the best practice here.
> 
> Su's suggestion is more readable so I'd say go with it

I slightly disagree with checkpatch about the 80 cols limit in case the
the ; or closing ) is on 80 or even 81 as long as the code becomes
readable. I've grepped for the condition and there are both one line and
2 line (split after ||), so it's IMO both acceptable.

If it's formatted as

if (key.objectid != objectid ||
    key.type != BTRFS_EXTENT_DATA_KEY)

it's ok.
