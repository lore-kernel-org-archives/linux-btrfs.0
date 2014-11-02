Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60677 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbaKBPSl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Nov 2014 10:18:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XkwvQ-0008Pk-KP
	for linux-btrfs@vger.kernel.org; Sun, 02 Nov 2014 16:18:40 +0100
Received: from hsi-kbw-149-172-191-171.hsi13.kabel-badenwuerttemberg.de ([149.172.191.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Nov 2014 16:18:40 +0100
Received: from mailinglists by hsi-kbw-149-172-191-171.hsi13.kabel-badenwuerttemberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Nov 2014 16:18:40 +0100
To: linux-btrfs@vger.kernel.org
From: Florian Lindner <mailinglists@xgm.de>
Subject: Can't mount: open_ctree failed!
Date: Sun, 02 Nov 2014 16:18:27 +0100
Message-ID: <m35i04$u5p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

all after sudden I can't mount my btrfs home partition anymore. System is 
Arch with kernel 3.17.2, but I use snapper which does snapshopts regularly 
and I had 3.17.1 before, which afaik had some problems with snapshops.

Trying to mount without any options gives to the syslog:

Nov 02 16:04:16 horus kernel: BTRFS: mismatching generation and 
generation_v2 found in root item. This root was probably mounted with an 
older kernel. Resetting all new fields.
Nov 02 16:04:16 horus kernel: parent transid verify failed on 2121534193664 
wanted 1073784832 found 45541
Nov 02 16:04:16 horus kernel: parent transid verify failed on 2121534193664 
wanted 1073784832 found 45541
Nov 02 16:04:16 horus kernel: BTRFS: open_ctree failed

btrfsck quits after about half a minute with

# btrfsck /dev/sdb1
root item for root 3377, current bytenr 2122078191616, current gen 
8589934592, current level 64, new bytenr 2122078191616, new gen 49443, new 
level 1
root 3377 has a root item with a more recent gen (8589934592) compared to 
the found root node (49443)

I also tried -s 0 or -s 1 or -b options to btrfsck, as well as

# btrfsck --init-extent-tree /dev/sdb1
root 3377 has a root item with a more recent gen (8589934592) compared to 
the found root node (49443)

# btrfsck --init-csum-tree /dev/sdb1
Creating a new CRC tree
root 3377 has a root item with a more recent gen (8589934592) compared to 
the found root node (49443)


Mounting with -o recovery gives exact the same error. My usual mount options 
were defaults,compress=lzo,subvol=__current.

I also tried btrfs-zero-log but this does not change anything either.

Any ideas are deeply appreciated! Please help!

Florian 

