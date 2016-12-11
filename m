Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34807 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753930AbcLKXaC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 18:30:02 -0500
Received: by mail-io0-f182.google.com with SMTP id p42so149363088ioo.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 15:30:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
 <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com> <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
From: Markus Binsteiner <makkus@gmail.com>
Date: Mon, 12 Dec 2016 12:30:01 +1300
Message-ID: <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> OK when I do it on a file system with just 14GiB of metadata it's
> maybe 15 seconds. So a few minutes sounds sorta suspicious to me but,
> *shrug* I don't have a file system the same size to try it on, maybe
> it's a memory intensive task and once the system gets low on RAM while
> traversing the file system it slows done a ton.

Ok, thanks, looks like there is some other issue then as well. The
process doesn't take up any memory at all, just 100% of one core.

Maybe I'll try to use it with an older version of btrfs-progs, from
Debian Jessie. Don't think it'll make any difference, but I don't know
what else to try. At this point I'm more curious than anything else.
I've got backups for most of my stuff, just a few rogue scripts I'd
have to re-write. Still, would be nice to get those back.
