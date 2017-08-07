Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33056 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752239AbdHGHi2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 03:38:28 -0400
Received: by mail-oi0-f65.google.com with SMTP id e124so6897675oig.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Aug 2017 00:38:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT0TLV3zJN2JgC+Z-QeanP299MxTo_qfH0j9O5qYanVRQ@mail.gmail.com>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
 <CAJCQCtT0TLV3zJN2JgC+Z-QeanP299MxTo_qfH0j9O5qYanVRQ@mail.gmail.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Mon, 7 Aug 2017 13:08:27 +0530
Message-ID: <CANT5p=oinw-FngKgbKLLPuPF8oX_C+EVKM0SMivgq7Pb2a+70Q@mail.gmail.com>
Subject: Re: Power down tests...
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,
Good points that you make.

We're making use of btrfs raid only. (One of the reasons we want to
move to btrfs)
However, during this test, we haven't run with multi-disk btrfs raid.
We just have one disk. (This test setup doesn't have too many disks)

We do have our metadata replicated as well. For data, we do have
regular async backups.
However, this is something that we noticed (somewhat more frequently)
while testing out btrfs as our data store (as compared to ext4).
We've tests going on with flushoncommit and recovery mount options
running on the same setup. Hopefully, we'll have near-ext4-like
behaviour with this, w.r.t power off recovery.

Regards,
Shyam

On Mon, Aug 7, 2017 at 7:52 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Aug 3, 2017 at 11:51 PM, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>> Hi all,
>>
>> We're running a couple of experiments on our servers with btrfs
>> (kernel version 4.4).
>> And we're running some abrupt power-off tests for a couple of scenarios:
>>
>> 1. We have a filesystem on top of two different btrfs filesystems
>> (distributed across N disks).
>
> What's the layout from physical devices all the way to your 16M file?
> This is hardware raid, lvm linear, Btrfs raid? All of that matters.
>
> Do the drives have write caching disabled? You might be better off
> with the drive write cache disabled, and then add bcache or dm-cache
> and an SSD to compensate. But that's just speculation on my part. The
> write cache in the drives is definitely volatile. And disabling them
> will definitely make writes slower. So, you might have slightly better
> luck with another layout.
>
> But the bottom line is, you need to figure out a way to avoid *any*
> data loss in your files because otherwise that means the 2nd file
> system has data loss and even corruption. This is not something a file
> system choice can solve. You need reliable power and reliable
> shutdown. And you may also need a cluster file system like ceph or
> glusterfs instead of depending on a single box to stay upright.
>
>
>
> --
> Chris Murphy



-- 
-Shyam
