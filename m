Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33603 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab2FMHfQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 03:35:16 -0400
Message-ID: <4FD84467.9000400@cn.fujitsu.com>
Date: Wed, 13 Jun 2012 15:42:31 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Chris Mason <chris.mason@fusionio.com>
CC: "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs and data nocow per inode basis
References: <4FD442F1.7040008@inwind.it> <4FD77F45.3060000@libero.it> <20120612183209.GC1803@thunk.org> <20120612191527.GA11966@thunk.org> <20120612204423.GA27777@shiny> <20120612211043.GH12161@thunk.org>
In-Reply-To: <20120612211043.GH12161@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/13/2012 05:10 AM, Ted Ts'o wrote:

> On Tue, Jun 12, 2012 at 04:44:23PM -0400, Chris Mason wrote:
>> On Tue, Jun 12, 2012 at 01:15:27PM -0600, Ted Ts'o wrote:
>>> It appears the NOCOW_FL flag is currently a no-op in the 3.2 kernel?
>> It's not a noop, but it is only setting the NODATACOW flag.  It needs to
>> set the nodatasum flag as well, just like the mount -o nodatacow mount
>> option does.
>>
>> I'll fix this up on the kernel side, thanks Ted.
> 


ohh, that's my fault...sorry.

> Here's the final patch to e2fsprogs that will be going into 1.42.4:
> 


This commit is lack of the related usage update, I'll send a patch for it :)

thanks,
liubo

> commit 5a23c93aeb65d61892a47f8f27bffad38f4759ea
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Jun 12 17:09:39 2012 -0400
> 
>     lsattr, chattr: add support for btrfs's No_COW flag
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
> index f03193c..e2f8ce5 100644
> --- a/lib/e2p/pf.c
> +++ b/lib/e2p/pf.c
> @@ -49,6 +49,7 @@ static struct flags_name flags_array[] = {
>  	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
>  	{ EXT4_EXTENTS_FL, "e", "Extents" },
>  	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
> +	{ FS_NOCOW_FL, "C", "No_COW" },
>  	{ 0, NULL, NULL }
>  };
>  
> diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
> index f46a1a9..fb3f7cc 100644
> --- a/lib/ext2fs/ext2_fs.h
> +++ b/lib/ext2fs/ext2_fs.h
> @@ -301,6 +301,7 @@ struct ext2_dx_countlimit {
>  #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
>  #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
>  /* EXT4_EOFBLOCKS_FL 0x00400000 was here */
> +#define FS_NOCOW_FL			0x00800000 /* Do not cow file */
>  #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
>  #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
>  #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
> diff --git a/misc/chattr.1.in b/misc/chattr.1.in
> index 92f6d70..5a57d2c 100644
> --- a/misc/chattr.1.in
> +++ b/misc/chattr.1.in
> @@ -64,6 +64,15 @@ this file compresses data before storing them on the disk.  Note: please
>  make sure to read the bugs and limitations section at the end of this
>  document.
>  .PP
> +A file with the 'C' attribute set will not be subject to copy-on-write
> +updates.  This flag is only supported on file systems which perform
> +copy-on-write.  (Note: For btrfs, the 'C' flag should be only
> +set on new or empty files.  If it is set on a file which already has
> +data blocks, it is undefined when the blocks assigned to the file will
> +be fully stable.  If the 'C' flag is set on a directory, it will have no
> +effect on the directory, but new files created in that directory will
> +the No_COW attribute.)
> +.PP
>  When a directory with the `D' attribute set is modified,
>  the changes are written synchronously on the disk; this is equivalent to
>  the `dirsync' mount option applied to a subset of the files.
> @@ -159,8 +168,7 @@ maintained by Theodore Ts'o <tytso@alum.mit.edu>.
>  .SH BUGS AND LIMITATIONS
>  The `c', 's',  and `u' attributes are not honored 
>  by the ext2 and ext3 filesystems as implemented in the current mainline
> -Linux kernels.    These attributes may be implemented
> -in future versions of the ext2 and ext3 filesystems.
> +Linux kernels.
>  .PP
>  The `j' option is only useful if the filesystem is mounted as ext3.
>  .PP
> diff --git a/misc/chattr.c b/misc/chattr.c
> index 8a2d61f..141ea6e 100644
> --- a/misc/chattr.c
> +++ b/misc/chattr.c
> @@ -107,6 +107,7 @@ static const struct flags_char flags_array[] = {
>  	{ EXT2_UNRM_FL, 'u' },
>  	{ EXT2_NOTAIL_FL, 't' },
>  	{ EXT2_TOPDIR_FL, 'T' },
> +	{ FS_NOCOW_FL, 'C' },
>  	{ 0, 0 }
>  };
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


