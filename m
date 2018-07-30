Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36446 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726568AbeG3Kpr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 06:45:47 -0400
Subject: Re: [PATCH 11/15] btrfs-progs: Add delayed refs infrastructure
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <1528462078-24490-12-git-send-email-nborisov@suse.com>
 <7b355214-d883-c67d-a6a8-12e8aa32bc19@jp.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <b0282da1-9949-f5ee-ed34-3e744ed7541a@suse.com>
Date: Mon, 30 Jul 2018 12:11:42 +0300
MIME-Version: 1.0
In-Reply-To: <7b355214-d883-c67d-a6a8-12e8aa32bc19@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30.07.2018 11:34, Misono Tomohiro wrote:
> On 2018/06/08 21:47, Nikolay Borisov wrote:
>> This commit pulls those portions of the kernel implementation of
>> delayed refs which are necessary to have them working in user-space.
>> I've done the following modifications:
>>
>> 1. Replaced all kmem_cache_alloc calls to kmalloc.
>>
>> 2. Removed all locking-related code, since we are single threaded in
>> userspace.
>>
>> 3. Removed code which deals with data refs - delayed refs in user space
>> are going to be used only for cowonly trees.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  Makefile      |   3 +-
>>  ctree.h       |   3 +
>>  delayed-ref.c | 608 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  delayed-ref.h | 225 ++++++++++++++++++++++
>>  extent-tree.c | 228 ++++++++++++++++++++++
>>  kerncompat.h  |   8 +
>>  transaction.h |   4 +
>>  7 files changed, 1078 insertions(+), 1 deletion(-)
>>  create mode 100644 delayed-ref.c
>>  create mode 100644 delayed-ref.h
>>
>> diff --git a/Makefile b/Makefile
>> index 544410e6440c..9508ad4f11e6 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -116,7 +116,8 @@ objects = ctree.o disk-io.o kernel-lib/radix-tree.o extent-tree.o print-tree.o \
>>  	  qgroup.o free-space-cache.o kernel-lib/list_sort.o props.o \
>>  	  kernel-shared/ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
>>  	  inode.o file.o find-root.o free-space-tree.o help.o send-dump.o \
>> -	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o
>> +	  fsfeatures.o kernel-lib/tables.o kernel-lib/raid56.o transaction.o \
>> +	  delayed-ref.o
>>  cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
>>  	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
>>  	       cmds-quota.o cmds-qgroup.o cmds-replace.o check/main.o \
>> diff --git a/ctree.h b/ctree.h
>> index b30a946658ce..d1ea45571d1e 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -2812,4 +2812,7 @@ int btrfs_punch_hole(struct btrfs_trans_handle *trans,
>>  int btrfs_read_file(struct btrfs_root *root, u64 ino, u64 start, int len,
>>  		    char *dest);
>>  
>> +
>> +/* extent-tree.c */
>> +int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans, unsigned long nr);
>>  #endif
>> diff --git a/delayed-ref.c b/delayed-ref.c
>> new file mode 100644
>> index 000000000000..f3fa50239380
>> --- /dev/null
>> +++ b/delayed-ref.c
>> @@ -0,0 +1,608 @@
> 
> <snip>
> 
>> +
>> +static inline void drop_delayed_ref(struct btrfs_trans_handle *trans,
>> +				    struct btrfs_delayed_ref_root *delayed_refs,
>> +				    struct btrfs_delayed_ref_head *head,
>> +				    struct btrfs_delayed_ref_node *ref)
>> +{
>> +	rb_erase(&ref->ref_node, &head->ref_tree);
>> +	RB_CLEAR_NODE(&ref->ref_node);
>> +	if (!list_empty(&ref->add_list))
>> +		list_del(&ref->add_list);
>> +	ref->in_tree = 0;
>> +	btrfs_put_delayed_ref(ref);
> 
> Compared with kernel code, it seems that we need
> 
>         delayed_refs->num_entries--;
> 
>> +	if (trans->delayed_ref_updates)
>> +		trans->delayed_ref_updates--;
>> +}
> 
>> +static noinline struct btrfs_delayed_ref_head *
>> +add_delayed_ref_head(struct btrfs_trans_handle *trans,
>> +		     struct btrfs_delayed_ref_head *head_ref,
>> +		     void *qrecord,
>> +		     int action, int *qrecord_inserted_ret,
>> +		     int *old_ref_mod, int *new_ref_mod)
>> +{
>> +	struct btrfs_delayed_ref_head *existing;
>> +	struct btrfs_delayed_ref_root *delayed_refs;
>> +
>> +	delayed_refs = &trans->delayed_refs;
>> +
>> +	existing = htree_insert(&delayed_refs->href_root, &head_ref->href_node);
>> +	if (existing) {
>> +		update_existing_head_ref(delayed_refs, existing, head_ref, old_ref_mod);
>> +		/*
>> +		 * we've updated the existing ref, free the newly
>> +		 * allocated ref
>> +		 */
>> +		kfree(head_ref);
>> +		head_ref = existing;
>> +	} else {
>> +		if (old_ref_mod)
>> +			*old_ref_mod = 0;
>> +		delayed_refs->num_heads++;
>> +		delayed_refs->num_heads_ready++;
> 
> And
>                 delayed_refs->num_entries++;
> 
> to correctly count num_entries.
> (I noticed that num_entries went to negative value when I'm running gdb)
> 
> However, num_entries is actually not used in progs at all (it is used for
> throttling in kernel), so maybe we can just drop the variable from progs?

I agree, will fix it on next respin. But for now I will wait for more
reviews.

> 
>> +		trans->delayed_ref_updates++;
>> +	}
>> +	if (new_ref_mod)
>> +		*new_ref_mod = head_ref->total_ref_mod;
>> +
>> +	return head_ref;
>> +}
> 
> <snip>
> 
> 
