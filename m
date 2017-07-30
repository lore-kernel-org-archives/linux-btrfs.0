Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:37205 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbdG3Oy1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Jul 2017 10:54:27 -0400
Received: by mail-lf0-f48.google.com with SMTP id m86so98368815lfi.4
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Jul 2017 07:54:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$12269$5fb80e78$f5b26ca4$74a3427f@cox.net>
References: <20170501170641.GG3516@merlins.org> <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org> <21425367.VGcO8ck7Vu@merkaba>
 <MEXPR01MB216863F67F4553F8564CC3CD9EA80@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <pan$2b9aa$a4dca8a2$fc1e4ebe$a8fffbe3@cox.net> <CAK5rZE7sj+T8-x0q=wPXeHKN4zBZGc2Jhj9NYA7ZQcV+yk2XSA@mail.gmail.com>
 <pan$12269$5fb80e78$f5b26ca4$74a3427f@cox.net>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Sun, 30 Jul 2017 16:54:25 +0200
Message-ID: <CAK5rZE6vMujb5KEqwUZD2-ZmZ4vi2T4+J2BzTLi9qqx8GeFKgg@mail.gmail.com>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a more
 recent gen (33682) compared to the found root node (0)
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7/30/17, Duncan <1i5t5.duncan@cox.net> wrote:
>>> Also, all my btrfs are raid1 or dup for checksummed redundancy

>> Do you have any experience/advice/comment regarding
>> dup data on ssds?

> Very good question. =:^)

> Limited.  Most of my btrfs are raid1, with dup only used on the device-
> respective /boot btrfs (of which there are four, one on each of the two
> ssds that otherwise form the btrfs raid1 pairs, for each of the working
> and backup copy pairs -- I can use BIOS to select any of the four to
> boot), and those are all sub-GiB mixed-bg mode.

Is this a military or deep space device? ;)

> So all my dup experience is sub-GiB mixed-blockgroup mode.
>
> Within that limitation, my only btrfs problem has been that at my
> initially chosen size of 256 MiB, mkfs.btrfs at least used to create an
> initial data/metadata chunk of 64 MiB.  Remember, this is dup mode, so
> there's two of them = 128 MiB.  Because there's also a system chunk, that
> means the initial chunk cannot be balanced even with an entirely empty
> filesystem, because there's not enough space to write a second 64 MiB
> chunk duped to 128 MiB.

For /boot, I've also tried dup data.

But because of combinations of constraints you've mentioned,
I totally give-up trying to have a bullet proof /boot
as my poor laptop is not mission critical as your device and
as I do always have bootable backups and always carry
some bootable sdcards.

Perhaps that has something to do with me kicking
out all systemd, inits, initramfs, mkinitcpio, dracut, etc, etc.

Now the init on /boot is a "19 lines" shell script, including lines
for keymap, hdparm, crytpsetup. And let's not forget this is
possible by a custom kernel, its reliable buddy syslinux.

Interestingly my seach for reliability started with
"dup data" and ended up here. :)
