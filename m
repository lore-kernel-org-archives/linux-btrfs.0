Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from voltaic.bi-co.net ([134.119.3.22]:60433 "EHLO voltaic.bi-co.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbcDMSzT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Apr 2016 14:55:19 -0400
Received: from bevan-thinkpad (ip-84-118-255-245.unity-media.net [84.118.255.245])
	by voltaic.bi-co.net (Postfix) with ESMTPSA id 5BD1820347
	for <linux-btrfs@vger.kernel.org>; Wed, 13 Apr 2016 20:48:06 +0200 (CEST)
Message-ID: <1460573285.3688.19.camel@bi-co.net>
Subject: Broken file system after sudden power off
From: Michael =?ISO-8859-1?Q?La=DF?= <bevan@bi-co.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Wed, 13 Apr 2016 20:48:05 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

recently I had a bit of a file system corruption after a sudden system
power off. I could fix the file system using btrfsck but before that I
dumped the FS to allow finding the root cause if this turns out to be a
bug.

My system is running Linux 4.5.0 and the file system lies on top of dm-
crypt and LVM, so the hierarchy looks like the following:
btrfs > dm-crypt > LVM LV > SINGLE PV = MBR partition > SSD

After the sudden power off the issue initially showed up as a non-
responsive system. I booted into a recovery system and issued btrfsck.
Here's the output:

checking extents
checking free space cache
checking fs roots
root 259 inode 37727 errors 200, dir isize wrong
root 259 inode 37820 errors 200, dir isize wrong
root 259 inode 1890803 errors 1, no inode item
	unresolved ref dir 37727 index 122063 namelen 8 name Channels filetype 1 errors 5, no dir item, no inode ref
root 259 inode 1890826 errors 1, no inode item
	unresolved ref dir 37820 index 95273 namelen 17 name TransportSecurity filetype 1 errors 5, no dir item, no inode ref
found 68391559241 bytes used err is 1
total csum bytes: 63782984
total tree bytes: 2501541888
total fs tree bytes: 2308063232
total extent tree bytes: 108118016
btree space waste bytes: 482660866
file data blocks allocated: 693883981824
 referenced 101900402688

Both, "Channels" and "TransportSecurity", are part of a chromium
profile and in fact the system got unresponsive as soon as chromium was
started. A "btrfsck --repair" got rid of these errors.

When mounting the image of the broken file system on another system, I
see that "Channels" and "TransportSecurity" are listed twice in an ls
on the corresponding directory. Also the following message appears in
dmesg:
init_special_inode: bogus i_mode (0) for inode loop0:1890816

If you want any more information on this I've still got the image of
the broken file system and I'd be glad to assist.

Cheers,
Michael
