Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:51011 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755359AbdEKKB6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 06:01:58 -0400
Message-ID: <1494496913.11002.3.camel@gmx.net>
Subject: parent transid verify failed
From: "Massimo B." <massimo.b@gmx.net>
To: linux-btrfs@vger.kernel.org
Date: Thu, 11 May 2017 12:01:53 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

this is some btrfs-on-luks, USB hdd as blockdevice.
I can't mount my btrfs anymore, getting continuously the same syslog error:

- Last output repeated twice -
May 11 07:58:25 [kernel] BTRFS error (device dm-3): failed to read block groups:
-5
May 11 07:58:25 [kernel] BTRFS error (device dm-3): open_ctree failed
May 11 07:58:31 [kernel] BTRFS info (device dm-3): use zlib compression
May 11 07:58:31 [kernel] BTRFS info (device dm-3): enabling auto defrag
May 11 07:58:31 [kernel] BTRFS info (device dm-3): disk space caching is enabled
May 11 07:58:31 [kernel] BTRFS info (device dm-3): has skinny extents
May 11 07:58:33 [kernel] BTRFS error (device dm-3): parent transid verify failed
on 541635395584 wanted 10388 found 10385

This is the last part of btrfs check --repair (I know, highly experimental, but
I didn't get an alternative solution on #btrfs) :

rent transid verify failed on 541577035776 wanted 10388 found 10384
parent transid verify failed on 541577035776 wanted 10388 found 10384
parent transid verify failed on 541577035776 wanted 10388 found 10384
parent transid verify failed on 541577035776 wanted 10388 found 10384
parent transid verify failed on 541577035776 wanted 10388 found 10384
Chunk[256, 228, 429526089728]: length(1073741824), offset(429526089728), type(1)
is not found in block group
Chunk[256, 228, 430599831552]: length(1073741824), offset(430599831552), type(1)
is not found in block group
Chunk[256, 228, 431673573376]: length(1073741824), offset(431673573376), type(1)
is not found in block group
Chunk[256, 228, 434894798848]: length(1073741824), offset(434894798848), type(1)
is not found in block group
Chunk[256, 228, 435968540672]: length(1073741824), offset(435968540672), type(1)
is not found in block group
Chunk[256, 228, 437042282496]: length(1073741824), offset(437042282496), type(1)
is not found in block group
Chunk[256, 228, 438116024320]: length(1073741824), offset(438116024320), type(1)
is not found in block group
ref mismatch on [429497528320 40960] extent item 0, found 1
Backref 429497528320 parent 858210304 owner 0 offset 0 num_refs 0 not found in
extent tree
Incorrect local backref count on 429497528320 parent 858210304 owner 0 offset 0
found 1 wanted 0 back 0x37aaefc0
backpointer mismatch on [429497528320 40960]
parent transid verify failed on 541635395584 wanted 10388 found 10385
Ignoring transid failure
Failed to find [541635395584, 168, 16384]
btrfs unable to find ref byte nr 541635395584 parent 0 root 2  owner 1 offset 0
failed to repair damaged filesystem, aborting

How did that happen?
Yesterday I sent a big snapshot from local drive to a slower USB drive via
btrbk. That was  already finished. However the USB drive was completely filled
up to 99% and doing some IO apparently. Then I was not able to shutdown the
machine. Shutdown was really slow, finally umounts were accomplished, services
stopped, system shutdown almost finished, but no shutdown. I did a Sysreq- E I U
S R B, no reboot. Sysreq-O did not even shut off. So as last consequence I
disconnected power supply.

The broken btrfs is actually only a snapshot receiver as backup. I would prefer
to get it repaired. Seeing that btrfs is sensitive about filling up to 99%
usage, I'm worried about my production btrfs.

This is Gentoo-Linux, 4.10.14-ck, btrfs-progs-4.10.2.

Best regards,
Massimo
