Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:35953 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752471AbeFYB3R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Jun 2018 21:29:17 -0400
Subject: Re: [PATCH v2] btrfs: return EUCLEAN if extent_inline_ref type is
 invalid
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20180622075349.17976-1-suy.fnst@cn.fujitsu.com>
 <20180622081801.19891-1-suy.fnst@cn.fujitsu.com>
 <20180622094038.GW24375@twin.jikos.cz>
 <7a864047-c1e8-0044-8660-e3862b5df78d@cn.fujitsu.com>
Message-ID: <2a85935e-3446-8c8a-f31a-5d7a6748a43a@cn.fujitsu.com>
Date: Mon, 25 Jun 2018 09:35:28 +0800
MIME-Version: 1.0
In-Reply-To: <7a864047-c1e8-0044-8660-e3862b5df78d@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/25/2018 09:28 AM, Su Yue wrote:
> 
> 
> On 06/22/2018 05:40 PM, David Sterba wrote:
>> On Fri, Jun 22, 2018 at 04:18:01PM +0800, Su Yue wrote:
>>> If type of extent_inline_ref found is not expected, filesystem may have
>>> been corrupted, should return EUCLEAN instead of EINVAL.
>>> No functional changes.
>>>
>>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>>> ---
>>> Changelog:
>>> v2:
>>>   Add changes in build_backref_tree, get_extent_inline_ref and
>>>     add_inline_refs.
>>
>> v2 looks good. I saw one implicit check for invalid ref in
>> add_data_references that still returns -EINVAL.
>>
>> The implicit check is located in relocation.c:3804. I changeds/3804/3801
> it in v1 which is not listed in changedlog.
> Did I need to sent v3 to list all functions in commit message?
> 
> Thanks,
> Su
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


