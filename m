Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54079 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750989AbdGZHIm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Jul 2017 03:08:42 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7D8CDAB9B
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Jul 2017 07:08:41 +0000 (UTC)
Subject: Re: [PATCH 5/7] btrfs-progs: backref: add list_first_pref helper
To: jeffm@suse.com, linux-btrfs@vger.kernel.org
References: <20170725205138.28376-1-jeffm@suse.com>
 <20170725205138.28376-5-jeffm@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <ac5c6a7c-97e9-2230-934b-8e5cb371dc94@suse.com>
Date: Wed, 26 Jul 2017 10:08:40 +0300
MIME-Version: 1.0
In-Reply-To: <20170725205138.28376-5-jeffm@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 25.07.2017 23:51, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> ---
>  backref.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/backref.c b/backref.c
> index ac1b506..be3376a 100644
> --- a/backref.c
> +++ b/backref.c
> @@ -130,6 +130,11 @@ struct __prelim_ref {
>  	u64 wanted_disk_byte;
>  };
>  
> +static struct __prelim_ref *list_first_pref(struct list_head *head)
> +{
> +	return list_first_entry(head, struct __prelim_ref, list);
> +}
> +

I think this just adds one more level of abstraction with no real
benefit whatsoever. Why not drop the patch entirely.

>  struct pref_state {
>  	struct list_head pending;
>  };
> @@ -804,8 +809,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>  	__merge_refs(&prefstate, 2);
>  
>  	while (!list_empty(&prefstate.pending)) {
> -		ref = list_first_entry(&prefstate.pending,
> -				       struct __prelim_ref, list);
> +		ref = list_first_pref(&prefstate.pending);
>  		WARN_ON(ref->count < 0);
>  		if (roots && ref->count && ref->root_id && ref->parent == 0) {
>  			/* no parent == root of tree */
> @@ -857,8 +861,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
>  out:
>  	btrfs_free_path(path);
>  	while (!list_empty(&prefstate.pending)) {
> -		ref = list_first_entry(&prefstate.pending,
> -				       struct __prelim_ref, list);
> +		ref = list_first_pref(&prefstate.pending);
>  		list_del(&ref->list);
>  		kfree(ref);
>  	}
> 
