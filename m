Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:59793 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaHJXor (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 19:44:47 -0400
Received: by mail-la0-f45.google.com with SMTP id ty20so6193639lab.32
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 16:44:46 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com>
References: <2BBB0EBF-DD55-45B4-8BF5-F8DAA9398A4F@colorremedies.com>
	<CF539008-5930-447D-B26C-2A2BBE9337EA@colorremedies.com>
Date: Mon, 11 Aug 2014 00:44:45 +0100
Message-ID: <CAL3q7H591BbVenxFn_EiBDyqmJEcwgOKjw0Xv2J+jkgic+3dxQ@mail.gmail.com>
Subject: Re: [BUG] btrfs send/receive, page allocation failure
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 10, 2014 at 10:01 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Aug 7, 2014, at 9:31 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
>> # btrfs send /mnt/320G/2012april_HDD_fullbackup.ro.0/ | btrfs receive /mnt/500G/
>> At subvol /mnt/320G/2012april_HDD_fullbackup.ro.0/
>> At subvol 2012april_HDD_fullbackup.ro.0
>> ERROR: send ioctl failed with -12: Cannot allocate memory
>> ERROR: unexpected EOF in stream.
>>
>>
>> kernel-3.16.0-1.fc21.x86_64
>> btrfs-progs-3.14.2-3.fc21.x86_64
>>
>>
>> Both the source and destination were recently (< 24 hours) created with the above versions.
>>
>> Bug report here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=81781
>>
>> dmesg excerpt with debug kernel here:
>> https://bugzilla.kernel.org/attachment.cgi?id=145331
>
> This isn't reproducible by only changing kernels to 3.14.15-100.fc19.x86_64, so it's a regression in 3.16.

Hi Chris,

Can you try the following patch and confirm if it helps?
https://patchwork.kernel.org/patch/4705171/

> What's also interesting is the performance is much worse with 3.14 compared to 3.16. I get ~8.3MB/s with 3.14, and ~21.8MB/s with 3.16; all other factors are identical.

Yes, not surprising however because 3.15/16 brought in some
optimizations such as using readahead when reading file data for
example.

Thanks

>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
