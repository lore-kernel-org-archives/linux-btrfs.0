Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58090 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3IANLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Sep 2013 09:11:07 -0400
Received: by mail-pb0-f45.google.com with SMTP id mc17so3700216pbc.32
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Sep 2013 06:11:07 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 1 Sep 2013 06:11:06 -0700
Message-ID: <CAN05THSkyG+2PT9oW6jq5JLpPu8308+KoOp1Nrtnsk2xOCg9TA@mail.gmail.com>
Subject: Unmountable filesystem parent transid verify failed
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again.
Sorry for top posting.


I have a 9 disk filesystem that does not mount anymore and need some
help/advice so I can recover the data.

What happened was that I was running a btrfs delete device
under Ubuntu 13.04   Kernel 3.8
and after a long time of moving data around it crashed with a SEGV.

Now the filesystem does not mount and none of the recovery options I
have tried work.

I have upgraded to Debian testing and are now using kerne3.10-2-amd64



When I try btrfsck I get heaps of these :
Ignoring transid failure
parent transid verify failed on 24419581267968 wanted 301480 found 301495
parent transid verify failed on 24419581267968 wanted 301480 found 301495
parent transid verify failed on 24419581267968 wanted 301480 found 301495
parent transid verify failed on 24419581267968 wanted 301480 found 301495


I have tried using btrfs-image :
but it too crashes eventually with :

btrfs-image -c9 -t4 /dev/sde btrfs-image
...
btrfs-image: ctree.c:787: read_node_slot: Assertion `!(level == 0)' failed.
Aborted


mount -o ro,recovery fails
# mount -o ro,recovery /dev/sde /DATA
mount: wrong fs type, bad option, bad superblock on /dev/sde,
...


# btrfs-zero-log /dev/sde
eventually fails with :
btrfs-zero-log: ctree.c:342: __btrfs_cow_block: Assertion
`!(btrfs_header_generation(buf) > trans->transid)' failed.
Aborted


What should I try next?


regards
ronnie sahlberg
