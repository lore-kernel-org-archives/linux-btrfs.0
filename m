Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from img2.mail.strath.ac.uk ([130.159.228.47]:65252 "EHLO
	img2.mail.strath.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbbCYJBD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 05:01:03 -0400
Received: from mailread-e.mail.strath.ac.uk ([130.159.16.86]:45555 helo=cc-mail-hub.mail.strath.ac.uk)
	by campus-mail-hub2.mail.strath.ac.uk with esmtp (Exim 4.70 #0 c=4.48.cmh)
	id 1Yaggh-0009sw-BJ
	for <linux-btrfs@vger.kernel.org> (return-path <ian.gordon@strath.ac.uk>); Wed, 25 Mar 2015 08:29:19 +0000
Received: from pc-ig2.cis.strath.ac.uk ([130.159.184.85]:38781)
	by cc-mail-hub.mail.strath.ac.uk with esmtpsa
	(Cipher TLSv1:AES128-SHA:128) (Exim 4.69 #1)
	id 1Yaggg-0004N4-Ur with auth_plain_dc
	for <linux-btrfs@vger.kernel.org> (return-path <ian.gordon@strath.ac.uk>); Wed, 25 Mar 2015 08:29:18 +0000
Message-ID: <551271DE.9020609@strath.ac.uk>
Date: Wed, 25 Mar 2015 08:29:18 +0000
From: Ian Gordon <ian.gordon@strath.ac.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs-transacti causing IO problem to btrfs
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello,

I have a btrfs filesystem which has been working ok for about 90days,
but on Monday it become very slow (takes about 6hours to rsync backup a
3GB Ubuntu server - despite minimal changes from previous backup). I
noticed, that even with no processes reading or writing to the
filesystem, that btrfs-transaci was writing to the disk (averaging at
about 5MB/s) for a few hours before stopping until I wrote to the
filesystem again and then the process would repeat.

The btrfs filesystem uses skinny-metadata and is mounted with relatime
It has 744 subvolumes (of which about 700 are readonly snapshots)

Any ideas? Is there some sort of cleanup getting automatically run in
the background?

 * Linux hutton-cis.cc.strath.ac.uk 3.16.0-30-generic #40~14.04.1-Ubuntu
SMP Thu Jan 15 17:43:14 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
 * Btrfs v3.12
 * Label: none  uuid: a3e49694-a66d-4c0d-b5bd-d2b7ced68535
	Total devices 1 FS bytes used 4.59TiB
	devid    1 size 8.76TiB used 4.77TiB path /dev/dm-0
 * Data, single: total=4.41TiB, used=4.41TiB
   System, DUP: total=8.00MiB, used=544.00KiB
   System, single: total=4.00MiB, used=0.00
   Metadata, DUP: total=186.00GiB, used=184.17GiB
   Metadata, single: total=8.00MiB, used=0.00
   unknown, single: total=512.00MiB, used=16.30MiB
 * There is nothing logged in dmesg except for the standard boot
   messages

Thanks for any help anyone can be,

-- 
Ian Gordon,
Department of Computer and Information Sciences,
University of Strathclyde.
Tel: 0141 548 3592    Fax: 0141 548 4523        Room: LT1307
The University of Strathclyde is a charitable body, registered in
Scotland, with registration number SC015263.
