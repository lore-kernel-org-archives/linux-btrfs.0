Return-Path: <SRS0=MIpn=R5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998B6C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 03:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EB0620811
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Mar 2019 03:50:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="Qdwadqjb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbfCZDu0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 23:50:26 -0400
Received: from mail.synology.com ([211.23.38.101]:41387 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727506AbfCZDuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 23:50:25 -0400
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id AB894FCA7160;
        Tue, 26 Mar 2019 11:50:23 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553572223; bh=Z3kicC70BbjQFYHIZkwyiI1tN9ZbWcxrkPtJhyoZp+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=QdwadqjblbZcyOutrHV8skhaA8FJo4S5NCtov/dtw7tymGRUuOx3whH0kwWwRDAci
         6iHkDQ7Ti7hfuv6vDg21GdMn6MsAKN39nwucfK3ngfkf89J+3ey39Bz/31aCFTa/+J
         kqUJgkxM4ewt7/ArV4vpQuWK7FS1Sa3MCJxXjq4g=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 26 Mar 2019 11:50:23 +0800
From:   robbieko <robbieko@synology.com>
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix data bytes_may_use underflow with fallocate
 due to failed quota reserve
In-Reply-To: <CAL3q7H7ootLePYme21_yg4bGUVZ+_LgK8-UyRNUWkb05Y=KT+g@mail.gmail.com>
References: <1547435747-20013-1-git-send-email-robbieko@synology.com>
 <CAL3q7H7ootLePYme21_yg4bGUVZ+_LgK8-UyRNUWkb05Y=KT+g@mail.gmail.com>
Message-ID: <4e0220f46300e60f89c3da34145d0bfb@synology.com>
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

Filipe Manana 於 2019-03-25 19:14 寫到:
> On Mon, Jan 14, 2019 at 3:26 AM robbieko <robbieko@synology.com> wrote:
>> 
>> From: Robbie Ko <robbieko@synology.com>
>> 
>> When doing fallocate, we first add the range to the reserve_list
>> and then reserve the qutoa.
> 
> qutoa -> quota
> 
>> If quota reservation fails, we'll release all reserved parts of
>> reserve_list.
>> However, cur_offset doen't update to indicate that this range is
> 
> "doen't update" -> is not updated to indicate ...
> 
>> already been inserted into the list.
>> Therefore, the same range is freed twice.
>> One at list_for_each_entry loop, and the other at the end of the
> 
> One -> once
> and the other at -> and once at
> 
>> function.
>> This will result in WARN_ON on bytes_may_use when we free the
>> remaining space.
>> 
>> Fixes: ("btrfs: update btrfs_space_info's bytes_may_use timely")
> 
> Missing commit id.
> 
>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>> ---
>>  fs/btrfs/file.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index d38dc8c..43c6c8a 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -3132,6 +3132,7 @@ static long btrfs_fallocate(struct file *file, 
>> int mode,
>>                         ret = btrfs_qgroup_reserve_data(inode, 
>> &data_reserved,
>>                                         cur_offset, last_byte - 
>> cur_offset);
>>                         if (ret < 0) {
>> +                               cur_offset = last_byte;
> 
> This will fix the problem if there's only one range, or we happen to
> be very lucky and cur_offset
> matches exactly the middle of the entire range passed to fallocate()
> (in case the range covers
> a sparse region of the file, a region with holes and extents).
> 
> At the end, under the 'out' label we have a call to:
> 
>    btrfs_free_reserved_data_space(inode, data_reserved, alloc_start,
> alloc_end - cur_offset);
> 
> That doesn't fell right - the start offset, third argument, should be
> cur_offset. Everything from
> alloc_start to cur_offset was freed by the 
> list_for_each_entry_safe_loop.

Ok, I will send patch v2.
Thank you.
> 
> 
> 
> 
> 
>>                                 free_extent_map(em);
>>                                 break;
>>                         }
>> --
>> 1.9.1
>> 

