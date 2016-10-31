Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.161.180]:34760 "EHLO
        mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757543AbcJaB3Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Oct 2016 21:29:16 -0400
Received: by mail-yw0-f180.google.com with SMTP id w3so124874161ywg.1
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Oct 2016 18:29:15 -0700 (PDT)
MIME-Version: 1.0
From: "Janos Toth F." <toth.f.janos@gmail.com>
Date: Mon, 31 Oct 2016 02:29:14 +0100
Message-ID: <CANznX5FFCHgON_SJ+pjLszMBPAfT2zXS6DEQ36BoFGNFnbZ-vw@mail.gmail.com>
Subject: btrfs check --repair: ERROR: cannot read chunk root
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I stopped using Btrfs RAID-5 after encountering this problem two times
(once due to a failing SATA cable, once due to a random kernel problem
which caused the SATA or the block device driver to reset/crash).
As much as I can tell, the main problem is that after a de- and a
subsequent re-attach (on purpose or due to failing cable/controller,
kernel problem, etc), your de-synced disk is taken back to the "array"
as if it was still in sync despite having a lower generation counter.
The filesystem detects the errors later but it can't reliably handle,
let alone fully correct them. If you search on this list with "RAID 5"
you will see that RAID-5/6 scrub/repair has some known serious
problems (which probably contribute to this but I guess something on
top of those problems plays a part here to make this extra messy, like
the generations never getting synced). The de-synchronization will get
worse over time if your are in writable mode (the generation of the
de-synced disk is stuck), up to he point of the filesystem becoming
unmountable (if not already, probably due to scrub causing errors on
the disks in sync).
I was able to use "rescue" once and even achieve a read-only mount
during the second time (with only a handful of broken files). But I
could see a pattern and didn't want to end up in situations like that
for a third time.
Too bad, I would prefer RAID-5/6 over RAID-1/10 any day otherwise
(RAID-5 is faster than RAID-1 and you can loose any two disks from a
RAID-6, not just one from each mirrors on RAID-10) but most people
think it's slow and obsolete (I mean they say that about hardware or
mdadm RAID-5/6 and Btrfs's RAID-5/6 is frowned upon for true reasons)
while it's actually the opposite with a limited number of drives (<=6,
or may be up to 10).
It's not impossible to get right though, RAID-Z is nice (except the
inability to defrag the inevitable fragmentation), so I keep hoping...
