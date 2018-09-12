Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51875 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbeILQ4D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 12:56:03 -0400
Subject: Re: [PATCH 00/15] Add delayed-refs support to btrfs-progs
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <20180716153956.GL3126@twin.jikos.cz>
From: Su Yue <Damenly_Su@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <4e07ad89-20df-a531-6c47-e7fa0df7beb6@gmx.com>
Date: Wed, 12 Sep 2018 19:51:39 +0800
MIME-Version: 1.0
In-Reply-To: <20180716153956.GL3126@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/7/16 11:39 PM, David Sterba wrote:
> On Fri, Jun 08, 2018 at 03:47:43PM +0300, Nikolay Borisov wrote:
>> Hello,
>>                                                                                  
>> Here is a series which adds support for delayed refs. This is needed to enable
>> later work on adding freespace tree repair code. Additionally, it results in
>> more code sharing between kernel/user space.
>>
>> Patches 1-9 are simple prep patches removing some arguments, causing problems
>> later. They can go independently of the delayed refs work. They don't introduce
>> any functional changes. Next, patches 10-13 introduce the needed infrastructure
>> to for delayed refs without actually activating it. Patch 14 finally wires it
>> up by adding the necessary call outs to btrfs_run_delayed refs and reworking the
>> extent addition/freeing functions. With all of this done, patch 15 finally
>> removes the old code.
>>
>> This series passes all btrfs progs fsck and misc tests + fuzz tests apart from
>> fuzz-003/007/009 - but those fail without this series so it's unlikely it's
>> caused by it.
>>
>> Nikolay Borisov (15):
>>    btrfs-progs: Remove root argument from pin_down_bytes
>>    btrfs-progs: Remove root argument from btrfs_del_csums
>>    btrfs-progs: Add functions to modify the used space by a root
>>    btrfs-progs: Refactor the root used bytes are updated
>>    btrfs-progs: Make update_block_group take fs_info instead of root
>>    btrfs-progs: check: Drop trans/root arguments from free_extent_hook
>>    btrfs-progs: Remove root argument from __free_extent
>>    btrfs-progs: Remove root argument from alloc_reserved_tree_block
>>    btrfs-progs: Always pass 0 for offset when calling btrfs_free_extent
>>      for btree blocks.
>>    btrfs-progs: Add boolean to signal whether we are re-initing extent
>>      tree
>>    btrfs-progs: Add delayed refs infrastructure
>>    btrfs-progs: Add __free_extent2 function
>>    btrfs-progs: Add alloc_reserved_tree_block2 function
>>    btrfs-progs: Wire up delayed refs
>>    btrfs-progs: Remove old delayed refs infrastructure
> 
> Added to devel. There were some patch-to-patch compilation issues,
> function alloc_reserved_tree_block2 used earlier than defined so I
> reordered the patches to fix that.
> 
> The CI fails at test check/020-extent-ref-cases but it works on my
> machine so it's not caused by the patchset.

Hi, David
Actually, now kdave/devel still fails at fsck-tests/020 due to
version 1st of this patchset. See the thread please
https://www.spinics.net/lists/linux-btrfs/msg81675.html

Nikolay's V2 patchset should slove the problem.
You may have known the situation, this mail is just a gentle reminder :).

Thanks,
Su
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
