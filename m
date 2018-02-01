Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:33756 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751715AbeBAVjL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Feb 2018 16:39:11 -0500
Received: by mail-ot0-f181.google.com with SMTP id q9so7390703oti.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Feb 2018 13:39:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
References: <CALvFGyCYKs_MMB5st-nm463_UBcA859iBDHX8xjRX8eCME7Ytw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 1 Feb 2018 14:39:10 -0700
Message-ID: <CAJCQCtS0xhj64YK3rxQ+_8y1dwZ-_vBe-D97PRNVFhmAPnaLmw@mail.gmail.com>
Subject: Re: btrfs - kernel warning
To: Patrik Ostrihon <patrik.ostrihon@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 1, 2018 at 2:06 PM, Patrik Ostrihon
<patrik.ostrihon@gmail.com> wrote:
> Hi,
>
> Today I saw warning in dmesg output. But I don't know what it means.
> Could you help me please? Is it something dangerous for my dato on
> this filesystem?

Is this a persistent warning you're getting or is it a one time message?

Looks like it's happening when deallocating empty block groups. I'm
not sure why, but I also can't tell from the call trace which of the
two Btrfs file systems it's referring to.

Anyway, what I would do in order:

a. Backups. Your post suggests you're worried about your data, so
first order of business is to update the backups. Raid1 is not a
backup.
b. I'd find a relatively recent live, so that it has a relatively
recent btrfs-progs, v4.11.3 or newer. Create USB stick media to boot
from and run the following commands on both volumes (pick one of the
two drives for each Btrfs volume; it is not a per drive check it is a
per volume check and it doesn't matter which of the two drives you
pick).

btrfs check
btrfs check --mode=lowmem

The lowmem mode is a different implementation and sometimes there are
different results.

c. You only posted the df output for one of the two file systems. The
one you posted is not completely raid1, you have some single chunks
which don't appear to be used but that they're present can impact the
ability to mount degraded (i.e. degraded mount might fail in this
condition)

btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft /usr/local/data


That will leave existing raid1 block groups untouched and will
effectively remove the unused single chunks. You should check the
other volume and make sure all block groups are raid1.



-- 
Chris Murphy
