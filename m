Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:39036 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757370AbdLQUmk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Dec 2017 15:42:40 -0500
Received: by mail-oi0-f46.google.com with SMTP id r63so9393836oia.6
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Dec 2017 12:42:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <23094.37316.66397.431081@tree.ty.sabi.co.uk>
References: <5A357909.8010206@yandex.ru> <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 17 Dec 2017 13:42:39 -0700
Message-ID: <CAJCQCtT_vM4d4P0XDqGyhWB2gEjB+A1qQ3PADc0CZBGu8CY8BA@mail.gmail.com>
Subject: Re: Unexpected raid1 behaviour
To: Peter Grandi <pg@btrfs.list.sabi.co.uk>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 17, 2017 at 8:48 AM, Peter Grandi <pg@btrfs.list.sabi.co.uk> wrote:
> "Duncan"'s reply is slightly optimistic in parts, so some
> further information...

>> and it should detect a device coming back as a different
>> device too.
>
> That is disagreeable because of poor terminology: I guess that
> what was intended that it should be able to detect a previous
> member block-device becoming available again as a different
> device inode, which currently is very dangerous in some vital
> situations.

Duncan probably means if the device reappears with different
enumeration (was /dev/sdb1 but comes back as /dev/sde1), that Btrfs
can recover from this by using the Btrfs specific dev.uuid to
recognize the device. And also by knowing generation it in effect has
a virtual write intent bitmap to use to catch up that device for
missing commits, which is something that doesn't currently happen
automatically; it requires either a scrub or balance to catch up a
formerly missing device - a very big penalty because the whole array
has to be done to catch it up for what might be only a few minutes of
missing time.



-- 
Chris Murphy
