Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34443 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754229Ab3LQO4R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 09:56:17 -0500
Message-ID: <52B06607.9000108@fb.com>
Date: Tue, 17 Dec 2013 09:56:07 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: move the extent buffer radix tree into the fs_info
References: <1387218386-5339-1-git-send-email-jbacik@fb.com> <20131217010627.GK6498@twin.jikos.cz>
In-Reply-To: <20131217010627.GK6498@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/16/2013 08:06 PM, David Sterba wrote:
> On Mon, Dec 16, 2013 at 01:26:26PM -0500, Josef Bacik wrote:
>> I need to create a fake tree to test qgroups and I don't want to have to setup a
>> fake btree_inode.  The fact is we only use the radix tree for the fs_info, so
>> everybody else who allocates an extent_io_tree is just wasting the space anyway.
>> This patch moves the radix tree and its lock into btrfs_fs_info so there is less
>> stuff I have to fake to do qgroup sanity tests.  Thanks,
> This would make the fs_info::buffer_lock a global hotspot if
> alloc_extent_buffer and release_extent_buffer are called frequently.
>
> But, you can get rid of the buffer_lock completely, because the radix
> tree can be safely protected by rcu_read_lock/_unlock:
>
> * alloc_extent_buffer uses radix_preload that turns off preepmtion by
> itself, so the lock here would be pointless

Except you still need a lock for other inserts.
>
> * release_extent_buffer locks around radix_tree_delete, here a rcu
> locking will be ok as well

No it won't.  RCU just makes sure readers don't get screwed, you still 
need to have real locking around the insertions/deletions, look at 
pagecache, we have mapping->tree_lock for this even though it uses rcu 
for the lookups.  Thanks,

Josef
