Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34530 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbaGCXTC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 19:19:02 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3CA983EE0EC
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 08:19:00 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 11C55AC0A94
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 08:18:59 +0900 (JST)
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id B98ED1DB8032
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 08:18:58 +0900 (JST)
Message-ID: <53B5E4D0.10000@jp.fujitsu.com>
Date: Fri, 4 Jul 2014 08:18:40 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
CC: <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: assert send doesn't attempt to start transactions
References: <1403628508-13711-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1403628508-13711-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/06/25 1:48), Filipe David Borba Manana wrote:
> When starting a transaction just assert that current->journal_info
> doesn't contain a send transaction stub, since send isn't supposed
> to start transactions and when it finishes (either successfully or
> not) it's supposed to set current->journal_info to NULL.
> 
> This is motivated by the change titled:
> 
>      Btrfs: fix crash when starting transaction
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> ---
>   fs/btrfs/transaction.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 614eac3..47870ca 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -386,11 +386,13 @@ start_transaction(struct btrfs_root *root, u64 num_items, unsigned int type,
>   	bool reloc_reserved = false;
>   	int ret;
>   
> +	/* Send isn't supposed to start transactions. */
> +	ASSERT(current->journal_info != (void *)BTRFS_SEND_TRANS_STUB);
> +
>   	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
>   		return ERR_PTR(-EROFS);
>   
> -	if (current->journal_info &&
> -	    current->journal_info != (void *)BTRFS_SEND_TRANS_STUB) {
> +	if (current->journal_info) {
>   		WARN_ON(type & TRANS_EXTWRITERS);
>   		h = current->journal_info;
>   		h->use_count++;
> 

