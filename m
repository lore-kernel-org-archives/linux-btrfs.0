Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29743 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752412AbbF3C0m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 22:26:42 -0400
Subject: Re: [PATCH 4/4] btrfs: Fix data checksum error cause by replace with
 io-load.
To: Zhaolei <zhaolei@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
References: <5c5c914dad20c018cfe74174827219c418839f39.1432900529.git.zhaolei@cn.fujitsu.com>
 <33ad2c0da35681e20afdc6a75ecb19ff2b09f767.1432900529.git.zhaolei@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5591FE4A.9060406@cn.fujitsu.com>
Date: Tue, 30 Jun 2015 10:26:18 +0800
MIME-Version: 1.0
In-Reply-To: <33ad2c0da35681e20afdc6a75ecb19ff2b09f767.1432900529.git.zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To Chris:

Would you consider merging these patchset for late 4.2 merge window?
If it's OK to merge it into 4.2 late rc, we'll start our test and send 
pull request after our test, eta this Friday or next Monday.

I know normally we should submit it early especially when such fix is 
not small.
But the bug is long-standing and is quite annoying (possibility 
involved), also Zhao Lei has quite a good idea to cleanup the scrub 
codes based on the patchset.

So it would be quite nice if we have any chance to merge it into 4.2

Would it be OK for you?

Thanks,
Qu

Zhaolei wrote on 2015/05/29 19:55 +0800:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
>
> xfstests btrfs/070 sometimes failed.
> In my test machine, its fail rate is about 30%.
> In another vm(vmware), its fail rate is about 50%.
>
> Reason:
>    btrfs/070 do replace and defrag with fsstress simultaneously,
>    after above operation, checksum error is found by scrub.
>
>    Actually, it have no relationship with defrag operation, only
>    replace with fsstress can trigger this bug.
>
>    New data writen to target device have possibility rewrited by
>    old data from source device by replace code in debug, to avoid
>    above problem, we can set target block group to readonly in
>    replace period, so new data requested by other operation will
>    not write to same place with replace code.
>
>    Before patch(4.1-rc3):
>      30% failed in 100 xfstests.
>    After patch:
>      0% failed in 300 xfstests.
>
> Changelog v1->v2:
> 1: Update subject to reflect the problem being fixed.
> 2: Update description to say reason why set read-only can fix the
>     problem.
> 3: Use a helper function to avoid duplicated code block for set
>     chunk ro.
> All of above are suggested by: David Sterba <dsterba@suse.cz>
>
> Reported-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Suggested-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>   fs/btrfs/scrub.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index 8da3459..e1ebf43 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -3455,6 +3455,18 @@ int scrub_enumerate_chunks(struct scrub_ctx *sctx,
>   		if (!cache)
>   			goto skip;
>
> +		/*
> +		 * we need call btrfs_inc_block_group_ro() with scrubs_paused,
> +		 * to avoid deadlock caused by:
> +		 * btrfs_inc_block_group_ro()
> +		 * -> btrfs_wait_for_commit()
> +		 * -> btrfs_commit_transaction()
> +		 * -> btrfs_scrub_pause()
> +		 */
> +		scrub_pause_on(fs_info);
> +		btrfs_inc_block_group_ro(root, cache);
> +		scrub_pause_off(fs_info);
> +
>   		dev_replace->cursor_right = found_key.offset + length;
>   		dev_replace->cursor_left = found_key.offset;
>   		dev_replace->item_needs_writeback = 1;
>
