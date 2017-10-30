Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:56003 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbdJ3EHt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 00:07:49 -0400
Received: by mail-ua0-f174.google.com with SMTP id b11so8573255uae.12
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Oct 2017 21:07:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1484297967.48018.1508985286675@email.1and1.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com> <1484297967.48018.1508985286675@email.1and1.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 30 Oct 2017 09:37:08 +0530
Message-ID: <CAKuJGC-K3ph_fiZe49pm27Fz+YtVh7WB5kC7JrJ9Ry6KkTrzxA@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Zak Kohler <y2k@y2kbugger.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I will gladly repeat this process, but I am very concerned why this
> corruption happened in the first place.
>
Can you share these steps as simple bash script? Currently I'm running
few tests, I can check your script and share the results.


> The only thing I could think of is that the btrfs version that I used to mkfs
> was not up to date. Is there a way to determine which version was used to
> create the filesystem?
>

If I'm not wrong, i don't think we can get mkfs version from existing file
system layout. what was your kernel version?

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org
