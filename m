Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:43437 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbeH3VAO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:00:14 -0400
Received: from mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.26])
        by mailgw-01.dd24.net (Postfix) with ESMTP id 3BEB75FD44
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 16:47:59 +0000 (UTC)
Received: from smtp.dd24.net ([192.168.1.35])
        by mailpolicy-01.live.igb.homer.key-systems.net (mailpolicy-01.live.igb.homer.key-systems.net [192.168.1.25]) (amavisd-new, port 10235)
        with ESMTP id Zy-z8O8nr5Py for <linux-btrfs@vger.kernel.org>;
        Thu, 30 Aug 2018 16:47:57 +0000 (UTC)
Received: from heisenberg-old.fritz.box (ppp-82-135-88-3.dynamic.mnet-online.de [82.135.88.3])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.dd24.net (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 16:47:57 +0000 (UTC)
Message-ID: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
Subject: fsck lowmem mode only: ERROR: errors found in fs roots
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Thu, 30 Aug 2018 18:47:56 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey.

I've the following on a btrfs that's basically the system fs for my
notebook:


When booting from a USB stick with:
# uname -a
Linux heisenberg 4.17.0-3-amd64 #1 SMP Debian 4.17.17-1
(2018-08-18) x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.17

... a lowmem mode fsck gives no error:

# btrfs check --mode=lowmem /dev/mapper/system ; echo $?
Checking filesystem on /dev/mapper/system
UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
checking extents
checking free space cache
checking fs roots
ERROR: errors found in fs roots
found 495910952960 bytes used, error(s) found
total csum bytes: 481840472
total tree bytes: 2388819968
total fs tree bytes: 1651097600
total extent tree bytes: 161841152
btree space waste bytes: 446707102
file data blocks allocated: 6651878428672
 referenced 542320984064
1

... while a normal mode fsck doesn't give one:

# btrfs check /dev/mapper/system ; echo $?
Checking filesystem on /dev/mapper/system
UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
checking extents
checking free space cache
checking fs roots
checking only csum items (without verifying data)
checking root refs
found 495910952960 bytes used, no error found
total csum bytes: 481840472
total tree bytes: 2388819968
total fs tree bytes: 1651097600
total extent tree bytes: 161841152
btree space waste bytes: 446707102
file data blocks allocated: 6651878428672
 referenced 542320984064
0

There were no unusual kernel log messages.


Back in the normal system (no longer USB)... I spottet this:
Aug 30 18:31:29 heisenberg kernel: BTRFS info (device dm-0): the free
space cache file (22570598400) is invalid, skip it

but not sure whether it's related (probably not)... and I haven't seen
such a free space cache file issue (or any other btrfs errors) in a
long while (I usually watch my kernel log once after booting has
finished).


Any ideas? Perhaps it's just yet another lowmem false positive...
anything I can help in debugging this?


Apart from this I haven't noticed any corruptions recently... just
about to make a full backup of the fs (or better said a rw snapshot of
the most of the data) with tar, so most data will be read soon at least
once... an I would probably notice any further errors that are
otherwise silent.


Cheers,
Chris.
