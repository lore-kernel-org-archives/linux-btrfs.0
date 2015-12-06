Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:33911 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbbLFKTd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Dec 2015 05:19:33 -0500
Received: by ykfs79 with SMTP id s79so168051231ykf.1
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Dec 2015 02:19:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151203181428.GA19589@localhost.localdomain>
References: <CAOcd+r3DHGSu5017ha+m1E9bv2YD4v-LCMBxYywNA9BaLK-DQg@mail.gmail.com>
	<20151203181428.GA19589@localhost.localdomain>
Date: Sun, 6 Dec 2015 12:19:32 +0200
Message-ID: <CAOcd+r2h4YH5duP85z7riwqe8BePHDhL3j35-natP=uNhhTz7A@mail.gmail.com>
Subject: Re: [RFC PATCH] btrfs: flush_space: treat return value of
 do_chunk_alloc properly
From: Alex Lyakas <alex@zadarastorage.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,
I was studying on how block reservation works, and making some
modifications in reserve_metadata_bytes to understand better what it
does. Then suddenly I saw this problem. I guess it depends on which
value of "flush" parameter is passed to reserve_metadata_bytes.

Alex.


On Thu, Dec 3, 2015 at 8:14 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Thu, Dec 03, 2015 at 06:51:03PM +0200, Alex Lyakas wrote:
>> do_chunk_alloc returns 1 when it succeeds to allocate a new chunk.
>> But flush_space will not convert this to 0, and will also return 1.
>> As a result, reserve_metadata_bytes will think that flush_space failed,
>> and may potentially return this value "1" to the caller (depends how
>> reserve_metadata_bytes was called). The caller will also treat this as an error.
>> For example, btrfs_block_rsv_refill does:
>>
>> int ret = -ENOSPC;
>> ...
>> ret = reserve_metadata_bytes(root, block_rsv, num_bytes, flush);
>> if (!ret) {
>>         block_rsv_add_bytes(block_rsv, num_bytes, 0);
>>         return 0;
>> }
>>
>> return ret;
>>
>> So it will return -ENOSPC.
>
> It will return 1 instead of -ENOSPC.
>
> The patch looks good, I noticed this before, but I didn't manage to trigger a error for this, did you catch a error like that?
>
> Thanks,
>
> -liubo
>
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 4b89680..1ba3f0d 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -4727,7 +4727,7 @@ static int flush_space(struct btrfs_root *root,
>>                                      btrfs_get_alloc_profile(root, 0),
>>                                      CHUNK_ALLOC_NO_FORCE);
>>                 btrfs_end_transaction(trans, root);
>> -               if (ret == -ENOSPC)
>> +               if (ret > 0 || ret == -ENOSPC)
>>                         ret = 0;
>>                 break;
>>         case COMMIT_TRANS:
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
