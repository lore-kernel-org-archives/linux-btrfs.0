Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34977 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751837AbdHGCXA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Aug 2017 22:23:00 -0400
Received: by mail-wm0-f67.google.com with SMTP id r77so12183852wmd.2
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Aug 2017 19:23:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
References: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 6 Aug 2017 20:22:59 -0600
Message-ID: <CAJCQCtT0TLV3zJN2JgC+Z-QeanP299MxTo_qfH0j9O5qYanVRQ@mail.gmail.com>
Subject: Re: Power down tests...
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 3, 2017 at 11:51 PM, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> Hi all,
>
> We're running a couple of experiments on our servers with btrfs
> (kernel version 4.4).
> And we're running some abrupt power-off tests for a couple of scenarios:
>
> 1. We have a filesystem on top of two different btrfs filesystems
> (distributed across N disks).

What's the layout from physical devices all the way to your 16M file?
This is hardware raid, lvm linear, Btrfs raid? All of that matters.

Do the drives have write caching disabled? You might be better off
with the drive write cache disabled, and then add bcache or dm-cache
and an SSD to compensate. But that's just speculation on my part. The
write cache in the drives is definitely volatile. And disabling them
will definitely make writes slower. So, you might have slightly better
luck with another layout.

But the bottom line is, you need to figure out a way to avoid *any*
data loss in your files because otherwise that means the 2nd file
system has data loss and even corruption. This is not something a file
system choice can solve. You need reliable power and reliable
shutdown. And you may also need a cluster file system like ceph or
glusterfs instead of depending on a single box to stay upright.



-- 
Chris Murphy
