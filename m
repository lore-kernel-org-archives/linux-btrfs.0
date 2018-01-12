Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:45882 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965236AbeALXR5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 18:17:57 -0500
Received: by mail-it0-f52.google.com with SMTP id x42so10873930ita.4
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jan 2018 15:17:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
References: <20180112210439.2ivh2wmlq2uuisjo@breakpoint.cc>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 13 Jan 2018 02:16:59 +0300
Message-ID: <CAGqmi745-CoeedxEw_Tp-5mNxhFi92XroUZq1rP_goz7mQ_eGg@mail.gmail.com>
Subject: Re: invalid files names, btrfs check can't repair it
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2018-01-13 0:04 GMT+03:00 Sebastian Andrzej Siewior <sebastian@breakpoint.cc>:
> Hi,
>
> so I had bad memory and before I realized it and removed it btrfs took some
> damage. Now I have this:
>
> |ls -lh crap/
> |ls: cannot access 'crap/2f3f379b2a3d7499471edb74869efe-1948311.d': No such file or directory
> |ls: cannot access 'crap/454bf066ddfbf42e0f3b77ea71c82f-878732.o': No such file or directory
> |total 0
> |-????????? ? ? ? ?            ? 2f3f379b2a3d7499471edb74869efe-1948311.d
> |-????????? ? ? ? ?            ? 454bf066ddfbf42e0f3b77ea71c82f-878732.o
>
> and in dmesg I see:
>
> | BTRFS critical (device sda4): invalid dir item type: 33
> | BTRFS critical (device sda4): invalid dir item name len: 8231
>
> `btrfs check' (from v4.14.1) finds them and prints them but has no idea
> what to do with it. Would it be possible to let the check tool rename
> the offended filename to something (like its inode number) put it in
> lost+found if it has any data attached to it and otherwise simply remove
> it? Right now I can't remove that folder.
>
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Deletion:
If that happens in subvol, you can create new subvol, reflink data and
delete old vol.
I don't know other ways to fix that entries.

P.S.
I have that issue without bad ram, but by some system hangs/resets
(I've use notreelog
 as workaround for now).

Thanks.
-- 
Have a nice day,
Timofey.
