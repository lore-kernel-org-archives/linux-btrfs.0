Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1487 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718AbaLXBJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 20:09:31 -0500
Message-ID: <549A1244.2000309@cn.fujitsu.com>
Date: Wed, 24 Dec 2014 09:09:24 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: rebuild missing block group during chunk
 recovery if possible
References: <1414637643-12271-1-git-send-email-quwenruo@cn.fujitsu.com> <CAOcd+r3PxsecRaHOe1RLbxEhWubdy2dzUmE65BDkvmcgb7_9tw@mail.gmail.com>
In-Reply-To: <CAOcd+r3PxsecRaHOe1RLbxEhWubdy2dzUmE65BDkvmcgb7_9tw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs-progs: rebuild missing block group during 
chunk recovery if possible
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月24日 00:49
> Hi Qu,
>
> On Thu, Oct 30, 2014 at 4:54 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> [snipped]
>> +
>> +static int __insert_block_group(struct btrfs_trans_handle *trans,
>> +                               struct chunk_record *chunk_rec,
>> +                               struct btrfs_root *extent_root,
>> +                               u64 used)
>> +{
>> +       struct btrfs_block_group_item bg_item;
>> +       struct btrfs_key key;
>> +       int ret = 0;
>> +
>> +       btrfs_set_block_group_used(&bg_item, used);
>> +       btrfs_set_block_group_chunk_objectid(&bg_item, used);
> This looks like a bug. Instead of "used", I think it should be
> "BTRFS_FIRST_CHUNK_TREE_OBJECTID".
Oh, my mistake, BTRFS_FIRST_CHUNK_TREE_OBJECTID is right.
Thanks for pointing out this.
>
>> [snipped]
>> --
>> 2.1.2
> Couple of questions:
> # In remove_chunk_extent_item, should we also consider "rebuild"
> chunks now? It can happen that a "rebuild" chunks is a SYSTEM chunk.
> Should we try to handle it as well?
Not quite sure about the meaning of "rebuild" here.
The chunk-recovery has the rebuild_chunk_tree() function to rebuild the 
whole chunk tree with
the good/repaired chunks we found.
> # Same question for "rebuild_sys_array". Should we also consider
> "rebuild" chunks?
The chunk-recovery has rebuild_sys_array() to handle SYSTEM chunk too.

Thanks,
Qu
>
> Thanks,
> Alex.
>
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

