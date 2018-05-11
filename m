Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbeEKKJj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 06:09:39 -0400
Date: Fri, 11 May 2018 12:06:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Subject: Re: [PATCH v3 05/11] Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
Message-ID: <20180511100657.GR6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526025007.git.osandov@fb.com>
 <844bfe29a31c7943053202c36a7990efd2437c69.1526025007.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <844bfe29a31c7943053202c36a7990efd2437c69.1526025007.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 12:56:10AM -0700, Omar Sandoval wrote:
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -23,13 +23,12 @@
>  #define BTRFS_INODE_ORPHAN_META_RESERVED	1
>  #define BTRFS_INODE_DUMMY			2
>  #define BTRFS_INODE_IN_DEFRAG			3
> -#define BTRFS_INODE_HAS_ORPHAN_ITEM		4
> -#define BTRFS_INODE_HAS_ASYNC_EXTENT		5
> -#define BTRFS_INODE_NEEDS_FULL_SYNC		6
> -#define BTRFS_INODE_COPY_EVERYTHING		7
> -#define BTRFS_INODE_IN_DELALLOC_LIST		8
> -#define BTRFS_INODE_READDIO_NEED_LOCK		9
> -#define BTRFS_INODE_HAS_PROPS		        10
> +#define BTRFS_INODE_HAS_ASYNC_EXTENT		4
> +#define BTRFS_INODE_NEEDS_FULL_SYNC		5
> +#define BTRFS_INODE_COPY_EVERYTHING		6
> +#define BTRFS_INODE_IN_DELALLOC_LIST		7
> +#define BTRFS_INODE_READDIO_NEED_LOCK		8
> +#define BTRFS_INODE_HAS_PROPS		        9

Please keep such changes minimal and only relevant to the purpose of the
patch, in this case just remove the BTRFS_INODE_HAS_ORPHAN_ITEM .

There will be a hole left in the sequence but this is not a problem and
we're going to convert the defines to enums. The defines are prone to
error if the nubmers get accidentally duplicated, like it happend not so
long ago with the fsinfo::fs_flags.
