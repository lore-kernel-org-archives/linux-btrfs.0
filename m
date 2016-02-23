Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50644 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbcBWV7Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 16:59:16 -0500
Received: from svh-gw.merlins.org ([173.11.111.145]:54742 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtps
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1aYKzA-0002OR-F9
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 13:59:15 -0800
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1aYKz9-0003kO-J9
	for linux-btrfs@vger.kernel.org; Tue, 23 Feb 2016 13:59:11 -0800
Date: Tue, 23 Feb 2016 13:59:11 -0800
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20160223215911.GA13811@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Documentation for BTRFS error (device dev): bdev /dev/xx errs: wr
 22, rd 0, flush 0, corrupt 0, gen 0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a freshly created md5 array, with drives that I specifically
scanned one by one block by block, and for good measure, I also scanned
the entire software raid with a check command which took 3 days to run.

Everything passed.

Then, I made a bcache of that device, an ssd that seems to work fine
otherwise (brand new), and dmcrypted the result

md5 - bache - dmcrypt - btrfs
ssd /

Now, I'm copying data over with btrfs send, and I'm seeing these slowly
show up and the write counter go up one by one.
BTRFS error (device dm-7): bdev /dev/mapper/oldds1 errs: wr 17, rd 0, flush 0, corrupt 0, gen 0

Where is the documentation for those counters?
Is the write error fatal, or a recovered error?
Should I consider that my filesystem is corrupted as soon as any of
those counters go up?
(I couldn't find an exact meaning of each of them)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
