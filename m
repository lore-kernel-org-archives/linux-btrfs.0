Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49294 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752225AbcD2DfQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 23:35:16 -0400
Subject: Re: [PATCH RFC 03/16] btrfs-progs: fsck: Introduce function to query
 tree block level
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-4-git-send-email-quwenruo@cn.fujitsu.com>
 <ed7323de-cc1d-603c-0064-9e016f026f1b@fb.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <e197cac6-fc53-c007-28c0-facfe65e3754@cn.fujitsu.com>
Date: Fri, 29 Apr 2016 11:35:09 +0800
MIME-Version: 1.0
In-Reply-To: <ed7323de-cc1d-603c-0064-9e016f026f1b@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Josef Bacik wrote on 2016/04/28 10:13 -0400:
> On 04/25/2016 11:48 PM, Qu Wenruo wrote:
>> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>>
>> Introduce function query_tree_block_level() to resolve tree block level
>> by reading out the tree block.
>>
>> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>
> This skips the check_tree_block if the transid passes, but we could have
> a matching transid but a corrupt item.  You need to fix
> read_tree_block_fs_info to always call check_block so we can be sure
> that our btrfs_header_level() is valid here.  Thanks,
>
> Josef
>
>
read_tree_block_fs_info(or read_tree_block) will call check_tree_block() 
and verify_parent_transid() if it doesn't find a cached extent buffer.

So I don't think we need to do further modification to 
read_tree_block_fs_info().

But your comment reminds me that, we did miss the generation check, as 
we can get generation from backref, and when we can, we should also 
check transid.

We will add transid check from metadata backref.

Thanks,
Qu


