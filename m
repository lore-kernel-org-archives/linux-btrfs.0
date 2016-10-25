Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31186 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754175AbcJYC5u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Oct 2016 22:57:50 -0400
Subject: Re: [PATCH v13.1 00/14] Btrfs In-band De-duplication
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161020020339.21208-1-quwenruo@cn.fujitsu.com>
 <20161024174658.GI22935@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <fef80822-388a-ea7d-c221-6900e83c2fc9@cn.fujitsu.com>
Date: Tue, 25 Oct 2016 10:57:38 +0800
MIME-Version: 1.0
In-Reply-To: <20161024174658.GI22935@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/25/2016 01:46 AM, David Sterba wrote:
> On Thu, Oct 20, 2016 at 10:03:39AM +0800, Qu Wenruo wrote:
>> Qu Wenruo (4):
>>   btrfs: delayed-ref: Add support for increasing data ref under spinlock
>>   btrfs: dedupe: Inband in-memory only de-duplication implement
>>   btrfs: relocation: Enhance error handling to avoid BUG_ON
>>   btrfs: dedupe: Introduce new reconfigure ioctl
>>
>> Wang Xiaoguang (10):
>>   btrfs: dedupe: Introduce dedupe framework and its header
>>   btrfs: dedupe: Introduce function to initialize dedupe info
>>   btrfs: dedupe: Introduce function to add hash into in-memory tree
>>   btrfs: dedupe: Introduce function to remove hash from in-memory tree
>>   btrfs: dedupe: Introduce function to search for an existing hash
>>   btrfs: dedupe: Implement btrfs_dedupe_calc_hash interface
>>   btrfs: ordered-extent: Add support for dedupe
>>   btrfs: dedupe: Add ioctl for inband dedupelication
>>   btrfs: improve inode's outstanding_extents computation
>
> I've noticed that this patch is different from what Wang sent
> independently. Is the patch necessary for the dedupe patchset? If not,
> please drop it.

Yes, Wang is still working the ENOSPC fix, which doesn't only affect 
dedupe, but also compression.

>
> The merge conflict is in the checks for free space inode,
>
>   if (root == root->fs_info->tree_root)
>
> vs
>
>   if (!btrfs_is_free_space_inode(...))
>
> If you need the patch, then please update it to the latest version. I
> won't get the merge conflicts at least, this is acceptable for the
> testing 'for-next' branch.

I'll re-order the patches, maybe put his ENOSPC fixes at the end or 
beginning.

Since Wang hopes to fix ENOSPC for both compression and dedupe, the 
patchset rebase will be blocked for several days.

Thanks,
Qu


