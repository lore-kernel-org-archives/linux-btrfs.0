Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41152 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2HPMQF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 08:16:05 -0400
Received: by pbbrr13 with SMTP id rr13so1502903pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 05:16:05 -0700 (PDT)
Message-ID: <502CE47C.9070604@gmail.com>
Date: Thu, 16 Aug 2012 20:15:56 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Jie Liu <jeff.liu@oracle.com>
CC: sensille@gmx.net, chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction
References: <502CA7E6.8020004@gmail.com> <502CA945.602@gmx.net> <502CB573.8000107@oracle.com>
In-Reply-To: <502CB573.8000107@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年08月16日 16:55, Jie Liu wrote:
> On 08/16/12 16:03, Arne Jansen wrote:
>> On 16.08.2012 09:57, Wang Sheng-Hui wrote:
>>> For malloc may fail, we should check it before assign
>>> values to the fields of struct btrfs_trans_handle *h.
>>>
>>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>>> ---
>>>  transaction.h |    5 +++++
>>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/transaction.h b/transaction.h
>>> index a1070e0..d4e42a1 100644
>>> --- a/transaction.h
>>> +++ b/transaction.h
>>> @@ -32,7 +32,12 @@ static inline struct btrfs_trans_handle *
>>>  btrfs_start_transaction(struct btrfs_root *root, int num_blocks)
>>>  {
>>>  	struct btrfs_fs_info *fs_info = root->fs_info;
>>> +
> Why move down a blank line?
>>>  	struct btrfs_trans_handle *h = malloc(sizeof(*h));
> Skip a line here would looks a bit neat.
>>> +	if (!h) {
>>> +		BUG();
>>> +		return NULL;
>>> +	}
>> a more simple way would be to write
>> BUG_ON(!h);
>>
>>>  
>>>  	BUG_ON(root->commit_root);
>>>  	BUG_ON(fs_info->running_transaction);
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Patch regenerated. Please check it. Thanks,

>From 5a265e252e87a8a456a6615affd57dfb49900c64 Mon Sep 17 00:00:00 2001
From: Wang Sheng-Hui <shhuiw@gmail.com>
Date: Thu, 16 Aug 2012 20:14:32 +0800
Subject: [PATCH] btrfs-progs: add malloc check in transaction.h/btrfs_start_transaction

For malloc may fail, we should check it before assign
values to the struct btrfs_trans_handle *h.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 transaction.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/transaction.h b/transaction.h
index a1070e0..e8610b1 100644
--- a/transaction.h
+++ b/transaction.h
@@ -34,6 +34,7 @@ btrfs_start_transaction(struct btrfs_root *root, int num_blocks)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_trans_handle *h = malloc(sizeof(*h));
 
+	BUG_ON(!h);
 	BUG_ON(root->commit_root);
 	BUG_ON(fs_info->running_transaction);
 	fs_info->running_transaction = h;
-- 
1.7.1



