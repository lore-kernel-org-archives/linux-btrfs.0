From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH 12/12] Btrfs: Fix file clone when source offset is not
 0
Date: Thu, 26 Jan 2012 14:52:32 +0100
Message-ID: <4F215AA0.8040505@jan-o-sch.net>
References: <4D412FE6.7050101@cn.fujitsu.com> <4D4130D4.2000001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D4130D4.2000001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

I was looking at the clone range ioctl and have some remarks:

On 27.01.2011 09:46, Li Zefan wrote:
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f87552a..1b61dab 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1788,7 +1788,10 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
>  
>  			memcpy(&new_key, &key, sizeof(new_key));
>  			new_key.objectid = inode->i_ino;
> -			new_key.offset = key.offset + destoff - off;
> +			if (off <= key.offset)
> +				new_key.offset = key.offset + destoff - off;
> +			else
> +				new_key.offset = destoff;
						 ^^^^^^^
1) This looks spurious to me. What if destoff isn't aligned? That's what
the "key.offset - off" code above is for. Before the patch, the code
didn't work at all, I agree. But this fix can only work for aligned
requests.

2) The error in new_key also has propagated to the extent item's backref
and wasn't fixed there. I did a range clone and ended up with an extent
item like that:
        item 30 key (1318842368 EXTENT_ITEM 131072) itemoff 1047
itemsize 169
                extent refs 8 gen 11103 flags 1
[...]
                extent data backref root 257 objectid 272 offset
18446744073709494272 count 1

The last offset (equal to -14 * 4k) is obviously wrong. I didn't figure
out how the variables are computed, but it looks like there's something
wrong with the "datao" u64 to me.

3) Then, there's this code comment:

2180   /*
2181    * TODO:
2186    * - allow ranges within the same file to be cloned (provided
2187    *   they don't overlap)?
2188    */

This should be safe to do. Even with the current interface, we only
check for inode equality. If they differ, cloning is permitted. Make a
full-file clone, and you'll end up with two inodes referring to the same
extent.

Detection of overlapping areas seems to be missing, though and should be
added. Until that, the inode check stands as a (very weak) protection
against overlapping clone requests.

-Jan
