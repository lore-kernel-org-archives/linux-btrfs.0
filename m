Return-Path: <SRS0=/9qN=MK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BDFC43382
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 00:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3BEA215E4
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Sep 2018 00:32:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3BEA215E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727361AbeI1Gxv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 28 Sep 2018 02:53:51 -0400
Received: from mout.gmx.net ([212.227.15.19]:50231 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726665AbeI1Gxv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Sep 2018 02:53:51 -0400
Received: from [180.96.28.100] ([180.96.28.100]) by web-mail.gmx.net
 (3c-app-mailcom-bs01.server.lan [172.19.170.58]) (via HTTP); Fri, 28 Sep
 2018 02:32:48 +0200
MIME-Version: 1.0
Message-ID: <trinity-4ce3dab2-7662-44a0-b151-a5959ec30240-1538094768093@3c-app-mailcom-bs01>
From:   "Su Yue" <Damenly_Su@gmx.com>
To:     "Qu Wenruo" <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: Check level for leaves and nodes
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 28 Sep 2018 02:32:48 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20180927235934.5215-1-wqu@suse.com>
References: <20180927235934.5215-1-wqu@suse.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:PTe4GPP8JpcpsaA7X9nYS1oCKueTbxi0OJIu6Xlzu24ZGzE+HsFnK1QWQ4o7lWAdESlpU
 puCySir3LAX+Bq8DhHLcYdmkUOULKVIXXsBmupxF4isZ4KiBjuNAI0SswCd2XcKZydnO0PggwTMr
 SaMRarc01XIRVUZEKJI3KAZHiMCyJkn1Gc6jNbs8WVVzVlsj30i14rXpzcQpo0/cVIEEdRhaVjHd
 BzRLUnB/NBdluq8uGGGtu4twJpbmQ/QAcIq7/AzCSwbRRTCxCNLEPRM5k2uCqI4qGLvBJzxBlHKw
 GA=
X-UI-Out-Filterresults: notjunk:1;V01:K0:roY7NdPneho=:eW52do9xKHlcoaQuP3v7i/
 0rMXcsyneg8Asqk26y2hJrjL+iGOSg5lqeC/QHL9eiy9WhyrW9IbB2bqbOC98pSsGQ0qQiJM+
 x4lxDSipFIU57WqKnvcP0x0CYVX8aaks6MbUceQJNxJRjq8L4oBGxvsg7Wq6Pi5wOii+Rv5qr
 CsbtFfVqVXnrG9UCWw5HIIUaNr1Uam2685D8YiUn8m7EiuWIQ4lFOBAUgkjJkxnF6d5D9ZfC8
 4GDyddz6elJVT8iTbzFu0rcCq6Q3k5xw1HdEm/GhV867DMJgZuPu3YkSfTzs7+grIfW2bxEuG
 MGpkH0SI+5lgsZjqk2EaWSm8LvYncEh5AMikHchckNbAYmZxB6INDNOZdtE8otOzRwUlcUSbB
 pjAtbQhvrOf1JufnIE3FP050qAcbm/Hfy1F8OlToThaJvqiNe5Dm4VTHW0D47Avm3mLY0vg7U
 sGUQh6pumGdm1E4PEdlpKvSYHZ0I6pBdACHg1t+TqU+F8jwtIjnG
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



> Sent: Friday, September 28, 2018 at 7:59 AM
> From: "Qu Wenruo" <wqu@suse.com>
> To: linux-btrfs@vger.kernel.org
> Subject: [PATCH] btrfs: tree-checker: Check level for leaves and nodes
>
> Although we have tree level check at tree read runtime, it's completely
> based on its parent level.
> We still need to do accurate level check to avoid invalid tree blocks
> sneak into kernel space.
> 
> The check itself is simple, for leaf its level should always be 0.
> For nodes its level should be in range [1, BTRFS_MAX_LEVEL - 1].
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/tree-checker.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index db835635372f..cab0b1f1f741 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -487,6 +487,13 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
>  	u32 nritems = btrfs_header_nritems(leaf);
>  	int slot;
>  
> +	if (btrfs_header_level(leaf) != 0) {
> +		generic_err(fs_info, leaf, 0,
> +			"invalid level for leaf, have %d expect 0",
> +			btrfs_header_level(leaf));
> +		return -EUCLEAN;
> +	}
> +
>  	/*
>  	 * Extent buffers from a relocation tree have a owner field that
>  	 * corresponds to the subvolume tree they are based on. So just from an
> @@ -645,9 +652,16 @@ int btrfs_check_node(struct btrfs_fs_info *fs_info, struct extent_buffer *node)
>  	unsigned long nr = btrfs_header_nritems(node);
>  	struct btrfs_key key, next_key;
>  	int slot;
> +	int level = btrfs_header_level(node);
>  	u64 bytenr;
>  	int ret = 0;
>  
> +	if (level <= 0 || level >= BTRFS_MAX_LEVEL) {
> +		generic_err(fs_info, node, 0,
> +			"invalid level for node, have %d expect [1, %d]",
> +			level, BTRFS_MAX_LEVEL - 1);
> +		return -EUCLEAN;
> +	}
>  	if (nr == 0 || nr > BTRFS_NODEPTRS_PER_BLOCK(fs_info)) {
>  		btrfs_crit(fs_info,
>  "corrupt node: root=%llu block=%llu, nritems too %s, have %lu expect range [1,%u]",
> -- 
> 2.19.0
> 
> 
