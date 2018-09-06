Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf1-f41.google.com ([209.85.167.41]:44202 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730122AbeIFUYo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 16:24:44 -0400
Received: by mail-lf1-f41.google.com with SMTP id g6-v6so9459740lfb.11
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 08:48:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
References: <e1371e79-f5d1-494b-a6ea-3d8d888bf1d3@gmail.com> <CAHTTHimFRYwZ9iiacP7vFVhCtTmcUVaik5fFEM0k0tG-Hvnmhw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 6 Sep 2018 09:48:35 -0600
Message-ID: <CAJCQCtQHmk3ViUkynDhsb6_jCjpRHY6dSdZGiDZzg3k=XW9+-A@mail.gmail.com>
Subject: Re: btrfs send hung in pipe_wait
To: Stefan Loewen <stefan.loewen@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 6, 2018 at 9:04 AM, Stefan Loewen <stefan.loewen@gmail.com> wrote:
> Update:
> It seems like btrfs-send is not completely hung. It somewhat regularly
> wakes up every hour to transfer a few bytes. I noticed this via a
> periodic 'ls -l' on the snapshot file. These are the last outputs
> (uniq'ed):
>
> -rw------- 1 root root 1492797759 Sep  6 08:44 intenso_white.snapshot
> -rw------- 1 root root 1493087856 Sep  6 09:44 intenso_white.snapshot
> -rw------- 1 root root 1773825308 Sep  6 10:44 intenso_white.snapshot
> -rw------- 1 root root 1773976853 Sep  6 11:58 intenso_white.snapshot
> -rw------- 1 root root 1774122301 Sep  6 12:59 intenso_white.snapshot
> -rw------- 1 root root 1774274264 Sep  6 13:58 intenso_white.snapshot
> -rw------- 1 root root 1774435235 Sep  6 14:57 intenso_white.snapshot
>
> I also monitor the /proc/3022/task/*/stack files with 'tail -f' (I
> have no idea if this is useful) but there are no changes, even during
> the short wakeups.

I have a sort of "me too" here. I definitely see btrfs send just hang
for no apparent reason, but in my case it's for maybe 15-30 seconds.
Not an hour. Looking at top and iotop at the same time as the LED
lights on the drives, there's  definitely zero activity happening. I
can make things happen during this time - like I can read a file or
save a file from/to any location including the send source or receive
destination. It really just behaves as if the send thread is saying
"OK I'm gonna nap now, back in a bit" and then it is.

So what I end up with on drives with a minimum read-write of 80M/s, is
a send receive that's getting me a net of about 30M/s.

I have around 100 snapshots on the source device. How many total
snapshots do you have on your source? That does appear to affect
performance for some things, including send/receive.


-- 
Chris Murphy
