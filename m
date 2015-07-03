Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:20405 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753018AbbGCAb7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 20:31:59 -0400
Subject: Re: [PATCH v2 11/18] btrfs: qgroup: Add new qgroup calculation
 function btrfs_qgroup_account_extents().
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1430274551-9277-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1430274551-9277-12-git-send-email-quwenruo@cn.fujitsu.com>
 <20150702144349.GN726@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5595D7FC.60807@cn.fujitsu.com>
Date: Fri, 3 Jul 2015 08:31:56 +0800
MIME-Version: 1.0
In-Reply-To: <20150702144349.GN726@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/07/02 16:43 +0200:
> On Wed, Apr 29, 2015 at 10:29:04AM +0800, Qu Wenruo wrote:
>> The new btrfs_qgroup_account_extents() function should be called in
>> btrfs_commit_transaction() and it will update all the qgroup according
>> to delayed_ref_root->dirty_extent_root.
>>
>> The new function can handle both normal operation during
>> commit_transaction() or in rescan in a unified method with clearer
>> logic.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>> v2:
>>    Also free ulist even quota is disabled to avoid possible memory leak.
>> ---
>>   fs/btrfs/extent-tree.h |   0
>
> Surprise, this adds an empty file. What was the intention?
My fault, it seems I opened the non-existing file and saved it...
Do I need to submit a patch to remove it?

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
