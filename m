Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38868 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HPOZa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 10:25:30 -0400
Received: by pbbrr13 with SMTP id rr13so1658680pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 07:25:30 -0700 (PDT)
Message-ID: <502D02D0.6080800@gmail.com>
Date: Thu, 16 Aug 2012 22:25:20 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Arne Jansen <sensille@gmx.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: trivial code style fix in root-tree.c
References: <502CF2F0.7020601@gmail.com> <502CF450.50405@gmx.net> <502CF50C.9090006@gmail.com> <502CF602.8070105@gmx.net>
In-Reply-To: <502CF602.8070105@gmx.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年08月16日 21:30, Arne Jansen wrote:
> On 16.08.2012 15:26, Wang Sheng-Hui wrote:
>> On 2012年08月16日 21:23, Arne Jansen wrote:
>>> On 16.08.2012 15:17, Wang Sheng-Hui wrote:
>>>> Add code indent to the bad styled statements.
>>>>
>>>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>>>> ---
>>>>  root-tree.c |   10 ++++------
>>>>  1 files changed, 4 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/root-tree.c b/root-tree.c
>>>> index 782472c..39cfef6 100644
>>>> --- a/root-tree.c
>>>> +++ b/root-tree.c
>>>> @@ -182,12 +182,10 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>>  	if (ret < 0)
>>>>  		goto out;
>>>>  	if (ret) {
>>>> -btrfs_print_leaf(root, path->nodes[0]);
>>>> -printk("failed to del %llu %u %llu\n",
>>>> -	(unsigned long long)key->objectid,
>>>> -	key->type,
>>>> -	(unsigned long long)key->offset);
>>>> -
>>>
>>> I guess Alexander intentionally put in the bad indentation
>>> to remind him to remove this code before submitting the
>>> patch :)
>>>
>>>> +		btrfs_print_leaf(root, path->nodes[0]);
>>>> +		printk("failed to del %llu %u %llu\n",
>>>> +			(unsigned long long)key->objectid, key->type,
>>>> +			(unsigned long long)key->offset);
>>>>  	}
>>
>> When I saw the BUG_ON, I wonder do we still need the above branch statement.
>> It looks just to be helpful for debug - give out some info, right? 
> 
> Yes. So either we delete it completely or we move the BUG_ON
> into the block as a BUG_ON(1) and add a "Btrfs: "-prefix to the
> printk.
> On the other hand, I just saw this is progs, so I think it can
> just be deleted.
> 
>>
>>>>  	BUG_ON(ret != 0);
>>>>  	leaf = path->nodes[0];
>>>
>>
> 

Patch regenerated. Please check it. Thanks,

>From 2150cb3a3f75416b56a5eb9311fd0d4aa5aaaed5 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <shhuiw@gmail.com>
Date: Thu, 16 Aug 2012 22:23:07 +0800
Subject: [PATCH] btrfs-progs: code cleanup for root-tree.c/btrfs_del_root

Remove the redundant if check on the condition ret > 0.
Leave BUG_ON check here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 root-tree.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/root-tree.c b/root-tree.c
index 782472c..4578514 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -181,14 +181,6 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
 	if (ret < 0)
 		goto out;
-	if (ret) {
-btrfs_print_leaf(root, path->nodes[0]);
-printk("failed to del %llu %u %llu\n",
-	(unsigned long long)key->objectid,
-	key->type,
-	(unsigned long long)key->offset);
-
-	}
 	BUG_ON(ret != 0);
 	leaf = path->nodes[0];
 	ri = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_item);
-- 
1.7.1


