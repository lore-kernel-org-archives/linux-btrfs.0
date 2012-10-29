Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55093 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab2J2MW7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 08:22:59 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so4562710oag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 05:22:59 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 29 Oct 2012 13:22:59 +0100
Message-ID: <CAM4M9rQZbsmiC_xmjAtt+syEmp5_ABMTmSVK0KAoVJwc2yqTwg@mail.gmail.com>
Subject: Old (almost 2 years) btrfs failed fs. Parent transid failure. Can it
 be fixed ?
From: Tommy Jonsson <quazzie@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, i have an old btrfs file-system that crashed on a power-failure
for about 2 years ago.
I talked a bit with Chris Mason at the time and a btrfsck was about to
be released. It never was :-]
But now 2 years later i thought i would give it a try again.
And before you point it out, yes i should have had backup and such but
i didn't as it isn't terrible important data.

Its a 3 disk fs spanning over /dev/sda, sdc, sdd. About 3TB.
I believe it was created like this (default options):
mkfs.btrfs /dev/sda
btrfs device add /dev/sda /dev/sdc
btrfs device add /dev/sda /dev/sdd

i have clone the
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
(at 2012-10-29) and compiled the tools.

sudo mount -t btrfs /dev/sda /mnt/disk/
>mount: wrong fs type, bad option, bad superblock on /dev/sda,
>missing codepage or helper program, or other error
>In some cases useful info is found in syslog - try
>dmesg | tail  or so

dmesg
>[2579559.000820] device fsid 7278c712-5d48-4a73-b40d-6708a45a0b9b devid 3 transid 39651 /dev/sda
>[2579559.035116] parent transid verify failed on 2721514774528 wanted 39651 found 39649
>[2579559.035130] btrfs: failed to read tree root on sda
>[2579559.036887] btrfs: open_ctree failed

/var/syslog
>kernel: [2578915.306144] device fsid 7278c712-5d48-4a73-b40d-6708a45a0b9b devid 3 transid 39651 /dev/sda
>kernel: [2578915.368611] device fsid 7278c712-5d48-4a73-b40d-6708a45a0b9b devid 1 transid 39651 /dev/sdc
>kernel: [2578915.416839] device fsid 7278c712-5d48-4a73-b40d-6708a45a0b9b devid 2 transid 39650 /dev/sdd

sudo ./btrfs-debug-tree /dev/sda
>parent transid verify failed on 2721514774528 wanted 39651 found 39649
>parent transid verify failed on 2721514774528 wanted 39651 found 39649
>Ignoring transid failure
>btrfs-debug-tree: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] == 0)' failed.

sudo ./btrfsck /dev/sda
>parent transid verify failed on 2721514774528 wanted 39651 found 39649
>parent transid verify failed on 2721514774528 wanted 39651 found 39649
>Ignoring transid failure
>btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion `!(path->slots[0] == 0)' failed.

sudo ./btrfs-find-root /dev/sda
>Super think's the tree root is at 2721514774528, chunk root 20971520
>Well block 39415808 seems great, but generation doesn't match, have=39, want=39651
>Well block 42041344 seems great, but generation doesn't match, have=40, want=39651
>Well block 44482560 seems great, but generation doesn't match, have=41, want=39651
>Well block 46776320 seems great, but generation doesn't match, have=42, want=39651
>Well block 49131520 seems great, but generation doesn't match, have=43, want=39651
>Well block 51474432 seems great, but generation doesn't match, have=44, want=39651
>Well block 54140928 seems great, but generation doesn't match, have=45, want=39651
>... snip lots of lines ....
>Well block 2721697734656 seems great, but generation doesn't match, have=36242, want=39651
>Well block 2721698918400 seems great, but generation doesn't match, have=36243, want=39651
>Well block 2721699729408 seems great, but generation doesn't match, have=36244, want=39651
>Well block 2721700720640 seems great, but generation doesn't match, have=36245, want=39651
>Well block 2721701867520 seems great, but generation doesn't match, have=36246, want=39651
>Well block 2721703084032 seems great, but generation doesn't match, have=36247, want=39651
>Well block 2721704181760 seems great, but generation doesn't match, have=36248, want=39651
>No more metdata to scan, exiting

Anyone got any tips or is it time for a format and new start ?
Many thanks!
// Tommy Jonsson
