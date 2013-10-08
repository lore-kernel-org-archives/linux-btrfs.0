Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55373 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3JHFTB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 01:19:01 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 8 Oct 2013 15:18:59 +1000
Received: from d23relay05.au.ibm.com (d23relay05.au.ibm.com [9.190.235.152])
	by d23dlp01.au.ibm.com (Postfix) with ESMTP id 6CA2C2CE8040
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Oct 2013 16:18:56 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay05.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r9851ppJ62652592
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 16:01:52 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r985ItEV030857
	for <linux-btrfs@vger.kernel.org>; Tue, 8 Oct 2013 16:18:55 +1100
From: chandan <chandan@linux.vnet.ibm.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-btrfs@vger.kernel.org, sandeen@redhat.com
Subject: Re: [PATCH 08/12] btrfs-progs: don't leak path in verify_space_cache
Date: Tue, 08 Oct 2013 10:48:52 +0530
Message-ID: <1992957.VlB0IgvMlB@localhost.localdomain>
In-Reply-To: <1381182185-10896-9-git-send-email-zab@redhat.com>
References: <1381182185-10896-1-git-send-email-zab@redhat.com> <1381182185-10896-9-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 07 Oct 2013 2:43:01 PM you wrote:
> This was found by static analysis.
> 
> Signed-off-by: Zach Brown <zab@redhat.com>
> ---
>  cmds-check.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index ebba58e..b6035d7 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -3228,13 +3228,13 @@ static int verify_space_cache(struct btrfs_root *root,
> 
>  	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
>  	if (ret < 0)
> -		return ret;
> +		goto out;
>  	ret = 0;
>  	while (1) {
>  		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
>  			ret = btrfs_next_leaf(root, path);
>  			if (ret < 0)
> -				return ret;
> +				goto out;
>  			if (ret > 0) {
>  				ret = 0;
>  				break;
> @@ -3274,6 +3274,8 @@ static int verify_space_cache(struct btrfs_root *root,
>  		ret = check_cache_range(root, cache, last,
>  					cache->key.objectid +
>  					cache->key.offset - last);
> +
> +out:
>  	btrfs_free_path(path);
> 
>  	if (!ret &&
> 
This has been fixed by commit 7ae60bf1. But I feel that your fix is
better since the clean up code is segregated to one place and hence we
have fewer places in the function where we return from.

Reviewed-by: chandan <chandan@linux.vnet.ibm.com>

