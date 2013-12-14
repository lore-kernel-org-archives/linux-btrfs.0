Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:54289 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3LNKQE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 05:16:04 -0500
Received: from pannekake.samfundet.no ([2001:67c:29f4::50] ident=unknown)
	by cassarossa.samfundet.no with esmtps (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1VrmGL-0004Y9-4q
	for linux-btrfs@vger.kernel.org; Sat, 14 Dec 2013 11:16:01 +0100
Received: from sesse by pannekake.samfundet.no with local (Exim 4.80)
	(envelope-from <sesse@samfundet.no>)
	id 1VrmGK-0006ZT-Oz
	for linux-btrfs@vger.kernel.org; Sat, 14 Dec 2013 11:15:56 +0100
Date: Sat, 14 Dec 2013 11:15:56 +0100
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: linux-btrfs@vger.kernel.org
Subject: Assertion failure in btrfsck
Message-ID: <20131214101556.GA24427@sesse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm having a filesystem that's been a bit mangled by external causes,
so I thought I'd see how much I could salvage (it's not critical, though).
Thus, I pulled btrfsck from git and ran:

  pannekake:~/btrfs-progs# ./btrfsck --repair /dev/mapper/pannekake-backup-btrfs

It spit out a ton of warnings like these (I can get the whole log if you're
interested):

  parent transid verify failed on 7007735808 wanted 8322 found 8856
  Ignoring transid failure
  parent transid verify failed on 2895847424 wanted 8184 found 8818
  Ignoring transid failure
  parent transid verify failed on 7007735808 wanted 8322 found 8856
  Ignoring transid failure
  parent transid verify failed on 2895847424 wanted 8184 found 8818
  Ignoring transid failure
  parent transid verify failed on 7007735808 wanted 8322 found 8856
  Ignoring transid failure
  parent transid verify failed on 2895847424 wanted 8184 found 8818
  Ignoring transid failure

and then died with

  btrfsck: cmds-check.c:2212: check_owner_ref: Assertion `!(rec->is_root)' failed.
  Aborted

I assume this is a bug in btrfsck. :-) What more information do you need from
me to be able to look at this? The filesystem is a bit too big (550GB) to
transfer easily.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
