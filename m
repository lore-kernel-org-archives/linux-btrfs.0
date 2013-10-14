Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from glockenspiel.complete.org ([78.47.53.23]:45772 "EHLO
	glockenspiel.complete.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3JNPks (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 11:40:48 -0400
Received: from [63.245.179.205] (helo=minerva.lan.complete.org)
	by glockenspiel.complete.org with esmtps
	(with TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(TLS peer CN christoph.complete.org, certificate verified)
	(Exim 4.72)
	id 1VVjzf-000524-Tw
	for linux-btrfs@vger.kernel.org; Mon, 14 Oct 2013 10:23:40 -0500
Received: from localhost ([127.0.0.1])
	by minerva.lan.complete.org with esmtp (Exim 4.80)
	(envelope-from <jgoerzen@complete.org>)
	id 1VVjzb-0005uT-Ii
	for linux-btrfs@vger.kernel.org; Mon, 14 Oct 2013 10:23:35 -0500
Message-ID: <525C0C76.9000905@complete.org>
Date: Mon, 14 Oct 2013 10:23:34 -0500
From: John Goerzen <jgoerzen@complete.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Conversion from ext4 fails
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have been seeing this behavior (on the unmounted filesystem, of course!):

date && time btrfs-convert /dev/mapper/bakfs
Sat Oct 12 23:13:21 CDT 2013
creating btrfs metadata.
error during copy_inodes -1
conversion aborted.

real    43m1.076s
user    15m25.256s
sys     0m21.508s

This is 100% reproducible on this volume.  It passes fsck.ext4 -f with 
no errors, and I can detect nothing wrong.  This is on a Debian backport 
of kernel 3.10 on i686 32-bit.  The filesystem in question is 2.7T in 
size, with 908G free.  It is a target for BackupPC, and as such has 
many, many hardlinks and inodes in use due to the BackupPC hardlink 
pool.  Some files may be hardlinked to hundreds of others as well.  (A 
quick spot-guess revealed one with 418 hardlinks.  There may be some 
with more.)  I didn't capture df -ih output when I should have, but the 
number of inodes was between 30M and 40M.  The underlying device is an 
LVM RAID0 across two USB drives - so a slow device, but it has always 
worked perfectly. There are no kernel errors involved here.

The btrfs-tools is 0.19+20130705 plus the patch from 
https://patchwork.kernel.org/patch/2828820/ to address the "No valid 
Btrfs found" bug I encountered, which was reported at 
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=724265 and various 
other places.

What can I do to help with the debugging of this?

Thanks,

John
