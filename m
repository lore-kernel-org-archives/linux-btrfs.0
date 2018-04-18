Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55885 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752560AbeDRSgd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 14:36:33 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7E6B9AC79
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 18:36:32 +0000 (UTC)
Date: Wed, 18 Apr 2018 20:34:00 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: delayed-inode: Remove wrong qgroup meta
 reservation calls
Message-ID: <20180418183400.GS21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180417085245.6303-1-wqu@suse.com>
 <20180417151846.GE21272@twin.jikos.cz>
 <f24b9eb9-5774-45b5-876b-0795e773e131@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f24b9eb9-5774-45b5-876b-0795e773e131@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 18, 2018 at 09:08:10AM +0800, Qu Wenruo wrote:
> >>  	dst_rsv = &fs_info->delayed_block_rsv;
> >>  
> >>  	num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
> >> +
> >> +	/*
> >> +	 * Here we migrate space rsv from transaction rsv, since have
> >> +	 * already reserved space when starting a transaction.
> >> +	 * So no need to reserve qgroup space here.
> >> +	 */
> > 
> > Please format the comments to the full line width.
> 
> Right, the already can go previous line without exceeding 80 chars.
> 
> But the "So no need to..." line is a new line so it will not take up any
> space of previous line anyway.

You can split the loosely related parts by an empty line, ie.
paragraphs, but I don't tend to like if the new sentence on a new line
when it logically follows the previous one.

> >> @@ -647,7 +657,9 @@ static int btrfs_delayed_inode_reserve_metadata(
> >>  						      "delayed_inode",
> >>  						      btrfs_ino(inode),
> >>  						      num_bytes, 1);
> >> -		}
> >> +		} else
> >> +			btrfs_qgroup_free_meta_prealloc(root,
> >> +							fs_info->nodesize);
> > 
> > Please don't diverge from the coding style, I'm fixing such issues but,
> > you know.
> 
> For this, did you mean the bracket for else branch?

Yes.

	if () {
	...
	} else {
	...
	}
