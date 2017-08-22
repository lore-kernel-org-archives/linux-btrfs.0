Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42569 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932641AbdHVOF3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:05:29 -0400
Date: Tue, 22 Aug 2017 16:04:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: Replace number with enum
Message-ID: <20170822140404.GV2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170628095924.3276-1-gujx@cn.fujitsu.com>
 <20170821173948.GU2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821173948.GU2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 07:39:49PM +0200, David Sterba wrote:
> > +/* roots: root tree, extent tree, chunk tree, dev tree, fs tree, csum tree */
> > +enum btrfs_mkfs_block {
> > +	SUPER_BLOCK = 0,
> > +	ROOT_TREE,
> > +	EXTENT_TREE,
> > +	CHUNK_TREE,
> > +	DEV_TREE,
> > +	FS_TREE,
> > +	CSUM_TREE,
> > +	BLOCK_COUNT

BLOCK_COUNT is 7

> > +};
> > +
> >  struct btrfs_mkfs_config {
> >  	/* Label of the new filesystem */
> >  	const char *label;
> > @@ -43,7 +55,7 @@ struct btrfs_mkfs_config {
> >  	/* Output fields, set during creation */
> >  
> >  	/* Logical addresses of superblock [0] and other tree roots */
> > -	u64 blocks[8];
> > +	u64 blocks[BLOCK_COUNT];

This replaces 8 with 7 then, so the fs_uuid gets overwritten, can be
also caught by simply running 'make test-mkfs'.

> >  	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE];
> >  	char chunk_uuid[BTRFS_UUID_UNPARSED_SIZE];
> >  
> > -- 
> > 2.9.4
> > 
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
