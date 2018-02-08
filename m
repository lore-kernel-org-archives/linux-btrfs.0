Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:38444 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbeBHB0m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 20:26:42 -0500
Received: by mail-qk0-f170.google.com with SMTP id w128so3717638qkb.5
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Feb 2018 17:26:42 -0800 (PST)
MIME-Version: 1.0
From: Nick Gilmour <nickeforos@gmail.com>
Date: Thu, 8 Feb 2018 02:26:01 +0100
Message-ID: <CAH-droxO-K9RM9uCLie=6bg3cgC5uqo_wcscc0BmB9HyKM5gQQ@mail.gmail.com>
Subject: IO Error (.snapshots is not a btrfs subvolume)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have successfully restored a snapshot of root but now when I try to
make a new snapshot I get this error:
IO Error (.snapshots is not a btrfs subvolume).
My snapshots were within @ which I renamed to @_old.
What can I do now? How can I move the snapshots from @_old/ into @ and
be able to make snapshots again?

This is an excerpt of my subvolumes list:

# btrfs subvolume list /
ID 257 gen 175397 top level 5 path @_old
ID 258 gen 175392 top level 5 path @pkg
ID 260 gen 175447 top level 5 path @tmp
ID 262 gen 19 top level 257 path @_old/var/lib/machines
ID 268 gen 175441 top level 5 path @test
ID 291 gen 175394 top level 257 path @_old/.snapshots
ID 292 gen 1705 top level 291 path @_old/.snapshots/1/snapshot
...

ID 3538 gen 175398 top level 291 path @_old/.snapshots/1594/snapshot
ID 3540 gen 175447 top level 5 path @


Regards,
Nick
