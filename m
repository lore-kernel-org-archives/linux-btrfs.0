Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36692 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbcDQVzm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 17:55:42 -0400
Received: by mail-wm0-f45.google.com with SMTP id v188so95427439wme.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 14:55:41 -0700 (PDT)
MIME-Version: 1.0
From: Zachary Vance <vanceza@gmail.com>
Date: Sun, 17 Apr 2016 14:55:20 -0700
Message-ID: <CAC8+__7+ALM5WK-+aCkH0Nc1GUTV5v=7R0SB9LFFE48YM3NLeg@mail.gmail.com>
Subject: [resend] btrfs-send -c fails: reproduction case
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Apologies for the repeat send for anyone that gets this twice; I was
informed there was a problem with my mail setup and many ISPs would
block the first message. I have also simplified the reproduction case.

---

Reproduction case after running into the same problem as Paride
Legovini: http://article.gmane.org/gmane.comp.file-systems.btrfs/48706/match=send

To recap, the basic problem is that you can get into a state where
"btrfs-send -c" fails for a subvolume, with "ERROR: parent
determination failed for 9622". It appears the problem happens when
the 'parent_uuid' does not exist.

I'm pretty sure this isn't the intended behavior, and it's certainly
preventing me from copying my backups right now.

burn% sudo btrfs subvol create a
Create subvolume './a'
burn% sudo btrfs subvol snapshot a -r a-r
Create a readonly snapshot of 'a' in './a-r'
burn% sudo btrfs subvol create b1
Create subvolume './b1'
burn% sudo btrfs subvol snapshot b1 -r b2
Create a readonly snapshot of 'b1' in './b2'
burn% sudo btrfs subvol del b1
Delete subvolume (no-commit): '/data/b1'

burn% sudo btrfs send -c b2 a-r >/dev/null
At subvol a-r
ERROR: parent determination failed for 9637

/data/a-r
        Name:                   a-r
        UUID:                   819415e9-ea57-4a4d-9745-78a65f19b614
        Parent UUID:            e63b985a-3463-be4c-8ad5-900cd147ef7d
        Received UUID:          -
        Creation time:          2016-02-20 10:19:59 -0800
        Subvolume ID:           9638
        Generation:             18524
        Gen at creation:        18524
        Parent ID:              5
        Top level ID:           5
        Flags:                  readonly
        Snapshot(s):
burn% sudo btrfs subvolume show b2
/data/b2
        Name:                   b2
        UUID:                   e1d0314d-9c2a-5240-9f4c-1716b7e87741
        Parent UUID:            00920504-c78b-ee42-af9f-05f4600321bb
        Received UUID:          -
        Creation time:          2016-02-20 10:19:01 -0800
        Subvolume ID:           9637
        Generation:             18522
        Gen at creation:        18522
        Parent ID:              5
        Top level ID:           5
        Flags:                  readonly
        Snapshot(s):

[root@burn ~]# btrfs --version
btrfs-progs v4.4.1

[root@burn ~]# uname -a
Linux burn 4.5.0-1-ARCH #1 SMP PREEMPT Tue Mar 15 09:41:03 CET 2016
x86_64 GNU/Linux

---
Zachary Vance
