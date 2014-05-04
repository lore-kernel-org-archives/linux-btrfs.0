Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33870 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaEDFqK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 01:46:10 -0400
Received: from i118-21-136-4.s30.a048.ap.plala.or.jp ([118.21.136.4]:31718 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WgpFY-0000am-PU by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sat, 03 May 2014 22:46:08 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1Wgmqx-0000t0-Fk
	for linux-btrfs@vger.kernel.org; Sat, 03 May 2014 20:12:35 -0700
Date: Sat, 3 May 2014 20:12:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Copying related snapshots to another server with btrfs send/receive?
Message-ID: <20140504031231.GG9061@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another question I just came up with.

If I have historical snapshots like so:
backup
backup.sav1
backup.sav2
backup.sav3

If I want to copy them up to another server, can btrfs send/receive
let me copy all of the to another btrfs pool while keeping the
duplicated block relationship between all of them?
Note that the backup.sav dirs will never change, so I won't need
incremental backups on those, just a one time send.
I believe this is supposed to work, correct?

The only part I'm not clear about is am I supposed to copy them all at
once in the same send command, or one by one?

If they had to be copied together and if I create a new snapshot of
backup: backup.sav4

If I use btrfs send to that same destination, is btrfs send/receive indeed 
able to keep the shared block relationship?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
