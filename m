Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55343 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3C0IbX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 04:31:23 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id E9832255484
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 19:31:22 +1100 (EST)
From: Russell Coker <russell@coker.com.au>
Reply-To: russell@coker.com.au
To: linux-btrfs@vger.kernel.org
Subject: btrfsck infinite loop
Date: Wed, 27 Mar 2013 19:31:17 +1100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201303271931.17861.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=703474

The above Debian bug report has the details of a btrfsck infinite loop problem 
I'm having.  I initially reported it as an i386 bug because it didn't seem to 
appear on AMD64.  But then I realised that on AMD64 it merely runs for longer 
before looping.

git pull http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git

I've just used the above command to get the latest btrfsck source, compiled it 
and run it.  The resulting btrfsck has now used 97 minutes of CPU time which 
is about 94 minutes since the last time it gave any output.

Below is the last output of btrfsck before it entered the 100% CPU loop.

leaf parent key incorrect 566530048
bad block 566530048
leaf parent key incorrect 566534144
bad block 566534144
leaf parent key incorrect 566538240
bad block 566538240
leaf parent key incorrect 566542336
bad block 566542336
leaf parent key incorrect 566546432
bad block 566546432
leaf parent key incorrect 566550528
bad block 566550528
leaf parent key incorrect 566554624
bad block 566554624
leaf parent key incorrect 566558720
bad block 566558720
leaf parent key incorrect 566579200
bad block 566579200
leaf parent key incorrect 567844864
bad block 567844864
leaf parent key incorrect 567853056
bad block 567853056

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
