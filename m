Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32955 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932398AbdJZRHY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 13:07:24 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 95DCFAB0C
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 17:07:23 +0000 (UTC)
Date: Thu, 26 Oct 2017 19:05:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, nborisov@suse.com
Subject: Re: [PATCH v2 5/6] btrfs-progs: mkfs: Move image creation of rootdir
 to its own files
Message-ID: <20171026170535.GZ3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171019054138.13965-1-wqu@suse.com>
 <20171019054138.13965-6-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171019054138.13965-6-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 19, 2017 at 01:41:37PM +0800, Qu Wenruo wrote:
> index d0657aaea0f5..12747547766f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -113,7 +113,7 @@ cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>  	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
>  	       cmds-property.o cmds-fi-usage.o cmds-inspect-dump-tree.o \
>  	       cmds-inspect-dump-super.o cmds-inspect-tree-stats.o cmds-fi-du.o \
> -	       mkfs/common.o
> +	       mkfs/common.o mkfs/rootdir.o

Adding this mkfs file to cmds_objects does not make sense, everything
that cmds-* could need should be in mkfs/common.o, so I've removed it.

>  libbtrfs_objects = send-stream.o send-utils.o kernel-lib/rbtree.o btrfs-list.o \
>  		   kernel-lib/crc32c.o messages.o \
>  		   uuid-tree.o utils-lib.o rbtree-utils.o
> --- /dev/null
> +++ b/mkfs/rootdir.h
> @@ -0,0 +1,30 @@
> +/*
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public
> + * License v2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public
> + * License along with this program.
> + */
> +
> +/*
> + * Defines and functions declarations for users mkfs --rootdir
> + */
> +
> +#ifndef __BTRFS_MKDIR_ROOTDIR_H__
> +#define __BTRFS_MKDIR_ROOTDIR_H__

MKDIR -> MKFS, fixed
