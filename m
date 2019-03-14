Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92DA7C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 10:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB6D2077B
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 10:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfCNKYH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 06:24:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:46269 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfCNKYH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 06:24:07 -0400
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LabZr-1gchTM06RD-00mM3V; Thu, 14
 Mar 2019 11:23:51 +0100
Subject: Re: [PATCH] btrfs: fix a NULL pointer dereference
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Nikolay Borisov <nborisov@suse.com>, Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190314075041.28966-1-kjlu@umn.edu>
 <b0b494f4-8686-8e50-faca-625d6f89bbe3@suse.com>
 <50fa02f1-18c0-b039-ec2f-e16b715f53ff@gmx.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <66e8b376-b254-621c-ab3f-6af9d3182689@gmx.com>
Date:   Thu, 14 Mar 2019 18:23:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0)
 Gecko/20100101 Thunderbird/66.0
MIME-Version: 1.0
In-Reply-To: <50fa02f1-18c0-b039-ec2f-e16b715f53ff@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:N9AY34vqCyIauzQWZK7xKOoKMM1n3tjuQuGJiFrbNvcp0PNaPDK
 mjUx9VWH9OWLs3yoxKKgubPoYRDjsYehzwEShoNzeKfbnP1rvr16FHJCh0+UzCU49ZX6/5o
 WX5n7mVEFu/0IWu+FClQOwictXPy/4MQS2th0SHltng1CyjfnnjuGcjcOa8kDrpi31RgKPe
 H4i6PJ/PjrH+YjazBMikg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jq+rUD2Qnv0=:u4d2e9ylhA7+PprSzKXFzL
 VYGpNbiogA43dL0sPJqYf+0EEGs1Jv+le99d1iaFA6/JPTS9fT5TUVeDeEQ32HOl/pUgErA17
 axNgeW/0Cg3Q1pOkeM1Z5aO5Z8i5C1HVoTVGgFsQ+NxulqPa1SVRm1twH0dAfmeslVK0oRz6j
 DuhNXItmJmwI9jl4mgF+i2X1uvXr0gCXV2fWVytsw/7MQrqFflWbsFkzHNjdRBXODtBvgK7gt
 GUi9XywOrqKWhKLaqa50ABdcVXfHTrvLqYkMA92lUArjh4KBeXBuqMkLxOJh3LS2JSfnJBgC6
 jrLNxOlWkgBFQ3To8FOdo8E+KXR7h+idsKpj0eAVQ5A73cVkBsUL8w306tfA19TZGZp5Ckvge
 VfFnI+TE6FoYu+PuXZegVABaPKx4L+5wb4vk5WDnD9QqrWxOYLEP3hYDPixFRZLUZhlGdoxAk
 omz1bRMIU94Q2fuCBDhwzI/n0LX6jYKywVWcjbuH5X9hQtW1d1S3HRd6L1n3fgjoIdz0hLACh
 gCPzAKZhPCYBnwUBzQmBIP77VmqpFO57ozBcOupOQZslVFXHIO78kYQl378XzJL6g0s56JKHv
 utzeeTeMrWITppTZWETXkvpvFKhTdTBXPQNj53WvZMLaUZLktRZKrgk4S3OORnyF3QuCk8hCm
 i87XIgoeQDy6OODKrt5W7N6tvRbj31KsekcTJnzdpPQarS65OoGkkpsd8uDL/AyK1Nolpa1SG
 7Izy5FM+SXSzWoAEs1OQ/IdvAIVG1lVcNF3W87vzuPf6T9Fvt+/SPMCPM2cuf9JS6hM29qxfU
 /BCgVcLHY3KX/+bpMjVQ32usCZDMku2Kb5bKF1GmN1wzzlWG4lL8AWBCQA2riIrxhB/cOqNzw
 bZIiyrxA2En/ydkyfDnRJLwSNAp7SVNetkTt0DZ0/9Po3HRg4q0e7dLlPGBhz3Qn+hHtYHj4J
 pXGLu1pGG9A==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/14 4:02 PM, Qu Wenruo wrote:
> 
> 
> On 2019/3/14 下午3:54, Nikolay Borisov wrote:
>>
>>
>> On 14.03.19 г. 9:50 ч., Kangjie Lu wrote:
>>> btrfs_lookup_block_group may fail and return NULL. The fix goes
>>> to out when it fails to avoid NULL pointer dereference.
>>
>> Actually no, in this case btrfs_lookup_block_group must never fail
>> because if we have an allocated eb then it must have been allocated from
>> a bg.
> 
> Yep, that's the normal case.
> 
> However I'm wondering if it's possible to get a bad eb which is cached.
> 
> Then we could hit such situation.
> 
> So I still believe being safe here still makes sense, especially who
> knows future fuzzed image will be.

Plus one.
Personally, I'd rather like the version 1.

Thanks,
Su
> 
> Thanks,
> Qu
> 
>>
>>>
>>> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
>>> ---
>>>   fs/btrfs/extent-tree.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>> index 994f0cc41799..b1e7985bcb9d 100644
>>> --- a/fs/btrfs/extent-tree.c
>>> +++ b/fs/btrfs/extent-tree.c
>>> @@ -7303,6 +7303,8 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>>>   
>>>   		pin = 0;
>>>   		cache = btrfs_lookup_block_group(fs_info, buf->start);
>>> +		if (!cache)
>>> +			goto out;
>>>   
>>>   		if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
>>>   			pin_down_extent(fs_info, cache, buf->start,
>>>
