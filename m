Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:50771 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753069AbeDPQHj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 12:07:39 -0400
Received: by mail-it0-f48.google.com with SMTP id r19-v6so12095963itc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 09:07:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <db34f571-2a31-5a0a-9f8d-e55a9b579753@gmx.com>
References: <CAG4vCreOmBdsPT84ajozGb4XV83+Fc-joyUqXgizutPah0VrrA@mail.gmail.com>
 <db34f571-2a31-5a0a-9f8d-e55a9b579753@gmx.com>
From: Tom Vincent <tom@tlvince.com>
Date: Mon, 16 Apr 2018 17:07:38 +0100
Message-ID: <CAG4vCrfCb=VUQe8rpMebeUCHbqwrXviBmOYpekRbFMRL-xJVKA@mail.gmail.com>
Subject: Re: btrfs fails to mount after power outage
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12 April 2018 at 00:25, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> I'm curious about what's the underlying disk?

It's an Samsung PM951 NVMe SSD.

> Is it plain physical device? Or have other layers like bcache/lvm?

btrfs on LUKS

>> btrfs check
> Full output please.

https://gist.githubusercontent.com/tlvince/acf51b37622c216e1c33cdc3dfbd321f/raw/d0237948bbffacd4bb8d53fdfa5f23391416c1e2/btrfs-check.txt

> For transid error, btrfs check --repair can fix it, but only do it when
> that's the only problem.

I ran this (for ~12+ hours) to no avail; it appears to have been
looping around "Btree for root 259 is fixed". I grew impatient and
SIGINT-ed, which unsurprisingly toasted the file system once and for
all (I rebuilt from backups at that point).

Full output:

https://gist.githubusercontent.com/tlvince/8060c19526aa011b0baff2b12e3873fd/raw/ecc43bd9dc7b352e490aa0bf0deac368af04e117/btrfs-check-repair.txt

Note, the system was fine for a few days after zero-log (before check
--repair), but then hit the same transid error at boot.

On 13 April 2018 at 06:46, Duncan <1i5t5.duncan@cox.net> wrote:
> What mount options?  In particular, is the discard option used (and of
> course I'm assuming nothing as insane as nobarrier)?

noatime,compress=lzo

... as well as some defaults: rw,noatime,compress=lzo,ssd,space_cache
