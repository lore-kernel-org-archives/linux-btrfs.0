Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38271 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750725AbdHBGK4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 02:10:56 -0400
Subject: Re: [PATCH] btrfs: verify_dir_item fails in replay_xattr_deletes
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Cc: Su Yue <suy.fnst@cn.fujitsu.com>
References: <20170802053521.22053-1-lufq.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <51264c09-335f-d6fe-4dc8-a757642024a8@suse.com>
Date: Wed, 2 Aug 2017 09:10:53 +0300
MIME-Version: 1.0
In-Reply-To: <20170802053521.22053-1-lufq.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.08.2017 08:35, Lu Fengqi wrote:
> From: Su Yue <suy.fnst@cn.fujitsu.com>
> 
> In replay_xattr_deletes(), the argument @slot of verify_dir_item()
> should be variable @i instead of path->slots[0].


This was already fix in a patch sent by Filipe. Title is:

[PATCH] Btrfs: fix dir item validation when replaying xattr deletes

> 
> The bug causes failure of generic/066 and shared/002 in xfstest.
> dmesg:
> [12507.810781] BTRFS critical (device dm-0): invalid dir item name len: 10
> [12507.811185] BTRFS: error (device dm-0) in btrfs_replay_log:2475: errno=-5 IO failure (Failed to recover log tree)
> [12507.811928] BTRFS error (device dm-0): cleaner transaction attach returned -30
> [12507.821020] BTRFS error (device dm-0): open_ctree failed
> [12508.131526] BTRFS info (device dm-0): disk space caching is enabled
> [12508.132145] BTRFS info (device dm-0): has skinny extents
> [12508.136265] BTRFS critical (device dm-0): invalid dir item name len: 10
> [12508.136678] BTRFS: error (device dm-0) in btrfs_replay_log:2475: errno=-5 IO failure (Failed to recover log tree)
> [12508.137501] BTRFS error (device dm-0): cleaner transaction attach returned -30
> [12508.147982] BTRFS error (device dm-0): open_ctree failed
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/tree-log.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index f20ef211a73d..3a11ae63676e 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2153,8 +2153,7 @@ static int replay_xattr_deletes(struct btrfs_trans_handle *trans,
>  			u32 this_len = sizeof(*di) + name_len + data_len;
>  			char *name;
>  
> -			ret = verify_dir_item(fs_info, path->nodes[0],
> -					      path->slots[0], di);
> +			ret = verify_dir_item(fs_info, path->nodes[0], i, di);
>  			if (ret) {
>  				ret = -EIO;
>  				goto out;
> 
