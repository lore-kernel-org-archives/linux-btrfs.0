Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-pro1.mana.pf ([202.3.225.198]:47247 "EHLO
	smtp-pro1.mana.pf" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaH0SNm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 14:13:42 -0400
Received: from tiare.sysnux.pf (75.173.185.203.dsl.dyn.mana.pf [203.185.173.75])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: courrier@sysnux.pf)
	by smtp-pro1.mana.pf (Postfix) with ESMTPSA id 2B0265409D
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 08:04:35 -1000 (TAHT)
Received: from tiare.sysnux.pf (tiare.sysnux.pf [192.168.10.1])
	by tiare.sysnux.pf (Postfix) with ESMTP id 04EF3C0284
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Aug 2014 08:04:35 -1000 (TAHT)
Message-ID: <53FE1DB2.8040900@sysnux.pf>
Date: Wed, 27 Aug 2014 08:04:34 -1000
From: Jean-Denis Girard <jd.girard@sysnux.pf>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Undelete files / directory
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi list,

Two days ago I mistakenly deleted a directory on a btrfs file system. As
soon as I realized, I cleanly unmounted the partition, and have not
touched it since then. I have no snapshot and no backup; I was on
vacations with my laptop, and the directory deleted contained ~3 weeks
of photos.

I found this script:
http://comments.gmane.org/gmane.comp.file-systems.btrfs/22560
but the commands have probably changed, and it no longer runs.

So is there a way to recover a deleted directory on btrfs? Just to make
things clear, this is not a broken file system, just a normally deleted
directory.

I'm on Fedora 20, with kernel 3.15.10-200.fc20.x86_64, and
btrfs-progs-3.14.2-3.fc20.x86_64.


Thanks,
- -- 
Jean-Denis Girard

SysNux                  Systèmes    Linux    en  Polynésie  française
http://www.sysnux.pf/   Tél: +689 40.50.10.40 / GSM: +689 87.79.75.27
-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlP+HbIACgkQuu7Rv+oOo/hH7wCdFJhYm4eFwU5TbUyrdWM4iIuP
aqQAn2H3D0dvEznBhgyij8Pn8Ww6XQF5
=ybUk
-----END PGP SIGNATURE-----
