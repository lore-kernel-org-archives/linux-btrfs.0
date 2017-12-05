Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:37707 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdLETWe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Dec 2017 14:22:34 -0500
Received: by mail-qt0-f181.google.com with SMTP id f2so3430951qtj.4
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Dec 2017 11:22:34 -0800 (PST)
MIME-Version: 1.0
From: Benjamin Beichler <hadrian2002@googlemail.com>
Date: Tue, 5 Dec 2017 19:22:13 +0000
Message-ID: <CABi++uJj6x=ZT1QbB7vu5Zh3_Mf6nsLNMAO9QXNLEBQN_ngoYA@mail.gmail.com>
Subject: Chunk-Recovery fails with alignment error
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a setup as following:  (1,7TB drive + 128GB SSD in Bcache) <==>
luks device <==> btrfs FS
I have been running Arch linux with newest stable kernel 4.14.

After a reboot last week my btrfs volume becomes unmountable, because
of checksum errors in the chunk root.

These are the outputs of check:
"btrfs check /dev/mapper/root

checksum verify failed on 131072 found 1A98EC4A wanted B97166DB
checksum verify failed on 131072 found 1A98EC4A wanted B97166DB
bytenr mismatch, want=131072, have=9229526874648754029
ERROR: cannot read chunk root
ERROR: cannot open file system
"

Most other check/repair commands fail with the same error. The
super-dump can be found here:
https://gist.github.com/anonymous/33bd22696c37355c6cfd093f4c6bd226

 After my attempts in initramfs failed I used a recent arch-live disk
to compile newest btrfs-tools and use recent kernel (4.9) to recover
the chunk tree.

Therefore I ran the chunk recover command on my drive.  It looks like
the following here>
https://gist.github.com/anonymous/5359c08734cf81ad3887b635536d9631

for better debugging I already used gdb to inspect the following error:

"ERROR: tree block bytenr 0 is not aligned to sectorsize 4096"

but as the exception raise is far to late to inspect the problem.
Since most of my chunks seems to be recoverable, I hope a tree rebuild
is possible, but I don't know how.

Do you have any suggestions?
