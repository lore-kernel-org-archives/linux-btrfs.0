Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:32996 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbbFTO3j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jun 2015 10:29:39 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout3.freenet.de with esmtpa (ID lutz.euler@freenet.de) (port 25) (Exim 4.82 #2)
	id 1Z6JWk-0006y7-RP
	for linux-btrfs@vger.kernel.org; Sat, 20 Jun 2015 16:13:46 +0200
Received: from localhost ([::1]:42150 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID lutz.euler@freenet.de) (Exim 4.82 #2)
	id 1Z6JWk-0004KL-Mt
	for linux-btrfs@vger.kernel.org; Sat, 20 Jun 2015 16:13:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21893.29830.540787.159202@localhost.localdomain>
Date: Sat, 20 Jun 2015 16:11:18 +0200
From: lutz.euler@freenet.de (Lutz Euler)
To: Christian <cdysthe@gmail.com>, Paul Jones <paul@pauljones.id.au>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: trim not working and irreparable errors from btrfsck
In-Reply-To: <B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
	<5581ABA2.30906@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Christian, Paul and Austin,

Christian wrote:
> However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be
> another problem. Is there a way to check if trim works?

Paul wrote:
> I've got the same problem. I've got 2 SSDs with 2 partitions in RAID1,
> fstrim always works on the 2nd partition but not the first. There are
> no errors on either filesystem that I know of, but the first one is
> root so I can't take it offline to run btrfs check.

Austin wrote:
> I'm seeing the same issue here, but with a Crucial brand SSD.
> Somewhat interestingly, I don't see any issues like this with BTRFS on
> top of LVM's thin-provisioning volumes, or with any other filesystems,
> so I think it has something to do with how BTRFS is reporting unused
> space or how it is submitting the discard requests.

Probably you all suffer from the same problem I had a few years ago.
It is a bug in how btrfs implements fstrim.

To check whether you are a victim of this bug simply run:

# btrfs-debug-tree /dev/whatever | grep 'FIRST_CHUNK_TREE CHUNK_ITEM'

where /dev/whatever is a device of your filesystem, and interrupt after
the first several output lines with C-c. (Officially the filesystem
should be unmounted when running btrfs-debug-tree, but that is not
necessary as we only read from it and the relevant data doesn't change
very often.)

You get something like:

  item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 0)
  item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 12947816448)
  item 4 key (FIRST_CHUNK_TREE CHUNK_ITEM 14021558272)
  ...

(This output is from an old version of btrfs-progs. I understand newer
version are more verbose, but you should nevertheless easily be able to
interpret the output).

If the first number different from 0 (here, the 12947816448) is larger
than the sum of the sizes of the devices the filesystem consists of,
bingo.

This has been discussed already in the past and there is a patch.

Please see for the patch:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40618.html

and for the background:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/15597

Kind regards,

Lutz Euler
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
