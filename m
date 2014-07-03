Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:48385 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaGCFq0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 01:46:26 -0400
Received: from /spool/local
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 3 Jul 2014 15:46:23 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 917E62BB0047
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Jul 2014 15:46:21 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s635k4qX6422986
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 15:46:05 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s635kKdg003134
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 15:46:20 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: Re: [PATCH] Btrfs: implement support for fallocate collapse range
Date: Thu, 03 Jul 2014 11:16:18 +0630
Message-ID: <2201007.I7dgLZVjz9@localhost.localdomain>
In-Reply-To: <1403519147-19520-1-git-send-email-fdmanana@gmail.com>
References: <1403519147-19520-1-git-send-email-fdmanana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 23 Jun 2014 11:25:47 Filipe David Borba Manana wrote:
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index aeab453..8f1a371 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -2825,12 +2825,12 @@ cow_done:
>  		 * It is safe to drop the lock on our parent before we
>  		 * go through the expensive btree search on b.
>  		 *
> -		 * If we're inserting or deleting (ins_len != 0), then we might
> -		 * be changing slot zero, which may require changing the parent.
> -		 * So, we can't drop the lock until after we know which slot
> -		 * we're operating on.
> +		 * If we're inserting, deleting or updating a key (cow != 0),
> +		 * then we might be changing slot zero, which may require
> +		 * changing the parent. So, we can't drop the lock until after
> +		 * we know which slot we're operating on.
>  		 */
> -		if (!ins_len && !p->keep_locks) {
> +		if (!cow && !p->keep_locks) {
>  			int u = level + 1;

For the "key update" case (i.e. (ins_len == 0) and (cow == 1)), maybe
we could optimize by having a variable to hold the return value of
should_cow_block(), i.e. it keeps track of whether the current
metadata block was COWed. If the variable indicates that the block was
*not* COWed, then we could release the lock on the parent block since
the update operation (even on slot 0) isn't going to change the
corresponding entry in the parent block.

Thanks,
chandan

