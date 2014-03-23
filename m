Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52623 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaCWHBw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 03:01:52 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:38097 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WRcPh-0005LB-CY by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 00:01:51 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WRcPg-0007LM-Jk
	for linux-btrfs@vger.kernel.org; Sun, 23 Mar 2014 00:01:44 -0700
Date: Sun, 23 Mar 2014 00:01:44 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140323070144.GG12833@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: ERROR: error during balancing '.' - No space left on device
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

legolas:/mnt/btrfs_pool2# btrfs balance .
ERROR: error during balancing '.' - No space left on device
There may be more info in syslog - try dmesg | tail
[ 8454.159635] BTRFS info (device dm-1): relocating block group 288329039872 flags 1
[ 8590.167294] BTRFS info (device dm-1): relocating block group 232494465024 flags 1
[ 9200.801177] BTRFS info (device dm-1): relocating block group 85928706048 flags 1
[ 9533.830623] BTRFS info (device dm-1): 824 enospc errors during balance

But:
legolas:/mnt/btrfs_pool2# btrfs fi show `pwd`
Label: btrfs_pool2  uuid: 6afd4707-876c-46d6-9de2-21c4085b7bed
	Total devices 1 FS bytes used 646.41GiB
	devid    1 size 820.45GiB used 820.45GiB path /dev/mapper/disk2
Btrfs v3.12
legolas:/mnt/btrfs_pool2# 
Data, single: total=800.42GiB, used=636.91GiB
System, DUP: total=8.00MiB, used=92.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=10.00GiB, used=9.50GiB
Metadata, single: total=8.00MiB, used=0.00

I can't see how I'm full, and now that I can't run balance to fix
things, this is making things worse.
Kernel is 3.14.

What am I missing?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
