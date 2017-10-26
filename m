Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:54069 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932331AbdJZSEZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:04:25 -0400
Received: by mail-io0-f181.google.com with SMTP id 189so7285103iow.10
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 11:04:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171026224148.57e4d035@natsu>
References: <CAHpsFVc8a-2ARN+ESza8e1MYhDk5okww9b0K2DAy9QXeiPQsBw@mail.gmail.com>
 <20171026224148.57e4d035@natsu>
From: Cheyenne Wills <cheyenne.wills@gmail.com>
Date: Thu, 26 Oct 2017 12:04:24 -0600
Message-ID: <CAHpsFVdZkTi7CpDSTnWGM5pex648==9MQ=2HpT-HCZD2a_he7w@mail.gmail.com>
Subject: Re: Need some assistance/direction in determining a system hang
 during heavy IO
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 26, 2017 at 11:41 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Thu, 26 Oct 2017 09:40:19 -0600
> Cheyenne Wills <cheyenne.wills@gmail.com> wrote:
>
>> Briefly when I upgraded a system from 4.0.5 kernel to 4.9.5 (and
>> later) I'm seeing a blocked task timeout with heavy IO against a
>> multi-lun btrfs filesystem.  I've tried a 4.12.12 kernel and am still
>> getting the hang.
>
> There is now 4.9.58 (fifty three versions later!) and 4.12 series is long
> abandoned and gone from the charts altogether. So just in case, did you check
> with the latest kernels?
>
> Also, keep in mind the 120 second warnings are just that, and not an error
> condition by themselves. You can disable them or increase the maximum timeout
> in sysctl settings. And it is not clear from your reports if you only get
> warnings and after the load subsides everything is back to normal, or the FS
> locks out "for good", i.e. with all access attempts hanging indefinitely and
> no way to unmount the FS or otherwise recover.
>
> --
> With respect,
> Roman

Thank you.

The whole system ends up hanging and doesn't recover. A hard reboot is
required to recover (e.g. I can't shutdown the system).

The problem first appeared a while back when I was doing an upgrade
from a 4.0.5 kernel to a 4.4.21 kernel.
I opened the problem against a 4.9.5 kernel (this was back in Jan
2017).  Since then I've tried various levels of the kernel with the
latest (last couple of days) being
a 4.12.12 level (I'm running a gentoo system and the gentoo-sources
4.12.12 is their highest stable level) -- all levels that I've tried
since the 4.4.21 have failed so far.

I'm about to try an old 4.1 kernel just to see if I can bisect where
the problem was introduced (which is somewhere between 4.0.5 (works)
and 4.4.21 (fails)  kernel.
I can also try a newer ("unstable") 4.13 gentoo-sources kernel to see
if anything even more recent fixes the problem.

Thanks

Cheyenne Wills
