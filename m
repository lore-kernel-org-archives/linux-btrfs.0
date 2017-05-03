Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:34610 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECWSg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 18:18:36 -0400
Received: by mail-yb0-f173.google.com with SMTP id 8so847171ybw.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 15:18:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
References: <CAPktuGs4cJW6YBJ3GuGaXRLkud7VKvdH2P1U0hT+3AtDmHL5Yw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 3 May 2017 16:18:34 -0600
Message-ID: <CAJCQCtRXCWuCbchRxOBZA7Dfzt4vhED77d1boErTdOGAzAi4vw@mail.gmail.com>
Subject: Re: BTRFS converted from EXT4 becomes read-only after reboot
To: Alexandru Guzu <alexguzu@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 3, 2017 at 2:28 PM, Alexandru Guzu <alexguzu@gmail.com> wrote:

> In a VirtualBox VM, I converted a EXT4 fs to BTRFS that is now running
> on Ubuntu 16.04 (Kernel 4.4.0-72). I was able to use the system for
> several weeks. I even did kernel updates, compression, deduplication
> without issues.

Which version of btrfs-progs? The convert code was totally rewritten
for btrfs-progs 4.6, and it has had a number of significant fixes
since then. I'd say 4.8.2 is about the minimum I'd recommend. But if
it were me I'd use the current release, 4.10.2.

But that alone may not fix it, I think you need a newer kernel...

>
> The stack trace is the following:
>
> [   88.836057] ------------[ cut here ]------------
> [   88.836082] WARNING: CPU: 0 PID: 25 at
> /build/linux-wXdoVv/linux-4.4.0/fs/btrfs/inode.c:2931
> btrfs_finish_ordered_io+0x63b/0x650 [btrfs]()
> [   88.836083] BTRFS: Transaction aborted (error -95)

Fits this thread, which suggests you're using a btrfs-progs 4.6 or newer.

The call trace breakdown:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg57565.html

The evaluation:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg57634.html


-- 
Chris Murphy
