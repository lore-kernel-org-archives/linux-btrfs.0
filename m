Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail2.aei.mpg.de ([194.94.224.8]:60522 "EHLO umail2.aei.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751033AbdA3UKV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 15:10:21 -0500
Received: from mailgate.aei.mpg.de (mailgate.aei.mpg.de [194.94.224.5])
        by umail2.aei.mpg.de (Postfix) with ESMTP id CFAB01BA62B3
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 21:02:14 +0100 (CET)
Received: from mailgate.aei.mpg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id B669C406ADE
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 21:02:14 +0100 (CET)
Received: from intranet.aei.uni-hannover.de (ahin1.aei.uni-hannover.de [130.75.117.40])
        by mailgate.aei.mpg.de (Postfix) with ESMTP id 7BE57406ADB
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 21:02:14 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Michael Born <Michael.Born@aei.mpg.de>
Subject: btrfs recovery
Message-ID: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
Date: Mon, 30 Jan 2017 21:02:13 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs experts.

Hereby I apply for the stupidity of the month award.
But, maybe you can help me restoring my dd backup or extracting some
files from it?

Before switching from Suse 13.2 to 42.2, I copied my / partition with dd
to an image file - while the system was online/running.
Now, I can't mount the image.

I tried many commands (some output is below) that are suggested in the
wiki or blog pages without any success.
Unfortunately, the promising tool btrfs-find-root seems not to work. I
let it run on backup1.dd for 16 hours with the only output being:
./btrfs-find-root /dev/loop0
Couldn't read tree root
Superblock thinks the generation is 550114
Superblock thinks the level is 1

I then stopped it manually. (The 60GB dd file is on a ssd and one cpu
core was at 100% load all night)
I also tried the git clone of btrfs-progs which I checked out (the
tagged versions 4.9, 4.7, 4.4, 4.1) and compiled. I always got the
btrfs-find-root output as shown above.

Could you give me some instructions how to repair the file system or
extract some files from it?

Thank you,
Michael

PS: could you please CC me, as I'm not subscribed to the list.

Some commands and their output.

mount -t btrfs -o recovery,ro /dev/loop0 /mnt/oldroot/
mount: Falscher Dateisystemtyp, ungültige Optionen, der
Superblock von /dev/loop0 ist beschädigt, fehlende
Kodierungsseite oder ein anderer Fehler

dmesg -T says:
[Mo Jan 30 01:08:20 2017] BTRFS info (device loop0): enabling auto recovery
[Mo Jan 30 01:08:20 2017] BTRFS info (device loop0): disk space caching
is enabled
[Mo Jan 30 01:08:20 2017] BTRFS error (device loop0): bad tree block
start 0 32865271808
[Mo Jan 30 01:08:20 2017] BTRFS: failed to read tree root on loop0
[Mo Jan 30 01:08:20 2017] BTRFS error (device loop0): bad tree block
start 0 32865271808
[Mo Jan 30 01:08:20 2017] BTRFS: failed to read tree root on loop0
[Mo Jan 30 01:08:20 2017] BTRFS error (device loop0): bad tree block
start 0 32862011392
[Mo Jan 30 01:08:20 2017] BTRFS: failed to read tree root on loop0
[Mo Jan 30 01:08:20 2017] BTRFS error (device loop0): parent transid
verify failed on 32869482496 wanted 550112 found 550121
[Mo Jan 30 01:08:20 2017] BTRFS: failed to read tree root on loop0
[Mo Jan 30 01:08:20 2017] BTRFS error (device loop0): bad tree block
start 0 32865353728
[Mo Jan 30 01:08:20 2017] BTRFS: failed to read tree root on loop0
[Mo Jan 30 01:08:20 2017] BTRFS: open_ctree failed

---

btrfs fi show
Label: none  uuid: 1c203c00-2768-4ea8-9e00-94aba5825394
        Total devices 1 FS bytes used 29.28GiB
        devid    1 size 60.00GiB used 32.07GiB path /dev/sda2

Label: none  uuid: 91a79eeb-08e0-470e-beab-916b38e09aca
        Total devices 1 FS bytes used 44.23GiB
        devid    1 size 60.00GiB used 60.00GiB path /dev/loop0

The 1st one is my now running Suse 42.2 /

---

btrfs check /dev/loop0
checksum verify failed on 32865271808 found E4E3BDB6 wanted 00000000
checksum verify failed on 32865271808 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=32865271808, have=0
Couldn't read tree root
ERROR: cannot open file system

---

./btrfs restore -l /dev/loop0
checksum verify failed on 32865271808 found E4E3BDB6 wanted 00000000
checksum verify failed on 32865271808 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=32865271808, have=0
Couldn't read tree root
Could not open root, trying backup super
checksum verify failed on 32865271808 found E4E3BDB6 wanted 00000000
checksum verify failed on 32865271808 found E4E3BDB6 wanted 00000000
bytenr mismatch, want=32865271808, have=0
Couldn't read tree root
Could not open root, trying backup super
ERROR: superblock bytenr 274877906944 is larger than device size 64428703744
Could not open root, trying backup super

---

uname -a
Linux linux-azo5 4.4.36-8-default #1 SMP Fri Dec 9 16:18:38 UTC 2016
(3ec5648) x86_64 x86_64 x86_64 GNU/Linux
