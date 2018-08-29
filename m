Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727590AbeH2S2x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 14:28:53 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B528DAF58
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 14:31:39 +0000 (UTC)
Subject: Re: [PATCH 2/6] btrfs-progs: Exit gracefully when failed to repair
 root dir item
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180803055022.9816-1-wqu@suse.com>
 <20180803055022.9816-3-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <373eb4d6-6952-c24b-d818-2ad1ed92755a@suse.com>
Date: Wed, 29 Aug 2018 17:31:39 +0300
MIME-Version: 1.0
In-Reply-To: <20180803055022.9816-3-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.08.2018 08:50, Qu Wenruo wrote:
> Another BUG_ON() during fuzz/003:
> ------
> ====== RUN MAYFAIL /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-161821.raw.restored
> [1/7] checking root items
> Fixed 0 roots.
> [2/7] checking extents
> parent transid verify failed on 4198400 wanted 14 found 1114126
> parent transid verify failed on 4198400 wanted 14 found 1114126
> Ignoring transid failure
> owner ref check failed [4198400 4096]
> repair deleting extent record: key [4198400,169,0]
> adding new tree backref on start 4198400 len 4096 parent 0 root 5
> Repaired extent references for 4198400
> ref mismatch on [4222976 4096] extent item 1, found 0
> backref 4222976 root 7 not referenced back 0x55e9cc694780
> incorrect global backref count on 4222976 found 1 wanted 0
> backpointer mismatch on [4222976 4096]
> owner ref check failed [4222976 4096]
> repair deleting extent record: key [4222976,169,0]
> Repaired extent references for 4222976
> [3/7] checking free space cache
> [4/7] checking fs roots
> parent transid verify failed on 4198400 wanted 14 found 1114126
> Ignoring transid failure
> Wrong generation of child node/leaf, wanted: 1114126, have: 14
> root 5 missing its root dir, recreating
> parent transid verify failed on 4198400 wanted 14 found 1114126
> Ignoring transid failure
> ERROR: child eb corrupted: parent bytenr=4222976 item=0 parent level=1 child level=2
> check/main.c:2738: check_inode_recs: BUG_ON `ret` triggered, value -5
> failed (ignored, ret=134): /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-161821.raw.restored
> mayfail: returned code 134 (SIGABRT), not ignored
> test failed for case 003-multi-check-unmounted
> ------
> 
> Just abort current transaction and exit gracefully in this case.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

LGTM:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  check/main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/check/main.c b/check/main.c
> index b597e2a607e5..e6756e0f852b 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -2735,7 +2735,10 @@ static int check_inode_recs(struct btrfs_root *root,
>  				(unsigned long long)root->objectid);
>  
>  			ret = btrfs_make_root_dir(trans, root, root_dirid);
> -			BUG_ON(ret);
> +			if (ret < 0) {
> +				btrfs_abort_transaction(trans, ret);
> +				return ret;
> +			}
>  
>  			btrfs_commit_transaction(trans, root);
>  			return -EAGAIN;
> 
