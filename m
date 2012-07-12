Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56693 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GLH7o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jul 2012 03:59:44 -0400
Received: by bkwj10 with SMTP id j10so1868610bkw.19
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Jul 2012 00:59:43 -0700 (PDT)
Message-ID: <1342079966.26081.36.camel@ierdnac-hp>
Subject: Re: btrfs fi df won't show total=
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Jan Engelhardt <jengelh@inai.de>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Date: Thu, 12 Jul 2012 10:59:26 +0300
In-Reply-To: <20120709215234.GA1942@zambezi.lan>
References: <alpine.LNX.2.01.1207092111360.16359@frira.zrqbmnf.qr>
	 <20120709192500.GG28701@carfax.org.uk>
	 <alpine.LNX.2.01.1207092204450.23294@frira.zrqbmnf.qr>
	 <20120709215234.GA1942@zambezi.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2012-07-10 at 00:52 +0300, Ilya Dryomov wrote: 
> mkfs creates those non-raid chunks for a pretty stupid reason, they
> really shouldn't be there if you create a raid10 fs.  Balance does the
> right thing and removes them.  Fixing this along with another mkfs
> annoyance related to this one is on my TODO list.

Hi Ilya,

I've also studied this bug and found where the problem is, if this will
help you:

In mkfs.c, "make_root_dir" function creates the first system and
metadata chunk:
        ret = btrfs_make_block_group(trans, root, bytes_used,
                                     BTRFS_BLOCK_GROUP_SYSTEM,
                                     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
                                     0, BTRFS_MKFS_SYSTEM_GROUP_SIZE);
....
                ret = btrfs_alloc_chunk(trans,
root->fs_info->extent_root,
                                        &chunk_start, &chunk_size,
                                        BTRFS_BLOCK_GROUP_METADATA |
                                        BTRFS_BLOCK_GROUP_DATA);
                BUG_ON(ret);
                ret = btrfs_make_block_group(trans, root, 0,
                                             BTRFS_BLOCK_GROUP_METADATA
|
                                             BTRFS_BLOCK_GROUP_DATA,

BTRFS_FIRST_CHUNK_TREE_OBJECTID,
                                             chunk_start, chunk_size);

And these chunks are created again in "create_raid_groups" function.
Both functions, "make_root_dir" and "create_raid_groups" are called from
"main" function.

Andrei 

