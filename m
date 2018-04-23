Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:52059 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbeDWEL1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 00:11:27 -0400
Received: by mail-it0-f54.google.com with SMTP id o20-v6so9229631itc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Apr 2018 21:11:27 -0700 (PDT)
MIME-Version: 1.0
From: Patrick Mitchell <patricklmitchell9@gmail.com>
Date: Mon, 23 Apr 2018 00:11:26 -0400
Message-ID: <CA+2BD2fagcPxJbMCxxEVjSFP-kMMdFZF_vaBkvj0LqKoD6TDDg@mail.gmail.com>
Subject: parent transid verify errors, does mount though, how to recover & proceed
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arch, kernel 4.15.14, btrfs progs 4.15.1.

Had some SATA drives dropout during a long copy.  Now running off live
ISO.  Actually have this issue on a few btrfs volumes, ironically this
happened while implementing a backup system, so looking for best way
forward since it doesn't look like all is lost.

# btrfs check /dev/lvm/persistent1
Checking filesystem on /dev/lvm/persistent1
UUID: 6f3c9e2a-c8bd-40b9-90bb-bf625b50afc0
parent transid verify failed on 55312384 wanted 37252 found 36915
(total of 26 errors, each printed twice, so only 13 unique errors, all
wanting 35252/35253, found 36915, 37247, 36915, 37250, 37249.)

# btrfs-find-root /dev/lvm/persistent1
Superblock thinks the generation is 37256
Superblock thinks the level is 1
Found tree root at 54231040 gen 37256 level 1
Well block 53231616(gen: 37255 level: 1) seems good, but
generation/level doesn't match, want gen: 37256 level: 1
(about 28 "Well block" lines.)

# btrfs check --tree-root 54231040 /dev/lvm/persistent1
(Gives same output as without --tree-root, still 26 parent transid errors)

# btrfs check --tree-root 54231040 --super 1 /dev/lvm/persistent1
using SB copy 1, bytenr 67108864
(Then gives same output as before)

[Q1] - With btrfs-find-root finding a tree root of gen 37256, being a
few higher than all the errors say they want, doesn't that mean this
can be fixed, at least as a temporary mount and copying to another
device?  Why isn't check reflecting that?


# mount -o ro /dev/lvm/persistent1 /mnt/persistent
(mounts fine)

# cd /mnt/persistent && du -kh --max-depth=1
...
BTRFS error (device dm-20): parent transid verify failed on 53198848
wanted 37253 found 37249
BTRFS error (device dm-20): parent transid verify failed on 53215232
wanted 37253 found 37249
BTRFS error (device dm-20): parent transid verify failed on 52314112
wanted 37252 found 37250
BTRFS error (device dm-20): parent transid verify failed on 53035008
wanted 37252 found 37247
858G   ./.snapshots
...

# mount -o ro,usebackuproot /dev/lvm/persistent1 /mnt/persistent
(mounts fine)

# cd /mnt/persistent && du -kh --max-depth=1
(same output as before)

[Q2] - With btrfs-find-root finding a tree root it likes, shouldn't
usebackuproot mount in a way to avoid these errors?


[Q3] - I'm confused why btrfs check shows 13(26) errors , but du only
triggers 4 errors.

[Q4] - Since it mounts and looks decent, what effects do I have?  Am I
seeing old versions of files?  Missing files?  Corrupted file
contents?

[Q5] - Since I have "failed on ###" and can mount, can I track down
which directories/files are affected?

[Q6] - If I copy everything off, do I basically have a good copy of
the contents, with times for each file varying between just before the
SATA dropout and after?

[Q7] - Since it mounts decently, how would you get the best copy of
the data?  I'm assuming btrfs restore doesn't make sense since it
mounts.  Is btrfs send, rsync, anything else going to make any
difference?  Mounted with "usebackuproot or not?
