Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48627 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbcD2Nvn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Apr 2016 09:51:43 -0400
Subject: Re: [PATCH RFC 03/16] btrfs-progs: fsck: Introduce function to query
 tree block level
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-4-git-send-email-quwenruo@cn.fujitsu.com>
 <ed7323de-cc1d-603c-0064-9e016f026f1b@fb.com>
 <e197cac6-fc53-c007-28c0-facfe65e3754@cn.fujitsu.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <0c545634-a7b3-5845-09c0-43bd8280ce07@fb.com>
Date: Fri, 29 Apr 2016 09:51:27 -0400
MIME-Version: 1.0
In-Reply-To: <e197cac6-fc53-c007-28c0-facfe65e3754@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/28/2016 11:35 PM, Qu Wenruo wrote:
>
>
> Josef Bacik wrote on 2016/04/28 10:13 -0400:
>> On 04/25/2016 11:48 PM, Qu Wenruo wrote:
>>> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>>
>>> Introduce function query_tree_block_level() to resolve tree block level
>>> by reading out the tree block.
>>>
>>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>
>> This skips the check_tree_block if the transid passes, but we could have
>> a matching transid but a corrupt item.  You need to fix
>> read_tree_block_fs_info to always call check_block so we can be sure
>> that our btrfs_header_level() is valid here.  Thanks,
>>
>> Josef
>>
>>
> read_tree_block_fs_info(or read_tree_block) will call check_tree_block()
> and verify_parent_transid() if it doesn't find a cached extent buffer.
>
> So I don't think we need to do further modification to
> read_tree_block_fs_info().
>
> But your comment reminds me that, we did miss the generation check, as
> we can get generation from backref, and when we can, we should also
> check transid.
>
> We will add transid check from metadata backref.
>

Sigh I was looking at an older version of btrfs-progs, you are right. 
Thanks,

Josef

