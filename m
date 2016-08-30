Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19275 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758141AbcH3Ls3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 07:48:29 -0400
Subject: Re: [PATCH] btrfs-progs: check: skip shared node or leaf check for
 low_memory mode
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        <linux-btrfs@vger.kernel.org>
References: <20160819095946.31917-1-wangxg.fnst@cn.fujitsu.com>
 <20160824124431.GQ16983@twin.jikos.cz> <57BE8261.4040308@cn.fujitsu.com>
 <20160829152035.GV16983@twin.jikos.cz>
 <0158e565-3bb8-01fb-362f-6d5d8ec4cf35@cn.fujitsu.com>
 <20160830113202.GB16983@suse.cz>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <57C57191.1030909@cn.fujitsu.com>
Date: Tue, 30 Aug 2016 19:44:17 +0800
MIME-Version: 1.0
In-Reply-To: <20160830113202.GB16983@suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 08/30/2016 07:32 PM, David Sterba wrote:
> On Tue, Aug 30, 2016 at 09:50:20AM +0800, Qu Wenruo wrote:
>>> Are they not? The low-memory patchset has been released in 4.7.1, the
>>> devel branch is always on top of master branch. I see both branches
>>> pushed to the public git repos so I don't see what you mean.
>> Unfortunately, the low memory mode is not fully merged into devel branch.
>>
>> Only the first part (extent and chunk tree) is merged.
>>
>> The second part(fs tree) is not merged yet.
>>
>> Patches like the following is not in either devel/master branch:
>> Lu Fengqi (13):
>>     btrfs-progs: move btrfs_extref_hash() to hash.h
>>     btrfs-progs: check: introduce function to find dir_item
>>     btrfs-progs: check: introduce function to check inode_ref
>>     btrfs-progs: check: introduce function to check inode_extref
>>     btrfs-progs: check: introduce function to find inode_ref
>>     btrfs-progs: check: introduce a function to check dir_item
>>     btrfs-progs: check: introduce function to check file extent
>>     btrfs-progs: check: introduce function to check inode item
>>     btrfs-progs: check: introduce function to check fs root
>>     btrfs-progs: check: introduce function to check root ref
>>     btrfs-progs: check: introduce low_memory mode fs_tree check
>>     btrfs-progs: check: fix the return value bug of cmd_check()
>>     btrfs-progs: check: fix false warning for check_extent_item()
>>
>> So Wang found it confusing and unable to apply his patch to devel branch.
> He could have replied himself, I think the conversation would feel
> better when we can talk directly :)
Yes, I agree. I was on leave for a while this morning :)

Regards,
Xiaoguang Wang
>
> So the situation with the patchset is a bit messed up. I thought there
> was only one patchset for the low-memory mode as the subjects are hard
> to tell appart "introduce something" 20 times. I should have spotted
> that, but you know how many patches float in the mailinglist, mistakes
> happen.
>
> Now that I know where the problem is, I'll add the remaining patches to
> devel and release in next or next-next round, depending on the review.
>
>



