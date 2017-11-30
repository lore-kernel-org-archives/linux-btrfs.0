Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34667 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdK3GmK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Nov 2017 01:42:10 -0500
Received: by mail-vk0-f53.google.com with SMTP id j126so2804702vke.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Nov 2017 22:42:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQm8yMh=__pyZWarvzD7RnPh6HPQS3xsSCmiNjYVZdg8Q@mail.gmail.com>
References: <CAFTHvW9OmWApkzJ=s51Saq=cwv24hBqe0bzhR55Yv2+fAANH-Q@mail.gmail.com>
 <CAFTHvW-WJgzC6theZ3Hrrc5Xf4eXFNQ8c=5Y+KmciAvK7bSexA@mail.gmail.com>
 <CAJCQCtQGzrXbsVy6GJHwO0MSL7xxix9fVL6UKAsqd+7hHcrx4Q@mail.gmail.com>
 <CAFTHvW_UHvPtKYvrWRqHqW3O8R4pEZeQBd5nTv=5+KqRK0RfPg@mail.gmail.com> <CAJCQCtQm8yMh=__pyZWarvzD7RnPh6HPQS3xsSCmiNjYVZdg8Q@mail.gmail.com>
From: Klaus Agnoletti <klaus@agnoletti.dk>
Date: Thu, 30 Nov 2017 07:41:48 +0100
Message-ID: <CAFTHvW9Zyr0+EDy6MM3tg9rd8SM1dZm0T3qY+ztdu5bP2Y2zKA@mail.gmail.com>
Subject: Re: A partially failing disk in raid0 needs replacement
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris
>
> I don't see how you get an IO error in user space without the kernel
> reporting the source of that IO error, whatever it is.
>
I totally agree, so I just retried the deletion. The only thing
related I could see in /var/log/messages is this:
Nov 30 07:29:57 box kernel: [368193.019160] BTRFS info (device sdb):
found 207 extents

Shortly after this, btrfs gives me the I/O error. I am guessing that
the kernel with log to this file, and it did before I changed the disk
- but not anymore, it seems.

> If Btrfs detects corruption of data extents, it will tell you the
> exact path to file names affected, as kernel messages. If you aren't
> getting that, then it's some other problem.

So it smells like some other problem, I guess. I have no idea what, so
my best plan is to move forward on my plans to backup date, rebuild fs
and restore everything.. Does anyone have any better suggestion? :)

Thanks again for everything,

/klaus
