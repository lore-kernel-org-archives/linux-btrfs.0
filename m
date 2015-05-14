Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:51688 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbbENMRB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 08:17:01 -0400
Message-ID: <5554923A.1090903@gmx.de>
Date: Thu, 14 May 2015 14:16:58 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: deleting a btrfs subvolume shut up a server
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I created at a 3 TB btrfs formatted disk a btrfs subvolume, unpacked a minimal Gentoo Linux in it, created in addition few files within it under ./tmp and bind mount from the host few files onto those files. If I now delete in another terminal the subvolume - then the server dies immediately

It is a headless server, I had to request a manually reset to get it back.
Nothing in the syslog (syslog-ng 3.6.2) - the server was just shot in he head.

This happened 2 times in a row. Host is a stable hardened Gentoo with 4.0.2 kernel.

:-/

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
--
"; the past is all dirty and cruel in the modern popular imagination, with the exception of the Romans, who are just cruel"
Ian Mortimer, 2008, "The Time Traveller's Guide to Medieval England"
