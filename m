Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:39148 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2I0I0C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 04:26:02 -0400
Date: Thu, 27 Sep 2012 10:25:55 +0200
From: David Sterba <dave@jikos.cz>
To: Chris Mason <chris.mason@fusionio.com>, Mark Fasheh <mfasheh@suse.de>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Chris L. Mason" <clmason@fusionio.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v4 0/4] btrfs: extended inode refs
Message-ID: <20120927082555.GE14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1345494561-28758-1-git-send-email-mfasheh@suse.de>
 <20120925200446.GD6596@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120925200446.GD6596@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 04:04:46PM -0400, Chris Mason wrote:
> @@ -889,16 +899,23 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
>  		while (cur_offset < item_size) {
>  			extref = (struct btrfs_inode_extref *)base + cur_offset;
>  
> -			victim_name_len = btrfs_inode_extref_name_len(eb, extref);
> -			victim_name = kmalloc(namelen, GFP_NOFS);
> -			leaf = path->nodes[0];
> -			read_extent_buffer(eb, name, (unsigned long)&extref->name, namelen);
> +			victim_name_len = btrfs_inode_extref_name_len(leaf, extref);
> +
> +			if (btrfs_inode_extref_parent(leaf, extref) != parent_objectid)
> +				goto next;
> +
> +			victim_name = kmalloc(victim_name_len, GFP_NOFS);

unchecked kmalloc

> +			read_extent_buffer(leaf, victim_name, (unsigned long)&extref->name,
> +					   victim_name_len);
>  
>  			search_key.objectid = inode_objectid;
>  			search_key.type = BTRFS_INODE_EXTREF_KEY;
>  			search_key.offset = btrfs_extref_hash(parent_objectid,
