Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:35745 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdLSTfV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 14:35:21 -0500
Received: by mail-ot0-f176.google.com with SMTP id q3so17711350oth.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Dec 2017 11:35:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171219144644.GA9855@polanet.pl>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk> <91965e24-3b94-7334-c249-d8de5f585f29@gmail.com>
 <20171218194351.GA25245@polanet.pl> <7ff86029-5b0f-1d02-778a-af78c6f3e461@gmail.com>
 <20171219144644.GA9855@polanet.pl>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 19 Dec 2017 12:35:20 -0700
Message-ID: <CAJCQCtSwfoSmAfFyP15xp-uysBY1kWyt65Jhf37g68YcPQ2QEA@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Tomasz Pala <gotar@polanet.pl>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 19, 2017 at 7:46 AM, Tomasz Pala <gotar@polanet.pl> wrote:

>Secondly - permanent failures are not handled "just
> fine", as there is (1) no automatic mount as degraded, so the machine
> won't reboot properly and (2) the r/w degraded mount is[*] one-timer.
> Again, this should be:

One of the reasons for problem 1 is problem 2. If we had automatic
degraded mount, people would run into problem 2 and now they're stuck
with a read only file system. Another reason is the kernel code and
udev rule for device "readiness" means the volume is not "ready" until
all member devices are present. And while the volume is not "ready"
systemd will not even attempt to mount. Solving this requires kernel
and udev work, or possibly a helper, to wait an appropriate amount of
time. I also think it's a bad idea to implement automatic degraded
mounts unless there's an API for user space to receive either a push
or request notification for degradedness state, so desktop
environments can inform the user of degradedness.

There is no amount of documentation that makes up for these
deficiencies enough to enable automatic degraded mounts by default. I
would consider it a high order betrayal of user trust to do it.



-- 
Chris Murphy
