Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33192 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932097AbeENPUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 11:20:02 -0400
Date: Mon, 14 May 2018 17:17:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 11/12] Btrfs: renumber BTRFS_INODE_ runtime flags
Message-ID: <20180514151719.GM6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1526069051.git.osandov@fb.com>
 <c69fd5cb94b60d6b0d9e422c2340f70b3e3d3914.1526069051.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c69fd5cb94b60d6b0d9e422c2340f70b3e3d3914.1526069051.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 01:13:39PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> We got rid of BTRFS_INODE_HAS_ORPHAN_ITEM and
> BTRFS_INODE_ORPHAN_META_RESERVED, so we can renumber the flags to make
> them consecutive again.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/btrfs_inode.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 4807cde0313d..bbbe7f308d68 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -20,14 +20,14 @@
>   * new data the application may have written before commit.
>   */
>  #define BTRFS_INODE_ORDERED_DATA_CLOSE		0
> -#define BTRFS_INODE_DUMMY			2
> -#define BTRFS_INODE_IN_DEFRAG			3
> -#define BTRFS_INODE_HAS_ASYNC_EXTENT		5
> -#define BTRFS_INODE_NEEDS_FULL_SYNC		6
> -#define BTRFS_INODE_COPY_EVERYTHING		7
> -#define BTRFS_INODE_IN_DELALLOC_LIST		8
> -#define BTRFS_INODE_READDIO_NEED_LOCK		9
> -#define BTRFS_INODE_HAS_PROPS		        10
> +#define BTRFS_INODE_DUMMY			1
> +#define BTRFS_INODE_IN_DEFRAG			2
> +#define BTRFS_INODE_HAS_ASYNC_EXTENT		3
> +#define BTRFS_INODE_NEEDS_FULL_SYNC		4
> +#define BTRFS_INODE_COPY_EVERYTHING		5
> +#define BTRFS_INODE_IN_DELALLOC_LIST		6
> +#define BTRFS_INODE_READDIO_NEED_LOCK		7
> +#define BTRFS_INODE_HAS_PROPS		        8

I'll update it to something like this, as we want the auto-numbering
from enums:

--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -19,17 +19,19 @@
 * ordered operations list so that we make sure to flush out any
 *   * new data the application may have written before commit.
 */
 -#define BTRFS_INODE_ORDERED_DATA_CLOSE         0
 -#define BTRFS_INODE_ORPHAN_META_RESERVED       1
 -#define BTRFS_INODE_DUMMY                      2
 -#define BTRFS_INODE_IN_DEFRAG                  3
 -#define BTRFS_INODE_HAS_ORPHAN_ITEM            4
 -#define BTRFS_INODE_HAS_ASYNC_EXTENT           5
 -#define BTRFS_INODE_NEEDS_FULL_SYNC            6
 -#define BTRFS_INODE_COPY_EVERYTHING            7
 -#define BTRFS_INODE_IN_DELALLOC_LIST           8
 -#define BTRFS_INODE_READDIO_NEED_LOCK          9
 -#define BTRFS_INODE_HAS_PROPS                  10
 +enum {
 +       BTRFS_INODE_ORDERED_DATA_CLOSE = 0,
 +       BTRFS_INODE_ORPHAN_META_RESERVED,
 +       BTRFS_INODE_DUMMY,
 +       BTRFS_INODE_IN_DEFRAG,
 +       BTRFS_INODE_HAS_ORPHAN_ITEM,
 +       BTRFS_INODE_HAS_ASYNC_EXTENT,
 +       BTRFS_INODE_NEEDS_FULL_SYNC,
 +       BTRFS_INODE_COPY_EVERYTHING,
 +       BTRFS_INODE_IN_DELALLOC_LIST,
 +       BTRFS_INODE_READDIO_NEED_LOCK,
 +       BTRFS_INODE_HAS_PROPS,
 +};
