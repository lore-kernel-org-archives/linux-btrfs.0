Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35407 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751464AbcLKAMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Dec 2016 19:12:07 -0500
Received: by mail-io0-f180.google.com with SMTP id h30so117483088iod.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Dec 2016 16:12:07 -0800 (PST)
MIME-Version: 1.0
From: Markus Binsteiner <makkus@gmail.com>
Date: Sun, 11 Dec 2016 13:12:06 +1300
Message-ID: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
Subject: btrfs-find-root duration?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It seems I've accidentally deleted all files in my home directory,
which sits in its own btrfs partition (lvm on luks). Now I'm trying to
find the roots to be able to use btrfs restore later on.

btrfs-find-root seems to be taking ages though. I've run it like so:

btrfs-find-root /dev/mapper/think--big-home  -o 5 > roots.txt

After 16 hours, there is still no output, but it's still running
utilizing 100% of one core. Is there any way to gauge how much longer
it'll take? Should there have been output already while it's running?

When I run it without redirecting stdout, I get:

$ btrfs-find-root /dev/mapper/think--big-home  -o 5

Superblock doesn't contain generation info for root 5
Superblock doesn't contain the level info for root 5

When I omit the '-o 5', it says:

$ btrfs-find-root /dev/mapper/think--big-home

Superblock thinks the generation is 593818
Superblock thinks the level is 0

Is the latter the way to run it? Did that initially, but that  didn't
return any results in a reasonable timeframe either.

The filesystem was created with Debian Jessie, but I'm using Ubuntu (
btrfs-progs v4.7.3 ) to try to restore the files at the moment.

Thanks!
