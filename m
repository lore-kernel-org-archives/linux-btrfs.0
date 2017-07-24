Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:34759 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbdGXUXL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 16:23:11 -0400
Received: by mail-lf0-f52.google.com with SMTP id g25so44914173lfh.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 13:23:11 -0700 (PDT)
MIME-Version: 1.0
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 24 Jul 2017 22:22:53 +0200
Message-ID: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
Subject: Re: write corruption due to bio cloning on raid5/6
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I accidentally ran into this problem (it's pretty silly because I
almost never run RC kernels or do dio writes but somehow I just
happened to do both at once, exactly before I read your patch notes).
I didn't initially catch any issues (I see no related messages in the
kernel log) but after seeing your patch, I started a scrub (*) and it
hung.

Is there a way to fix a filesystem corrupted by this bug or does it
need to be destroyed and recreated? (It's m=s=raid10, d=raid5 with
5x4Tb HDDs.) There is a partial backup (of everything really
important, the rest is not important enough to be kept in multiple
copies, hence the desire for raid5...) and everything seems to be
readable anyway (so could be saved if needed) but nuking a big fs is
never fun...

Scrub just hangs and pretty much makes the whole system hanging (it
needs a power cycling for a reboot). Although everything runs smooth
besides this. Btrfs check (read-only normal-mem mode) finds no errors,
the kernel log is clean, etc.

I think I deleted all the affected dio-written test-files even before
I started scrubbing, so that doesn't seem to do the trick. Any other
ideas?


* By the way, I see raid56 scrub is still painfully slow (~30Mb/s /
disk with raw disk speeds of >100 Mb/s). I forgot about this issue
since I last used raid5 a few years ago.
