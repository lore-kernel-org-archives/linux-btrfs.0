Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:38473 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2INMQb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 08:16:31 -0400
Message-ID: <5053200E.3010702@oracle.com>
Date: Fri, 14 Sep 2012 20:16:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] Btrfs: fix trans block rsv regression
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com> <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com> <20120914111516.GF17430@twin.jikos.cz> <50531439.5080303@oracle.com> <20120914120711.GI17430@twin.jikos.cz>
In-Reply-To: <20120914120711.GI17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2012 08:07 PM, David Sterba wrote:
> On Fri, Sep 14, 2012 at 07:25:45PM +0800, Liu Bo wrote:
>> On 09/14/2012 07:15 PM, David Sterba wrote:
>>> On Fri, Sep 14, 2012 at 04:58:04PM +0800, Liu Bo wrote:
>>>> --- a/fs/btrfs/transaction.c
>>>> +++ b/fs/btrfs/transaction.c
>>>> @@ -306,9 +306,17 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
>>>>  		WARN_ON(type != TRANS_JOIN && type != TRANS_JOIN_NOLOCK &&
>>>>  			type != TRANS_JOIN_ONLY);
>>>>  		h = current->journal_info;
>>>> -		h->use_count++;
>>>> -		h->orig_rsv = h->block_rsv;
>>>> +		if (h->block_rsv) {
>>>> +			struct btrfs_trans_rsv_item *item;
>>>> +			item = kmalloc(sizeof(*item), GFP_NOFS);
>>>
>>> I'd rather avoid the kmalloc here and add a list hook into
>>> btrfs_block_rsv itself (used only for this purpose).
>>>
>>> It also does not increase the failure surface and we don't have to
>>> handle error conditions from deep callchains.
>>>
>>
>> Actually I placed a list hook at first, but I found the same block_rsv could be inserted into
>> the list chain twice, which will cause list_head's terrible warnings.
> 
> Is it expected and correct to add the rsv twice? I know the transaction
> joins and commits are sometimes wildly nested so it does not mean that's
> necessarily a bug. Then it is not possible to embed the list hook, we
> need to keep the full track of the blk_rsv stack.
> 
> I'm counting two other similar structs used inside btrfs
> (list_head + 8B value), we could make a shared separate slab for them.
> 
> struct delayed_iput {
>         struct list_head           list;                 /*     0    16 */
>         struct inode *             inode;                /*    16     8 */
> 
>         /* size: 24, cachelines: 1, members: 2 */
>         /* last cacheline: 24 bytes */
> };
> 
> truct seq_list {
>         struct list_head           list;                 /*     0    16 */
>         u64                        seq;                  /*    16     8 */
> 
>         /* size: 24, cachelines: 1, members: 2 */
>         /* last cacheline: 24 bytes */
> };
> 
> seq_list is never allocated, only embedded inside tree_mod_log structures.
> 
> delayed_iput is allocated on every add_delayed_iput and freed quite
> frequently (once per-commit at least), so this is a short-lived object
> as well as the proposed btrfs_trans_rsv_item. IMO this justifies using
> the slab. Does this sound good to you?
> 

Good, a quick thinking says it will work ;)

btw, do you have any test suit to measure this kind of cacheline efficiency so that
we can get some numbers to see if it really helps?

- liubo
> 
> david
> 

