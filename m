Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751162AbdFEPNi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Jun 2017 11:13:38 -0400
Date: Mon, 5 Jun 2017 17:12:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 8/9] btrfs: Check namelen before in
 'btrfs_del_root_ref'
Message-ID: <20170605151235.GT12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
 <20170601085716.25898-9-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170601085716.25898-9-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 01, 2017 at 04:57:15PM +0800, Su Yue wrote:
> Call btrfs_is_namelen_valid before memcmp.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/root-tree.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
> index 7d6bc308bf43..7a5450600723 100644
> --- a/fs/btrfs/root-tree.c
> +++ b/fs/btrfs/root-tree.c
> @@ -390,6 +390,13 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
>  		WARN_ON(btrfs_root_ref_dirid(leaf, ref) != dirid);
>  		WARN_ON(btrfs_root_ref_name_len(leaf, ref) != name_len);
>  		ptr = (unsigned long)(ref + 1);
> +		ret = btrfs_is_namelen_valid(leaf, path->slots[0], ptr,
> +					     name_len);
> +		if (!ret) {
> +			err = -EIO;

This results in many fstests failures, eg.

[ 1886.766605] run fstests btrfs/008 at 2017-06-05 17:18:52
[ 1897.043952] BTRFS: device fsid 136be123-23f0-4fa7-bcbe-2001c90fb638 devid 1 transid 5 /dev/sdb6
[ 1897.100674] BTRFS info (device sdb6): disk space caching is enabled
[ 1897.100684] BTRFS info (device sdb6): has skinny extents
[ 1897.100689] BTRFS info (device sdb6): flagging fs with big metadata feature
[ 1897.106492] BTRFS info (device sdb6): detected SSD devices, enabling SSD mode
[ 1897.107360] BTRFS info (device sdb6): creating UUID tree
[ 1897.304521] BTRFS critical (device sdb5): invalid dir item name len: 7
[ 1897.304541] BTRFS: error (device sdb5) in btrfs_unlink_subvol:4244: errno=-5 IO failure
[ 1897.304548] BTRFS info (device sdb5): forced readonly
[ 1897.304557] BTRFS: error (device sdb5) in btrfs_ioctl_snap_destroy:2508: errno=-5 IO failure
[ 1897.465795] BTRFS error (device sdb5): cleaner transaction attach returned -30

with current for-next, so I'll remove the branch with namelen validation for now.

> +			goto out;
> +		}
> +
>  		WARN_ON(memcmp_extent_buffer(leaf, name, ptr, name_len));
>  		*sequence = btrfs_root_ref_sequence(leaf, ref);
>  
> -- 
> 2.13.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
