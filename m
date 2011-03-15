From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2] Btrfs: add datacow flag in inode flag
Date: Tue, 15 Mar 2011 16:26:50 -0400
Message-ID: <1300220702-sup-5062@think>
References: <4D6F52DE.5080508@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, hch@lst.de,
	"Theodore Tso" <tytso@mit.edu>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <4D6F52DE.5080508@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from liubo's message of 2011-03-03 03:35:42 -0500:
> 
> For datacow control, the corresponding inode flags are needed.
> This is for the following patch.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  include/linux/fs.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 63d069b..bef47ff 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -353,6 +353,8 @@ struct inodes_stat_t {
>  #define FS_TOPDIR_FL            0x00020000 /* Top of directory hierarchies*/
>  #define FS_EXTENT_FL            0x00080000 /* Extents */
>  #define FS_DIRECTIO_FL            0x00100000 /* Use direct i/o */
> +#define FS_NOCOW_FL            0x00800000 /* Do not cow file */
> +#define FS_COW_FL            0x01000000 /* Cow file */
>  #define FS_RESERVED_FL            0x80000000 /* reserved for ext2 lib */
>  
>  #define FS_FL_USER_VISIBLE        0x0003DFFF /* User visible flags */

Hi everyone,

I'd like to go ahead and include these for btrfs to use.  Are there
objections or a different preferred interface?

-chris
