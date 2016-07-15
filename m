Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35552 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbcGOQel (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 12:34:41 -0400
Received: by mail-lf0-f67.google.com with SMTP id l89so7326268lfi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 09:34:41 -0700 (PDT)
Subject: Re: [BUG] Btrfs scrub sometime recalculate wrong parity in raid5:
 take two
To: Chris Mason <clm@fb.com>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <da6e9c30-02a0-39fc-3c67-d0af4fd5bf51@inwind.it>
 <a0538df6-7e25-fae8-8ebd-b18120a1c516@fb.com>
 <46299275-04a2-d9f9-c47b-7917b04c9484@inwind.it>
 <4bdb4c42-ed13-3add-1da7-46a1acd8390e@fb.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5789109E.7090301@gmail.com>
Date: Fri, 15 Jul 2016 19:34:38 +0300
MIME-Version: 1.0
In-Reply-To: <4bdb4c42-ed13-3add-1da7-46a1acd8390e@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

15.07.2016 19:29, Chris Mason пишет:
>
>> However I have to point out that this kind of test is very
>> difficult to do: the file-cache could lead to read an old data, so please
>> suggestion about how flush the cache are good (I do some sync,
>> unmount the filesystem and perform "echo 3 >/proc/sys/vm/drop_caches",
>> but sometime it seems not enough).
> 
> O_DIRECT should handle the cache flushing for you.
> 

There is also BLKFLSBUF ioctl (blockdev --flushbufs on shell level).
