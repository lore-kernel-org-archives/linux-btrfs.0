Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:59885 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932395AbeFKHqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Jun 2018 03:46:35 -0400
Subject: Re: [PATCH 11/15] btrfs-progs: Add delayed refs infrastructure
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-12-git-send-email-nborisov@suse.com>
 <091f70e9-e31f-2a03-cc90-6697803f8c3c@gmx.com>
 <1c3a3cc8-8ba6-277e-28c8-f2b95c45da64@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <075e0087-9124-6dbf-6f61-dd5dd23548da@gmx.com>
Date: Mon, 11 Jun 2018 15:46:22 +0800
MIME-Version: 1.0
In-Reply-To: <1c3a3cc8-8ba6-277e-28c8-f2b95c45da64@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月11日 15:10, Nikolay Borisov wrote:
> 
> 
> On 11.06.2018 08:20, Qu Wenruo wrote:
>>
>>
>> On 2018年06月08日 20:47, Nikolay Borisov wrote:
>>> This commit pulls those portions of the kernel implementation of
>>> delayed refs which are necessary to have them working in user-space.
>>> I've done the following modifications:
>>>
>>> 1. Replaced all kmem_cache_alloc calls to kmalloc.
>>>
>>> 2. Removed all locking-related code, since we are single threaded in
>>> userspace.
>>>
>>> 3. Removed code which deals with data refs - delayed refs in user space
>>> are going to be used only for cowonly trees.
>>
>> That's pretty good, although still some data ref related
>> structures/functions are left.
>>
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>>  Makefile      |   3 +-
>>>  ctree.h       |   3 +
>>>  delayed-ref.c | 608 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  delayed-ref.h | 225 ++++++++++++++++++++++
>>>  extent-tree.c | 228 ++++++++++++++++++++++
>>>  kerncompat.h  |   8 +
>>>  transaction.h |   4 +
>>>  7 files changed, 1078 insertions(+), 1 deletion(-)
>>>  create mode 100644 delayed-ref.c
>>>  create mode 100644 delayed-ref.h
>>>
>>> diff --git a/Makefile b/Makefile
>>> index 544410e6440c..9508ad4f11e6 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -116,7 +116,8 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
>>>  	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
>>>  	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
>>>  	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
>>> -	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
>>> +	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o \
>>> +	  delayed-ref.o
>>>  cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>>>  	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>>>  	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
>>> diff --git a/ctree.h b/ctree.h
>>> index b30a946658ce..d1ea45571d1e 100644
>>> --- a/ctree.h
>>> +++ b/ctree.h
>>> @@ -2812,4 +2812,7 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
>>>  int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
>>>  		    char *dest);
>>>  
>>> +
>>> +/* extent-tree.c */
>>> +int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans, unsigned long nr);
>>>  #endif
>>> diff --git a/delayed-ref.c b/delayed-ref.c
>>> new file mode 100644
>>> index 000000000000..f3fa50239380
>>> --- /dev/null
>>> +++ b/delayed-ref.c
>>> @@ -0,0 +1,608 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) 2009 Oracle.  All rights reserved.
>>> + */
>>> +
>>> +#include "ctree.h"
>>> +#include "btrfs-list.h"
>>> +#include "delayed-ref.h"
>>> +#include "transaction.h"
>>> +
>>> +/*
>>> + * delayed back reference update tracking.  For subvolume trees
>>> + * we queue up extent allocations and backref maintenance for
>>> + * delayed processing.   This avoids deep call chains where we
>>> + * add extents in the middle of btrfs_search_slot, and it allows
>>> + * us to buffer up frequently modified backrefs in an rb tree instead
>>> + * of hammering updates on the extent allocation tree.
>>> + */
>>
>> A little more explanation on how delayed ref works will be more appricated.
> 
> I just copy/pasted that from the kernel code.> TBH I'm not too familiar

Neither do I.

> with the backref lookup code to write something but I guess I can take a
> look at it and perhaps add information to the btrfs-devs-docs. For now
> I'm confident in my understanding of the delayed allocation/freeing logic.

It doesn't need to be that detailed.

My expectation is just some simple comments on:
1) The purpose.
   Speedup for kernel.
   And some dirty hack for fst?

2) The basic data structures.
   A rbtree of delayed ref heads for each dirty extents.
   Then a list of extent operations in on delayed ref head.
   Each delayed data/tree ref represents a reference update
   (add/remove/creation)

3) When delayed ref is written to disk.
   At transaction time.

So just a basic overview, and reviewer could get some clue how to get
deeper if needed.

Thanks,
Qu

> 
>>
>> [snip]
>>> +struct btrfs_delayed_tree_ref {
>>> +	struct btrfs_delayed_ref_node node;
>>> +	u64 root;
>>> +	u64 parent;
>>> +	int level;
>>> +};
>>> +
>>> +struct btrfs_delayed_data_ref {
>>> +	struct btrfs_delayed_ref_node node;
>>> +	u64 root;
>>> +	u64 parent;
>>> +	u64 objectid;
>>> +	u64 offset;
>>> +};
>>
>> Since we don't use this structure and don't support data ref yet, what
>> about just removing this definiation?
> 
> Saw that tooand immediately sent v2 :)
> 
>>
>> [snip]
>>
>>> +struct btrfs_delayed_ref_head *
>>> +btrfs_select_ref_head(struct btrfs_trans_handle *trans);
>>> +
>>> +/*
>>> + * helper functions to cast a node into its container
>>> + */
>>> +static inline struct btrfs_delayed_tree_ref *
>>> +btrfs_delayed_node_to_tree_ref(struct btrfs_delayed_ref_node *node)
>>> +{
>>> +	return container_of(node, struct btrfs_delayed_tree_ref, node);
>>> +}
>>> +
>>> +static inline struct btrfs_delayed_data_ref *
>>> +btrfs_delayed_node_to_data_ref(struct btrfs_delayed_ref_node *node)
>>> +{
>>> +	return container_of(node, struct btrfs_delayed_data_ref, node);
>>> +}
>>
>> So is the only user of btrfs_delayed_data_ref structure.
> 
> Fixed in v2
>>
>> Thanks,
>> Qu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
