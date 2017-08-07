Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:37201 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbdHGIrf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 04:47:35 -0400
Received: by mail-qt0-f181.google.com with SMTP id 16so36564125qtz.4
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Aug 2017 01:47:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <30657728.PhKxf8kc3H@nimrod.thomas.wurfbaum.net>
References: <1569935.QpkscbukDQ@nimrod.thomas.wurfbaum.net>
 <1785889.2psX1aaXR2@nimrod.thomas.wurfbaum.net> <1636460.K4WVeUNh5S@nimrod.thomas.wurfbaum.net>
 <30657728.PhKxf8kc3H@nimrod.thomas.wurfbaum.net>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 7 Aug 2017 10:47:34 +0200
Message-ID: <CAPmG0jYHHhj83CfdJsNkgbDVLt7RjP-H=j6LyfZP4qZe1a8jOA@mail.gmail.com>
Subject: Re: Crashed filesystem, nothing helps
To: thomas@wurfbaum.net
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 7, 2017 at 7:12 AM, Thomas Wurfbaum <thomas@wurfbaum.net> wrote:
> Now i do a btrfs-find-root, but it runs now since 5 day without a result.
> How long should i wait? Or is it already to late to hope?
>
> mainframe:~ # btrfs-find-root.static /dev/sdb1
> parent transid verify failed on 29376512 wanted 1327723 found 1489835
> parent transid verify failed on 29376512 wanted 1327723 found 1489835
> parent transid verify failed on 29376512 wanted 1327723 found 1489835
> parent transid verify failed on 29376512 wanted 1327723 found 1489835
> Ignoring transid failure
> Superblock thinks the generation is 1490226
> Superblock thinks the level is 1
>
> The process is still running...

I also have a filesystem that has a big difference in wanted and found
transid. I my case the wanted is much higher than the found. I also
tried to repair it for more than 2 weeks in total, but both progs and
kernel fail. I haven't seen that you mounted it just with only ro
mount option. I think in your case chances are low, but it worked in
my case. I could copy all data (7TB unique non-shared thorugh snapshot
or reflink) to a new fs with rsync. Btrfs send and other action done
by btrfs progs quite soon failed on 1 or several parent transid
inconsistencies.

Others on this forum have stated that when there is such a big
difference in transid, the fs is simple unrepairable. I must admit
that this is the truth in practice. Restore with btrfs-restore I tried
once on a other fs that was damaged and at that time the restore gave
quite different content for some file compared to a copy of the same
file from the fs mouted via the kernel.
