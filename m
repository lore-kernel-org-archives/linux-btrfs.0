Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:7784 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728417AbeHDShT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2018 14:37:19 -0400
Date: Sun, 5 Aug 2018 00:35:48 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: zhong jiang <zhongjiang@huawei.com>
CC: <clm@fb.com>, <jbacik@fb.com>, <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs/extent_map: Remove unneeded variable "ret"
Message-ID: <20180804163548.GG2049@fnst.localdomain>
References: <1533381223-16734-1-git-send-email-zhongjiang@huawei.com>
 <20180804125947.GF2049@fnst.localdomain>
 <5B65A7E9.90607@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5B65A7E9.90607@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 04, 2018 at 09:19:37PM +0800, zhong jiang wrote:
>On 2018/8/4 20:59, Lu Fengqi wrote:
>> On Sat, Aug 04, 2018 at 07:13:43PM +0800, zhong jiang wrote:
>>> The ret is not used after initalization, So just remove it.
>> So why not change these two functions to void function?
>>
> I just keep the original interface  and make the minimal change.
>of course,   It is also feasible that make these two functions to void function.
>
>I will repost if  you prefer to that change.  I am ok with that.

Since the return value which always is 0 is meaningless, I would prefer
to make this change.

-- 
Thanks,
Lu

>
>Thanks,
>zhong jiang
>
>
>


