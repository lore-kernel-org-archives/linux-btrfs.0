Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:36528 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933153AbdEOL0E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 07:26:04 -0400
Received: by mail-wm0-f44.google.com with SMTP id u65so78075361wmu.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 May 2017 04:26:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D9491068-A906-4B75-9ED3-B98960FFBF14@gmail.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAK5rZE7WHeTknmQdjX7vianEj4RmdLU+ocTLhbAxYenRjLegaA@mail.gmail.com>
 <20170512202756.16bd785f@jupiter.sol.kaishome.de> <pan$3384$13ad2b1f$3febf76a$c09fcbd7@cox.net>
 <CAJCQCtQnM21-JPs+6+YeykTj-s1J43E8rNCkHHyk+AjvzZEddg@mail.gmail.com>
 <250FCE39-0DAE-4AF2-B378-E56BE044F2E7@gmail.com> <CAK5rZE7MKrqNSuJXTYe=H_T6WbYJgcGhV9VUHH0pQ689-tKiAg@mail.gmail.com>
 <D9491068-A906-4B75-9ED3-B98960FFBF14@gmail.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 15 May 2017 13:25:54 +0200
Message-ID: <CAK5rZE7MivXmT_zvph0sYqqq-62bGgDxqYbAudd92i+E54fOdg@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5/15/17, Tomasz Kusmierz <tom.kusmierz@gmail.com> wrote:
> Theoretically all sectors in over provision are erased - practically they
> are either erased or waiting to be erased or broken.
> Over provisioned area does have more uses than that. For example if you have
> a 1TB drive where you store 500GB of data that you never modify -> SSD will
> copy part of that data to over provisioned area -> free sectors that were
> unwritten for a while -> free sectors that were continuously hammered by
> writes and write a static data there. This mechanism is wear levelling - it
> means that SSD internals make sure that sectors on SSD have an equal use
> over time. Despite of some thinking that it’s pointless imagine situation
> where you’ve got a 1TB drive with 1GB free and you keep writing and
> modifying data in this 1GB free … those sectors will quickly die due to
> short flash life expectancy ( some as short as 1k erases !!!!! ).

Thanks for the info. It can be understood that, the drive
has a pool of erase blocks from which some portion (say %90-95)
is provided as usable. Trimmed blocks are candidates
for new allocations. If the drive is not trimmed, that allocatable
pool becomes smaller than it can be and new allocations
under wear levelling logic is done from smaller group.
This will probably increase data traffic on that "small group"
of blocks, eating from their erase cycles.

However, this logic is valid if the drive does NOT move
data on trimmed blocks to trimmed/available ones.

Under some advanced wear leveling operations, drive may
decide to swap two blocks (one occupied/one vacant) if the
cummulative erase cycles of the former is much lower than
the latter to provide some balancing affect.

Theoretically swapping may even occur when the flash tend
to lose charge (and thus data) based on the age of the
data and/or block health.

But in any case I understand that trimming will provide
important degree of freedom and health to the drive.
Without trimming drive will continue to deal with worthless
blocks simply because it doesn't know they are worthless...
