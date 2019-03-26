Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B432C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 01:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAFE0206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 01:59:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="uUzAUK2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbfCZB7i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 21:59:38 -0400
Received: from mail.synology.com ([211.23.38.101]:46777 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727043AbfCZB7i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 21:59:38 -0400
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id 93B65157C61CE;
        Tue, 26 Mar 2019 09:59:34 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553565574; bh=oTZxwGI6cbFeHhUtx06lEbbWn8G/dWzkR5K/uLGhZAs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=uUzAUK2iWzHAF6C2ekWLM/QawV8ewQGrIokyP563jkdhzBCcagXjKqeyetvk/nhv3
         ubBaD1On84Dz0qHoRHKews9rVjXzVQZ/WFdkuLWUA/2XdMMY3rb1iYvX1oCzS4Ss1N
         O98ZeNOMvkUMbqSvnZq6cWIBtdGW91QWEH2JFqYk=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 26 Mar 2019 09:59:34 +0800
From:   robbieko <robbieko@synology.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] Btrfs: improve unnecessary free space inode update when
 space_cache=v1 has never been used
In-Reply-To: <491a5d33-73c4-fe29-174d-ef2bc38e4ad5@suse.com>
References: <1553504798-8116-1-git-send-email-robbieko@synology.com>
 <fadd1246-15db-8d1d-6f53-d1ce842c46ad@suse.com>
 <457ee831ab77d303770a81bd7b2fd3c3@synology.com>
 <491a5d33-73c4-fe29-174d-ef2bc38e4ad5@suse.com>
Message-ID: <cee3c60c5f1a2458ccad66f58780d4e1@synology.com>
X-Sender: robbieko@synology.com
User-Agent: Roundcube Webmail/1.1.2
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Nikolay Borisov 於 2019-03-25 19:18 寫到:
> On 25.03.19 г. 11:52 ч., robbieko wrote:
>> Nikolay Borisov 於 2019-03-25 17:35 寫到:
>>> On 25.03.19 г. 11:06 ч., robbieko wrote:
>>>> From: Robbie Ko <robbieko@synology.com>
>>>> 
>>>> When we have never used space_cache=v1, we don't need to update
>>>> the free space inode, and try to free up the space occupied by the
>>>> free space inode.
>>>> 
>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>> ---
>>>>  fs/btrfs/extent-tree.c | 7 +++++++
>>>>  1 file changed, 7 insertions(+)
>>>> 
>>>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>>>> index 1d49694..d3bba07 100644
>>>> --- a/fs/btrfs/extent-tree.c
>>>> +++ b/fs/btrfs/extent-tree.c
>>>> @@ -3403,6 +3403,13 @@ static int cache_save_setup(struct
>>>> btrfs_block_group_cache *block_group,
>>>> 
>>>>      if (trans->aborted)
>>>>          return 0;
>>>> +
>>>> +    if (btrfs_super_cache_generation(fs_info->super_copy) == 
>>>> (u64)-1 &&
>>>> +        !btrfs_test_opt(fs_info, SPACE_CACHE)) {
>>>> +        dcs = BTRFS_DC_WRITTEN;
>>>> +        goto out;
>>>> +    }
>>>> +
>>> 
>>> Looking at the code it seems this function can only be called from
>>> btrfs_write_dirty_block_groups, since its other caller
>>> btrfs_setup_space_cache already checks if SPACE_CACHE option is used.
>>> 
>>> IMO this patch is fine if we aren't using v1 space cache no point in
>>> executing that function however.
>>> 
>>> However, why is it necessary to do the cache_generation check, isn't 
>>> it
>>> sufficient to predicate the execution only on SPACE_CACHE mount 
>>> option?
>>> 
>> 
>> When superblock cache_generation != -1,
>> it means that space_cache=v1 has been used.
>> 
>> If we have used space_cache=v1 before,
>> we will generate a free space cache inode,
>> which will take up space, so we must free up
>> the space occupied by the free space inode.
> 
> But if we have used space_cache=v1 before and now using it in the
> current mount then should we even care about the freespace inode? I
> think the answer is "no". Furthermore I don't see how freeing the space
> cache has anything to do with the code you are modifying. Can you 
> elaborate?
> 

Before my patch, whether it is space_cache v1/v2 or nospace_cache,
when updating the block group, it will check whether the existing
free space inode has space and release the space in cache_save_setup.

But my patch will skip lookup_free space_inode, create_free_space inode,
and truncate_free_space_cache, so I have to make sure that no
free space_cache=v1 has been used, otherwise the free space inode
space will not be freed.

>> 
>> Thanks.
>> 
>>>>  again:
>>>>      inode = lookup_free_space_inode(fs_info, block_group, path);
>>>>      if (IS_ERR(inode) && PTR_ERR(inode) != -ENOENT) {
>>>> 
>> 
>> 

