Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54821 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab3DZR0M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 13:26:12 -0400
Received: from mailout-de.gmx.net ([10.1.76.4]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MFfeF-1UJuQp14bt-00EcSh for
 <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 19:26:10 +0200
Message-ID: <517AB8B1.4030809@gmx.de>
Date: Fri, 26 Apr 2013 19:26:09 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: no space to remove a file
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While running trinity within a user mode linux image which has the same BTRFS filesystem from the host
mounted both via NFS and hostfs (that FS itself was created within a file at a ramdisk at the host side) 
I observed from my control script these messages :

rm: cannot remove ‘/mnt/trinity/w/inux’: No space left on device
rm: cannot remove ‘/mnt/trinity/w/$’: No space left on device
rm: cannot remove ‘/mnt/trinity/w/\211\271\271\340\340\211\211\271\271\340\340\211\211\271\271\340\340\211\211\271\271\340\340\211\211\271\271\340\340\211\211\271\271\340\340\211\211\271\271\340\340\211\211\271\271\340\340\211\n\277’: No space left on device
rm: cannot remove ‘/mnt/trinity/w/\020’: No space left on device
mkdir: cannot create directory ‘/mnt/trinity/w’: File exists
chmod: changing permissions of ‘/mnt/trinity/v/victims’: No space left on device
chmod: changing permissions of ‘/mnt/trinity/v/victims/d01’: No space left on device


Well, the file system is full:
$> df -m
...
/dev/loop0           257   245         9  97% /mnt/trinity

but why does rm fail with that messages ?
And chmod too ?

FWIW host kernel is 3.8.9, UML guest runs 3.9-rc8-..., OS is Gentoo stable at each system.


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
