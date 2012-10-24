Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:37536 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab2JXJoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 05:44:23 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so177823lag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 02:44:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50873AE3.4020700@gmail.com>
References: <507E57F6.6000805@gmail.com>
	<CAOcd+r1aPGGh4zHYzeMMuE01j4Nr+aiMmHBCAWqqCXvZZTb2XQ@mail.gmail.com>
	<50873AE3.4020700@gmail.com>
Date: Wed, 24 Oct 2012 11:44:22 +0200
Message-ID: <CAOcd+r3wVZc+doKBzF4E=K+xC7FTP44da6==iEaqB=2jNNkWYg@mail.gmail.com>
Subject: Re: Questions about mkfs -A option
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Wang,
if you just look at the code in find_free_dev_extent():
u64 search_start = 0;
...
search_start = max((u64)1024 * 1024, search_start);
if (root->fs_info->alloc_start + num_bytes <= device->total_bytes)
	search_start = max(root->fs_info->alloc_start, search_start);
...
key.objectid = device->devid;
key.offset = search_start;
key.type = BTRFS_DEV_EXTENT_KEY;

You see that it will search for DEV_EXTENTs (when allocating chunks)
that begin after the value you specified. So it will not use some
space at the beginning of the device for allocations. Same behavior in
the kernel can be caused by using "alloc_start=X" mount option.
What is the purpose of this I don't know, but what it does looks pretty clear.
The (first copy of the) superblock, though, is always written to
BTRFS_SUPER_INFO_OFFSET, as you mentioned.

Alex.




On Wed, Oct 24, 2012 at 2:48 AM, Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> On 2012年10月23日 01:49, Alex Lyakas wrote:
>
>> Wang,
>> I would say that zeroing is done to prevent from seeing some other superblock (besides btrfs) there.
>
>
> That make sense.
>
>>
>> Alex.
>>
>>
>
>
> But I still confused by the -A option?
>
> In mkfs, we always write the sb info into BTRFS_SUPER_INFO_OFFSET.
> From the -A comment, I think btrfs would be places after the -A value.
> What would happen if we specify a -A value larger than it?
>
>
> Thanks,
> Sheng-Hui
