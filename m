Return-Path: <SRS0=qcGt=SA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D889C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 08:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F1932173C
	for <linux-btrfs@archiver.kernel.org>; Fri, 29 Mar 2019 08:27:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="oAldL8t3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfC2I1A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 29 Mar 2019 04:27:00 -0400
Received: from mail.synology.com ([211.23.38.101]:33078 "EHLO synology.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728972AbfC2I1A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Mar 2019 04:27:00 -0400
Received: from _ (localhost [127.0.0.1])
        by synology.com (Postfix) with ESMTPA id 661141A470331;
        Fri, 29 Mar 2019 16:26:51 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1553848011; bh=fsnIn1rFeuC/H0YtJtGzKs69D2Hvqn+4oVNNpVV0W6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=oAldL8t3tCbu4EscX1tUuvshDHPs60h/b1glcZPqjZv3m9jy2ql75yJdaMvd+tzr9
         MarKEAzE0I4ADsSsAT30CFS4yrKBsd+gJ8XbyqkqXuLcq7Cr0/KkGD5xo+VvqLgb1g
         Him+OwJE6Dq5wJu+YFajtyaPbPkEOWYV2eTea4t0=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 29 Mar 2019 16:26:51 +0800
From:   robbieko <robbieko@synology.com>
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] Btrfs: send, improve clone range
In-Reply-To: <CAL3q7H7SOQt-9BVU+0YxoHXNkb7qiY4tN13gogayEH_8GNSK5A@mail.gmail.com>
References: <1553766036-20689-1-git-send-email-robbieko@synology.com>
 <CAL3q7H7SOQt-9BVU+0YxoHXNkb7qiY4tN13gogayEH_8GNSK5A@mail.gmail.com>
Message-ID: <5d62997fe230f3f9c849d660a3ce16b2@synology.com>
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

Filipe Manana 於 2019-03-29 06:52 寫到:
> On Thu, Mar 28, 2019 at 9:41 AM robbieko <robbieko@synology.com> wrote:
>> 
>> From: Robbie Ko <robbieko@synology.com>
>> 
>> Improve clone_range two use scenarios.
>> 
>> 1. Remove the limit of clone inode size
>> We can do partial clone range, so there is no need to limit
>> the inode size.
> 
> There is.
> Cloning from a source range that goes beyond the source's i_size
> results in an -EINVAL error returned from the clone ioctl.
> 
> Try running fstests btrfs/007, with a seed value of 1553175244 and
> 2000 operations instead of 200:
> 
> # /home/fdmanana/git/hub/btrfs-progs/btrfs receive
> /home/fdmanana/btrfs-tests/scratch_1
> ERROR: failed to clone extents to p0/df/d10/f2c: Invalid argument
> At snapshot incr
> failed: '/home/fdmanana/git/hub/btrfs-progs/btrfs receive
> /home/fdmanana/btrfs-tests/scratch_1'
> 

This is my fault, fallocate keeps size, which can result in file extent 
range > inode size.
So we still need to check if the file range offset + len is greater than 
the inode size when cloning

Thanks.
I will fix and send Patch v2.

