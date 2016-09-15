Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35448 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753199AbcIOPsO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 11:48:14 -0400
Received: by mail-yw0-f175.google.com with SMTP id u82so56211669ywc.2
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Sep 2016 08:48:14 -0700 (PDT)
MIME-Version: 1.0
From: E V <eliventer@gmail.com>
Date: Thu, 15 Sep 2016 11:48:13 -0400
Message-ID: <CAJtFHUQOW4RBZcOu0FWe7dVoxTJWD9bMjvaXYLkXy_Pw7meC-g@mail.gmail.com>
Subject: Thoughts on btrfs RAID-1 for cold storage/archive?
To: Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm investigating using btrfs for archiving old data and offsite
storage, essentially put 2 drives in btrfs RAID-1, copy the data to
the filesystem and then unmount, remove a drive and take it to an
offsite location. Remount the other drive -o ro,degraded until my
systems slots fill up, then remove the local drive and put it on a
shelf. I'd verify the file md5sums after data is written to the drive
for piece of mind, but maybe a btrfs scrub would give the same
assurances. Seem straightforward? Anything to look out for? Long term
format stability seems good, right? Also, I like the idea of being
able to pull the offsite drive back and scrub if the local drive ever
has problems, a nice extra piece of mind we wouldn't get with ext4.
Currently using the 4.1.32 kernel since the driver for the r750 card
in our 45 drives system only supports up to 4.3 ATM.
