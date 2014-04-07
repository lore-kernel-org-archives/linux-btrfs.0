Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51494 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaDGQBl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 12:01:41 -0400
Received: by mail-oa0-f43.google.com with SMTP id eb12so6823086oac.2
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 09:01:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcaxmWEDa+jS8n4LZKdE_ZXFVAoOgACDseQs0_fViYdfRHShg@mail.gmail.com>
References: <CAAcaxmWqrLUwbvmsyE+3zLLP1jSVZXGASRvN-D-BLaJp4WnpLQ@mail.gmail.com>
	<5342C944.2020000@fb.com>
	<CAAcaxmWEDa+jS8n4LZKdE_ZXFVAoOgACDseQs0_fViYdfRHShg@mail.gmail.com>
Date: Tue, 8 Apr 2014 00:01:40 +0800
Message-ID: <CAAcaxmURiYRV7Rszb9UQuxSCgR+ZRTu2f+CxVhS4x7qHU2wb4A@mail.gmail.com>
Subject: Fwd: Is this a race bug when releasing eb?
From: ylet ylet <levin.front@gmail.com>
To: jbacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi Josef

Thanks, I got it. But i still have no idea to reliably reproduce it.
This bug-on is triggered when I ran POSTMARK test lasting two days.

BTW, can you reproduce the bug reported by email with title of "btrfs
hung with iozone test under linux kernel 3.14." The reported bug can
be reliably reproduced in my environment.

2014-04-07 23:50 GMT+08:00 Josef Bacik <jbacik@fb.com>:
> On 04/07/2014 11:45 AM, ylet ylet wrote:
>>
>> Assuming thread 1 (may be VFS want to release the page) wants to
>> release a CLEAN page and thus the eb attaching the page.
>> and thread 2 wants to access the eb and cow the eb.
>>
>> Thread 1
>>                 Thread 2
>>
>> btree_releasepage
>>
>> try_release_extent_buffer
>>
>> release_extent_buffer
>> ->if (atomic_dec_and_test(&eb->refs)) {
>> ->spin_unlock(&eb->refs_lock);
>>   -------switch to thread 2 here------
>>
>>                 read_block_for_search
>>
>>                  btrfs_find_tree_block
>>
>>       radix_tree_lookup && atomic_inc_not_zero
>>
>
> atomic_inc_not_zero would return 0 here because we've dropped the last
> buffer for this, that is how we protect against this problem.  How reliably
> are you able to reproduce this bug?  Cause I'd love to find it if you can
> reproduce reliably.  Thanks,
>
> Josef
