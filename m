Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zebra708.server4you.de ([188.138.112.148]:39399 "EHLO
	niklasfi.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaJAUjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 16:39:32 -0400
Received: from localhost.localdomain (p4FD46CD6.dip0.t-ipconnect.de [79.212.108.214])
	by niklasfi.de (Postfix) with ESMTPSA id 80451194002F
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Oct 2014 22:30:01 +0200 (CEST)
Message-ID: <542C6443.1010809@niklasfi.de>
Date: Wed, 01 Oct 2014 22:29:55 +0200
From: Niklas Fischer <niklas@niklasfi.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs check segfaults after flipping 2 Bytes
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I was trying to determine how btrfs reacts to disk errors, when I
discovered, that flipping two Bytes, supposedly inside of a file can
render the filesystem unusable. Here is what I did:

1. dd if=/dev/zero of=/dev/sdg2 bs=1M
2. mkfs.btrfs /dev/sdg2
3. mount /dev/sdg2 /tmp/btrfs
4. echo "hello world this is some text" > /tmp/btrfs/hello
5. umount /dev/sdg2

this should result in this image [1]

in the following steps /dev/sdg2 is altered. Basically, we want to apply
s/world/wirld/g

6. dd if=/dev/sdg2 of=/tmp/sdg2 bs=1M
7. edit /tmp/sdg2 in ghex, find & replace all occurences of "world" with
"wirld" (two occurences found), save as /tmp/sdg2_new
8. dd if=/tmp/sdg2_new of=/dev/sdg2 bs=1M

/dev/sdg2 now looks like this [2]

now, when I try mounting /dev/sdg2:

"""22:21 root@localhost ~#
LANG=EN mount /dev/sdg2 /tmp/btrfs/
mount: mount /dev/sdg2 on /tmp/btrfs failed: Cannot allocate memory"""

ok, so let us try btrfs check

"""22:21 root@localhost ~#
LANG=EN btrfs check /dev/sdg2
checksum verify failed on 4222976 found F22E71BD wanted CE334502
checksum verify failed on 4222976 found F22E71BD wanted CE334502
Csum didn't match
Checking filesystem on /dev/sdg2
UUID: ea2843f1-e8aa-420f-acf8-6ef13f6c6753
checking extents
Speicherzugriffsfehler (Speicherabzug geschrieben)"""

that last line reads "Segfault, memory dumped". Is this behaviour expected?

Kind regards,
Niklas

[1] tgz: https://gigamove.rz.rwth-aachen.de/d/id/R5CKikxbYTBdqs
    raw: https://gigamove.rz.rwth-aachen.de/d/id/VgMXAicS7CGEjt
[2] tgz: https://gigamove.rz.rwth-aachen.de/d/id/cEebNYne9ppFy4
    raw: https://gigamove.rz.rwth-aachen.de/d/id/ATJa7wpfEWdfL2
