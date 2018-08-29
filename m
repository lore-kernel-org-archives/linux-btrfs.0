Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727537AbeH2Sta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Aug 2018 14:49:30 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEF06AFF1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Aug 2018 14:52:09 +0000 (UTC)
Subject: Re: [PATCH 3/6] btrfs-progs: Don't report dirty leaked eb using
 BUG_ON
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180803055022.9816-1-wqu@suse.com>
 <20180803055022.9816-4-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a17426bc-3f18-95e1-549e-8ef014fadb7c@suse.com>
Date: Wed, 29 Aug 2018 17:52:08 +0300
MIME-Version: 1.0
In-Reply-To: <20180803055022.9816-4-wqu@suse.com>
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
> backref 4222976 root 7 not referenced back 0x5617f8ecf780
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
> ERROR: errors found in fs roots
> extent buffer leak: start 4222976 len 4096
> extent_io.c:611: free_extent_buffer_internal: BUG_ON `eb->flags & EXTENT_DIRTY` triggered, value 1
> failed (ignored, ret=134): /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests//fuzz-tests/images/bko-161821.raw.restored
> mayfail: returned code 134 (SIGABRT), not ignored
> test failed for case 003-multi-check-unmounted
> ------
> 
> Since we're shifting to using btrfs_abort_transaction() in btrfs-progs,
> it will be more and more common to see dirty leaked eb.
> Instead of BUG_ON(), we only needs to report it as warning.


So how are such leaked extents supposed to be cleaned? So when
transaction_aborted is set we just return some errors from various
functions but I don't see how modified extents in the transaction are freed?
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  extent_io.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/extent_io.c b/extent_io.c
> index 198492699438..b8510b0ae94e 100644
> --- a/extent_io.c
> +++ b/extent_io.c
> @@ -608,7 +608,11 @@ static void free_extent_buffer_internal(struct extent_buffer *eb, bool free_now)
>  	eb->refs--;
>  	BUG_ON(eb->refs < 0);
>  	if (eb->refs == 0) {
> -		BUG_ON(eb->flags & EXTENT_DIRTY);
> +		if (eb->flags & EXTENT_DIRTY) {
> +			warning(
> +			"dirty eb leak (aborted trans): start %llu len %u",
> +				eb->start, eb->len);
> +		}
>  		list_del_init(&eb->recow);
>  		if (eb->flags & EXTENT_BUFFER_DUMMY || free_now)
>  			free_extent_buffer_final(eb);
> 
