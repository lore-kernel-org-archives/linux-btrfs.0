Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50925 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757243AbcFAFny (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jun 2016 01:43:54 -0400
Subject: Re: [PATCH] btrfs: fix check_shared for fiemap ioctl
To: <dsterba@suse.cz>
References: <1463369030-15434-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160530152506.GC29147@twin.jikos.cz>
 <b3c38efb-ddb6-d2b8-34e6-558b1c44065a@cn.fujitsu.com>
 <20160531162325.GJ29147@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: luke <lufq.fnst@cn.fujitsu.com>
Message-ID: <6b57e774-27f5-d9a7-8bf0-d83b8da6f209@cn.fujitsu.com>
Date: Wed, 1 Jun 2016 13:43:37 +0800
MIME-Version: 1.0
In-Reply-To: <20160531162325.GJ29147@suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 06/01/2016 12:23 AM, David Sterba wrote:
> On Tue, May 31, 2016 at 03:27:42PM +0800, luke wrote:
>>>> +static void ref_root_fini(struct ref_root *ref_tree)
>>>> +{
>>>> +	struct ref_node *node;
>>>> +	struct rb_node *next;
>>>> +
>>>> +	while ((next = rb_first(&ref_tree->rb_root)) != NULL) {
>>>> +		node = rb_entry(next, struct ref_node, rb_node);
>>>> +		rb_erase(next, &ref_tree->rb_root);
>>>> +		kfree(node);
>>> This could be slow as rb_erase has to do the rb-tree rotations. Can we
>>> do a post-order traversal and just free the nodes?
>> Excuse me, this seems to be standard way to release the rb-tree. For
>> example,  "btrfs_free_block_groups" this function is the same way. So
>> should i refactor this function?
> So for first version it's ok to keep it the simple way, but refactoring
> to the post-order traversal should help performance. And as there are
> more places it would be better to do it separately.
>
>
Yes, you're right. I have updated this patch to fix other problems. And, 
I'll refactor this function with another patch soon.

Thanks,
Lu


