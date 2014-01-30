Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:62747 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbaA3LyY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 06:54:24 -0500
Received: by mail-qa0-f41.google.com with SMTP id w8so4255812qac.0
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 03:54:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Thu, 30 Jan 2014 12:53:44 +0100
Message-ID: <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
Subject: Re: Re: lost with degraded RAID1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Answer from Duncan, 1i5t5.duncan@DOMAIN.HIDDEN (Thanks for the try)]

[AFAIK that shouldn't be the case.  Degraded should allow the RW mount --
I know it did some kernels ago when I tried it then, and if it changed,
it's news to me too, in which case I need to do some reevaluation here.]

What I think /might/ have happened is that there's some other damage to
the filesystem unrelated to the missing device in the raid1, which forces
it read-only as soon as btrfs finds that damage.  However, mount -o
remount,rw,degraded should still work, I /think/.]

http://www.spinics.net/lists/linux-btrfs/msg20164.html

[you should have already had that backup, and wouldn't need to
make it, only perhaps update a few files that changed since your last
backup that you were willing to lose the changes too if it came to it,
but since you can still mount ro, you might as well take the chance to
update the backup given that you can.]

I have backups on other disks and from. Thats not my problem. That was
just as a notice, to show that the data IS totally fine. It was/is
RAID1, so why shouldnt it be.

[As I said, to the best of my (non-dev btrfs user and list regular)
knowledge, mount -o degraded,rw should work.]

No, it doesnt.
Syslog says: "Jan 30 12:44:02 fortknox kernel: [756677.795661] Btrfs:
too many missing devices, writeable mount is not allowed"

[One other thing that might help is the skip_balance mount option, to
avoid restarting the in-process balance immediately.]

No, same in syslog.

[If that fails, try canceling the balance
and then starting a new balance using balance filters...]

The balance was already canceled AND its not possible to balance a ro
filesystem.

[Meanwhile, at least you have ro access to all the data and can take that
backup that you apparently ignored the warnings about making, previously.]

Yes, i can and no, i did not.
