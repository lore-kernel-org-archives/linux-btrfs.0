Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52539 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3CYMWQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Mar 2013 08:22:16 -0400
Received: by mail-pd0-f180.google.com with SMTP id g10so2513092pdj.39
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2013 05:22:15 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 2/2] Btrfs: kill some BUG_ONs() in the find_parent_nodes()
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <51503968.2040005@jan-o-sch.net>
Date: Mon, 25 Mar 2013 20:22:10 +0800
Cc: linux-btrfs@vger.kernel.org, sensille@gmx.net
Message-Id: <3D446370-33D7-4AC3-9B2A-01A302711363@gmail.com>
References: <1364209747-1623-1-git-send-email-wangshilong1991@gmail.com> <51503968.2040005@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> 
> On Mon, March 25, 2013 at 12:09 (+0100), Wang Shilong wrote:
>> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> 
>> The reason that BUG_ON() happens in these places is just
>> because of ENOMEM. 
>> 
>> We try ro return ENOMEM rather than trigger BUG_ON(), the
>> caller will abort the transaction thus avoiding the kernel panic.
>> 
>> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>> fs/btrfs/backref.c |    6 ++++--
>> 1 files changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index bd605c8..a5e2beb 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -900,7 +900,8 @@ again:
>> 		if (ref->count && ref->root_id && ref->parent == 0) {
>> 			/* no parent == root of tree */
>> 			ret = ulist_add(roots, ref->root_id, 0, GFP_NOFS);
>> -			BUG_ON(ret < 0);
>> +			if (ret)
>> +				goto out;
>> 		}
>> 		if (ref->count && ref->parent) {
>> 			struct extent_inode_elem *eie = NULL;
>> @@ -920,6 +921,8 @@ again:
>> 			ret = ulist_add_merge(refs, ref->parent,
>> 					      (uintptr_t)ref->inode_list,
>> 					      (u64 *)&eie, GFP_NOFS);
>> +			if (ret)
>> +				goto out;
>> 			if (!ret && extent_item_pos) {
> 
> Remove ret here, too, please.

Thanks for reviewing! I've addressed your comments and
V2 has been sent out.

Thanks,
Wang

> 
>> 				/*
>> 				 * we've recorded that parent, so we must extend
>> @@ -930,7 +933,6 @@ again:
>> 					eie = eie->next;
>> 				eie->next = ref->inode_list;
>> 			}
>> -			BUG_ON(ret < 0);
>> 		}
>> 		kfree(ref);
>> 	}
>> 
> 
> Otherwise,
> 
> Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> 
> Thanks!
> -Jan