> 
>> 
>> 2. In the scenarios of rewrite or clone_range, data_offset
>> rarely matches exactly, so the chance of a clone is missed.
>> 
>> e.g.
>>     1. Write a 1M file
>>         dd if=/dev/zero of=1M bs=1M count=1
>> 
>>     2. Clone 1M file
>>        cp --reflink 1M clone
>> 
>>     3. Rewrite 4k on the clone file
>>        dd if=/dev/zero of=clone bs=4k count=1 conv=notrunc
>> 
>>     The disk layout is as follows:
>>     item 16 key (257 EXTENT_DATA 0) itemoff 15353 itemsize 53
>>         extent data disk byte 1103101952 nr 1048576
>>         extent data offset 0 nr 1048576 ram 1048576
>>         extent compression(none)
>>     ...
>>     item 22 key (258 EXTENT_DATA 0) itemoff 14959 itemsize 53
>>         extent data disk byte 1104150528 nr 4096
>>         extent data offset 0 nr 4096 ram 4096
>>         extent compression(none)
>>     item 23 key (258 EXTENT_DATA 4096) itemoff 14906 itemsize 53
>>         extent data disk byte 1103101952 nr 1048576
>>         extent data offset 4096 nr 1044480 ram 1048576
>>         extent compression(none)
>> 
>> When send, inode 258 file offset 4096~1048576 (item 23) has a
>> chance to clone_range, but because data_offset does not match
>> inode 257 (item 16), it causes missed clone and can only transfer
>> actual data.
>> 
>> Improve the problem by judging whether the current data_offset
>> has overlap with the file extent item, and if so, adjusting
>> offset and extent_len so that we can clone correctly.
>> 
>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>> ---
>>  fs/btrfs/send.c | 20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>> index 7ea2d6b..7766b12 100644
>> --- a/fs/btrfs/send.c
>> +++ b/fs/btrfs/send.c
>> @@ -1240,9 +1240,6 @@ static int __iterate_backrefs(u64 ino, u64 
>> offset, u64 root, void *ctx_)
>>         if (ret < 0)
>>                 return ret;
>> 
>> -       if (offset + bctx->data_offset + bctx->extent_len > i_size)
>> -               return 0;
> 
> And this is why the failure above happens.
> 
>> -
>>         /*
>>          * Make sure we don't consider clones from send_root that are
>>          * behind the current inode/offset.
>> @@ -5148,6 +5145,7 @@ static int clone_range(struct send_ctx *sctx,
>>                 u8 type;
>>                 u64 ext_len;
>>                 u64 clone_len;
>> +               u64 clone_data_offset;
> 
>   CC [M]  fs/btrfs/send.o
> fs/btrfs/send.c: In function 'process_extent':
> fs/btrfs/send.c:5218:60: warning: 'clone_data_offset' may be used
> uninitialized in this function [-Wmaybe-uninitialized]
>    if (btrfs_file_extent_disk_bytenr(leaf, ei) == disk_byte &&
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~
>        clone_data_offset == data_offset)
>        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> fs/btrfs/send.c:5148:7: note: 'clone_data_offset' was declared here
>    u64 clone_data_offset;
>        ^~~~~~~~~~~~~~~~~
>   LD [M]  fs/btrfs/btrfs.o
> 

I will fix it in v2 version together.


> $ gcc --version
> gcc --version
> gcc (Debian 6.3.0-18+deb9u1) 6.3.0 20170516
> Copyright (C) 2016 Free Software Foundation, Inc.
> 
> Harmless but we shouldn't have warnings, initialize it to something
> impossible (u64(-1) / U64_MAX) or re-structure the change below.
> 
>> 
>>                 if (slot >= btrfs_header_nritems(leaf)) {
>>                         ret = btrfs_next_leaf(clone_root->root, path);
>> @@ -5201,10 +5199,24 @@ static int clone_range(struct send_ctx *sctx,
>>                 if (key.offset >= clone_root->offset + len)
>>                         break;
>> 
>> +               if (btrfs_file_extent_disk_bytenr(leaf, ei) == 
>> disk_byte) {
>> +                       clone_root->offset = key.offset;
>> +                       clone_data_offset = 
>> btrfs_file_extent_offset(leaf, ei);
>> +                       if (clone_data_offset < data_offset &&
>> +                               clone_data_offset + ext_len > 
>> data_offset) {
>> +                               u64 extent_offset;
>> +
>> +                               extent_offset = data_offset - 
>> clone_data_offset;
>> +                               ext_len -= extent_offset;
>> +                               clone_data_offset += extent_offset;
>> +                               clone_root->offset += extent_offset;
>> +                       }
>> +               }
>> +
>>                 clone_len = min_t(u64, ext_len, len);
>> 
>>                 if (btrfs_file_extent_disk_bytenr(leaf, ei) == 
>> disk_byte &&
>> -                   btrfs_file_extent_offset(leaf, ei) == data_offset)
>> +                   clone_data_offset == data_offset)
>>                         ret = send_clone(sctx, offset, clone_len, 
>> clone_root);
>>                 else
>>                         ret = send_extent_data(sctx, offset, 
>> clone_len);
>> --
>> 1.9.1
>> 

