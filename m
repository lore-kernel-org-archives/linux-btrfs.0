Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33443 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754671AbcHVTLp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 15:11:45 -0400
Received: by mail-qk0-f170.google.com with SMTP id z190so90136549qkc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Aug 2016 12:11:45 -0700 (PDT)
Message-ID: <1471893091.3385.5.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 22 Aug 2016 16:11:31 -0300
In-Reply-To: <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
         <CAJCQCtSwHCkW_nUNp4-R=S+ExZMk97i2qr6MwSuRU540c6xtfg@mail.gmail.com>
         <1471028417.16857.12.camel@gmail.com>
         <CAJCQCtTrEqR=UNpHp7ApbdBkwRRT6U5tiSHcs2y4N-P_G5u=Fw@mail.gmail.com>
         <CAJCQCtS51syrzxvpZXGzS=Ge=rW1iEfZDj6VrVmON39ww-Hmdg@mail.gmail.com>
         <CAKdnfRJeOXHmrumDkfxLTf-nU=KwZ0f7ybET-3o7kwwJDOZ2aw@mail.gmail.com>
         <CAJCQCtTrGTjOMaNNV7JKBybgbyn=_pYP=KvE1zc4AuPs=mo2=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New information guys! I formatted using the latest Tumbleweed snapshot
(btrfs-progs v4.7+20160729) and I still have the same problem.

I notice two things. First, when I see the "No space left on device",
it is fixed when the Metadata space increases **a lot**. For example,
when the error first occurred, I had:

Metadata, DUP: total=2.00GiB, used=811.52MiB

After waiting a while (could not run balance), it was automatically
fixed and then I have:

Metadata, DUP: total=9.50GiB, used=811.52MiB

During the error, when I ran the balance command, I see these messages
in `dmesg`:

Ago 22 16:00:03 ronanarraes-osd kernel: BTRFS info (device sda6):
relocating block group 9323937792 flags 34
Ago 22 16:00:04 ronanarraes-osd kernel: BTRFS info (device sda6): found
1 extents
Ago 22 16:00:04 ronanarraes-osd kernel: BTRFS info (device sda6): 1
enospc errors during balance
Ago 22 16:00:24 ronanarraes-osd kernel: BTRFS info (device sda6):
relocating block group 36201037824 flags 34
Ago 22 16:00:24 ronanarraes-osd kernel: BTRFS info (device sda6): 2
enospc errors during balance
Ago 22 16:00:45 ronanarraes-osd kernel: BTRFS info (device sda6):
relocating block group 36234592256 flags 34
Ago 22 16:00:46 ronanarraes-osd kernel: BTRFS info (device sda6): found
1 extents
Ago 22 16:00:46 ronanarraes-osd kernel: BTRFS info (device sda6): 4
enospc errors during balance
Ago 22 16:01:20 ronanarraes-osd kernel: BTRFS info (device sda6):
relocating block group 38415630336 flags 34
Ago 22 16:01:21 ronanarraes-osd kernel: BTRFS info (device sda6): found
1 extents
Ago 22 16:01:21 ronanarraes-osd kernel: BTRFS info (device sda6): 8
enospc errors during balance

Does it add anything relevant to the problem?

Regards,
Ronan Arraes
