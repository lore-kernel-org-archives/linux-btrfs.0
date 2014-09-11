Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34570 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaIKEl6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 00:41:58 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id B17FE3EE0C5
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 13:41:56 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id B8A29AC048B
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 13:41:55 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 532DD1DB8037
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 13:41:55 +0900 (JST)
Message-ID: <5411280A.9010601@jp.fujitsu.com>
Date: Thu, 11 Sep 2014 13:41:46 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: add missing compression property remove in btrfs_ioctl_setflags
References: <1410361824-12676-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1410361824-12676-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

(2014/09/11 0:10), Filipe Manana wrote:
> The behaviour of a 'chattr -c' consists of getting the current flags,
> clearing the FS_COMPR_FL bit and then sending the result to the set
> flags ioctl - this means the bit FS_NOCOMP_FL isn't set in the flags
> passed to the ioctl. This results in the compression property not being
> cleared from the inode - it was cleared only if the bit FS_NOCOMP_FL
> was set in the received flags.
> 
> Reproducer:
> 
>      $ mkfs.btrfs -f /dev/sdd
>      $ mount /dev/sdd /mnt && cd /mnt
>      $ mkdir a
>      $ chattr +c a
>      $ touch a/file
>      $ lsattr a/file
>      --------c------- a/file
>      $ chattr -c a
>      $ touch a/file2
>      $ lsattr a/file2
>      --------c------- a/file2
>      $ lsattr -d a
>      ---------------- a
> 
> Reported-by: Andreas Schneider <asn@cryptomilk.org>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   fs/btrfs/ioctl.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index a010c44..8e6950c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -333,6 +333,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
>   
>   	} else {
>   		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
> +		ret = btrfs_set_prop(inode, "btrfs.compression", NULL, 0, 0);

IMHO, this patch is going on a wrong way since this patch
changes the meaning of chattr. Here is the correct behavior.

flag | BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS | 
=====+======================+========================+
+c   |        set           |         unset          |
-c   |       unset          |         unset          |

However, by your change, chattr -c results in unset
BTRFS_INODE_COMPRESS and *set* BTRFS_INODE_NOCOMPRESS.
It's because btrfs_set_prop() will finally lead to
prop_compression_apply() with setting its value to "".
It's the behavior of calling ioctl() with FS_NOCOMP_FL.

Please note that inode flag without both BTRFS_INODE_COMPRESS
nor BTRFS_INODE_NOCOMPRESS has its own meaning: whether file
is compress or not is decided by "compress" mount option.

My suggestion is as follows and I'll write a patch based
on it soon.

 - Change the meaning of btrfs.compression == "" to mean
   unset both BTRFS_INODE_COMPRESS and BTRFS_INODE_NOCOMPRESS,
   for chattr -c.
 - Add new value of "btrfs.compression" property, for example
   "no" or "off", to mean unset BTRFS_INODE_COMPRESS and set
   BTRFS_INODE_NOCOMPRESS. It's for ioctl() with FS_NOCOMP_FL.
 - Unify duplicated code of changing inode flags to props.c.

Thanks,
Satoru

> +		if (ret && ret != -ENODATA)
> +			goto out_drop;
>   	}
>   
>   	trans = btrfs_start_transaction(root, 1);
> 

