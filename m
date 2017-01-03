Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11199 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751960AbdACAx7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jan 2017 19:53:59 -0500
Subject: Re: [PULL REQUEST FOR NEXT PATCH 00/26] Patches from Fujitsu for next
 version
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <jbacik@fb.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <20161230010036.28099-1-quwenruo@cn.fujitsu.com>
 <20170102164738.GK12081@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <0928a79c-d6ec-6cf3-d2ae-b224aa6a697d@cn.fujitsu.com>
Date: Tue, 3 Jan 2017 08:53:54 +0800
MIME-Version: 1.0
In-Reply-To: <20170102164738.GK12081@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/03/2017 12:47 AM, David Sterba wrote:
> On Fri, Dec 30, 2016 at 09:00:36AM +0800, Qu Wenruo wrote:
>> Hi, please fetch the following branch for next branch:
>> https://github.com/adam900710/linux.git fujitsu_for_next
>>
>> This branch contains most of Fujitsu unmerged patches for for-next branch.
>>
>> Latest David's for-next-20161219 branch can cause kernel panic so I don't
>> use it as base, but v4.10-rc1.
>
> The for-next branch will be reassembled again as we're past rc1 now.
>
>> I ran the full xfstests test cases, with both default mount options and
>> compress=lzo options.
>> Fixes are working and no new regression.
>>
>> So I thing it should be good enough to act as a base for for-next branch.
>>
>> This big patch set contains the following fixes:
>>
>> 1) Wang's fixes for compression ENOSPC
>
> AFAIK, the patches have been reviewed only partially and used to be part
> of for-next until the merge conflicts became unbearable. Patches
> touching space handling need review before merging and at least some
> sort of ack in case of for-next.
>
>> 2) Qgroup reserved space fix and WARN_ON
>
> Similar situation here.

Hopes comments from Chandan would help to merge some of the qgroup patches.
(I just forgot to add his tags, sorry Chandan)

btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
https://patchwork.kernel.org/patch/9457621/

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

btrfs: qgroup: Fix qgroup reserved space underflow by only freeing 
reserved ranges
https://patchwork.kernel.org/patch/9457619/

Reviewed-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Tested-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Thanks,
Qu

>
>> 3) Inband dedupe work
>
> As this is a new feature, I'll postpone it for now until the for-next
> branch is settled after the merge window.
>
>


