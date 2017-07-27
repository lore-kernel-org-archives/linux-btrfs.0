Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36664 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdG0Pdu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:33:50 -0400
Received: by mail-wm0-f44.google.com with SMTP id t201so102787711wmt.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 08:33:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccwAaWtK=VqNcB9z9Q2qLNHr3q0QmWR0hg=RoG1ynZB-ng@mail.gmail.com>
References: <CAMG9ccwAaWtK=VqNcB9z9Q2qLNHr3q0QmWR0hg=RoG1ynZB-ng@mail.gmail.com>
From: Ivan Sizov <sivan606@gmail.com>
Date: Thu, 27 Jul 2017 18:33:29 +0300
Message-ID: <CAMG9ccxPHHwEYBYZddTaX96kEnan5NtDvhUW=gw+NoUe7amyiA@mail.gmail.com>
Subject: Re: What are the typical usecase of "btrfs check --init-extent-tree"?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've just noticed a huge number of errors on one of the RAID's disks.
"btrfs dev stats" gives:

[/dev/sdc1].write_io_errs    0
[/dev/sdc1].read_io_errs     305
[/dev/sdc1].flush_io_errs    0
[/dev/sdc1].corruption_errs  429
[/dev/sdc1].generation_errs  0

[/dev/sda1].write_io_errs    58331
[/dev/sda1].read_io_errs     57438
[/dev/sda1].flush_io_errs    37
[/dev/sda1].corruption_errs  10110
[/dev/sda1].generation_errs  0

[/dev/sdb1].write_io_errs    0
[/dev/sdb1].read_io_errs     91
[/dev/sdb1].flush_io_errs    0
[/dev/sdb1].corruption_errs  0
[/dev/sdb1].generation_errs  0

[/dev/sdd].write_io_errs    0
[/dev/sdd].read_io_errs     0
[/dev/sdd].flush_io_errs    0
[/dev/sdd].corruption_errs  0
[/dev/sdd].generation_errs  0


On the one hand, it explains the cause of problems, don't it? On
another, I hardly understand how to fix such a complex problem: it
seems that my stupid "check --repair" attempts corrupted FS internals
heavily.
Can I just remove sda from RAID-1 and run rebalance?

2017-07-27 17:02 GMT+03:00 Ivan Sizov <sivan606@gmail.com>:
> My RAID-1 FS have multiple "backpointer mismatch" errors. "btrfs check
> --repair" doesn't help but only increases the number of errors.
> Initially, only 2 roots were affected (uncleanly deleted snapshots I
> suppose). But after I ran "check --repair" new "check --readonly"
> returns such errors on almost every root!
> You can read a small prehistory in this mailing list thread:
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg64640.html
> Recently I decided to resume my attempts to recover the FS and, at
> some point I booted into my system (Fedora 25 with 4.11.3-200 kernel
> with patch from the thread mentioned above). A Snapper daemon tried to
> remove some corrupted snapshot and, as result, triggered btrfs-cleaner
> bug. Now I can neither RW-mount the FS nor run scrub (scrub is
> "aborted" in 00:00:00 after start).
>
> How does "--init-extent-tree" deal with backref problems? Will those
> backrefs completely reconstructed?
>
> Can similar "backref not found" and "backpointer mismatched" errors
> have very different causes and different fix scenarios?
>
> --
> Ivan Sizov



-- 
Ivan Sizov
