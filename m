Return-Path: <SRS0=91MX=QF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7082FC169C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 07:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 409EA2175B
	for <linux-btrfs@archiver.kernel.org>; Tue, 29 Jan 2019 07:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbfA2H1Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:27:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:42298 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfA2H1Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Jan 2019 02:27:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F026AE58;
        Tue, 29 Jan 2019 07:27:23 +0000 (UTC)
Subject: Re: [PATCH 02/11] btrfs: rename workspaces_list to workspace_manager
To:     Dennis Zhou <dennis@kernel.org>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190128212437.11597-1-dennis@kernel.org>
 <20190128212437.11597-3-dennis@kernel.org>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <bd650df2-4920-9609-ad48-f4356bbdab7e@suse.com>
Date:   Tue, 29 Jan 2019 09:27:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190128212437.11597-3-dennis@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 28.01.19 г. 23:24 ч., Dennis Zhou wrote:
> This is in preparation for zstd compression levels. As each level will
> require different sized workspaces, workspaces_list is no longer a
> really fitting name.
> 
> Signed-off-by: Dennis Zhou <dennis@kernel.org>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/compression.c | 46 +++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 586f95ac0aea..aced261984e2 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -769,7 +769,7 @@ static struct list_head *alloc_heuristic_ws(void)
>  	return ERR_PTR(-ENOMEM);
>  }
>  
> -struct workspaces_list {
> +struct workspace_manager {
>  	struct list_head idle_ws;
>  	spinlock_t ws_lock;
>  	/* Number of free workspaces */
> @@ -780,9 +780,9 @@ struct workspaces_list {
>  	wait_queue_head_t ws_wait;
>  };
>  
> -static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
> +static struct workspace_manager wsm[BTRFS_COMPRESS_TYPES];
>  
> -static struct workspaces_list btrfs_heuristic_ws;
> +static struct workspace_manager btrfs_heuristic_ws;
>  
>  static const struct btrfs_compress_op * const btrfs_compress_op[] = {
>  	&btrfs_zlib_compress,
> @@ -811,10 +811,10 @@ void __init btrfs_init_compress(void)
>  	}
>  
>  	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
> -		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
> -		spin_lock_init(&btrfs_comp_ws[i].ws_lock);
> -		atomic_set(&btrfs_comp_ws[i].total_ws, 0);
> -		init_waitqueue_head(&btrfs_comp_ws[i].ws_wait);
> +		INIT_LIST_HEAD(&wsm[i].idle_ws);
> +		spin_lock_init(&wsm[i].ws_lock);
> +		atomic_set(&wsm[i].total_ws, 0);
> +		init_waitqueue_head(&wsm[i].ws_wait);
>  
>  		/*
>  		 * Preallocate one workspace for each compression type so
> @@ -824,9 +824,9 @@ void __init btrfs_init_compress(void)
>  		if (IS_ERR(workspace)) {
>  			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
>  		} else {
> -			atomic_set(&btrfs_comp_ws[i].total_ws, 1);
> -			btrfs_comp_ws[i].free_ws = 1;
> -			list_add(workspace, &btrfs_comp_ws[i].idle_ws);
> +			atomic_set(&wsm[i].total_ws, 1);
> +			wsm[i].free_ws = 1;
> +			list_add(workspace, &wsm[i].idle_ws);
>  		}
>  	}
>  }
> @@ -856,11 +856,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
>  		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
>  		free_ws	 = &btrfs_heuristic_ws.free_ws;
>  	} else {
> -		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
> -		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
> -		total_ws = &btrfs_comp_ws[idx].total_ws;
> -		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
> -		free_ws	 = &btrfs_comp_ws[idx].free_ws;
> +		idle_ws	 = &wsm[idx].idle_ws;
> +		ws_lock	 = &wsm[idx].ws_lock;
> +		total_ws = &wsm[idx].total_ws;
> +		ws_wait	 = &wsm[idx].ws_wait;
> +		free_ws	 = &wsm[idx].free_ws;
>  	}
>  
>  again:
> @@ -952,11 +952,11 @@ static void __free_workspace(int type, struct list_head *workspace,
>  		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
>  		free_ws	 = &btrfs_heuristic_ws.free_ws;
>  	} else {
> -		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
> -		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
> -		total_ws = &btrfs_comp_ws[idx].total_ws;
> -		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
> -		free_ws	 = &btrfs_comp_ws[idx].free_ws;
> +		idle_ws	 = &wsm[idx].idle_ws;
> +		ws_lock	 = &wsm[idx].ws_lock;
> +		total_ws = &wsm[idx].total_ws;
> +		ws_wait	 = &wsm[idx].ws_wait;
> +		free_ws	 = &wsm[idx].free_ws;
>  	}
>  
>  	spin_lock(ws_lock);
> @@ -998,11 +998,11 @@ static void free_workspaces(void)
>  	}
>  
>  	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
> -		while (!list_empty(&btrfs_comp_ws[i].idle_ws)) {
> -			workspace = btrfs_comp_ws[i].idle_ws.next;
> +		while (!list_empty(&wsm[i].idle_ws)) {
> +			workspace = wsm[i].idle_ws.next;
>  			list_del(workspace);
>  			btrfs_compress_op[i]->free_workspace(workspace);
> -			atomic_dec(&btrfs_comp_ws[i].total_ws);
> +			atomic_dec(&wsm[i].total_ws);
>  		}
>  	}
>  }
> 
