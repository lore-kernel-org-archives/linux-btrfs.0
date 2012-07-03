Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33215 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2GCPKU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 11:10:20 -0400
Received: from mfilter3-d.gandi.net (mfilter3-d.gandi.net [217.70.178.133])
	by relay3-d.mail.gandi.net (Postfix) with ESMTP id A95F7A80F7
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2012 17:10:18 +0200 (CEST)
Received: from relay3-d.mail.gandi.net ([217.70.183.195])
	by mfilter3-d.gandi.net (mfilter3-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id s7ByeFtFDha9 for <linux-btrfs@vger.kernel.org>;
	Tue,  3 Jul 2012 17:10:17 +0200 (CEST)
Received: from [192.168.5.100] (unknown [90.84.144.221])
	(Authenticated sender: swami@petaramesh.org)
	by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 70AF8A80D5
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Jul 2012 17:10:16 +0200 (CEST)
Message-ID: <4FF30B55.6060205@petaramesh.org>
Date: Tue, 03 Jul 2012 17:10:13 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: BTRFS fsck apparent errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

A couple days ago, I have converted my Ubuntu Precise machine from ext4 
to BTRFS using btrfs-convert.

I currently use kernel:
Linux fnix 3.2.0-26-generic #41-Ubuntu SMP Thu Jun 14 17:49:24 UTC 2012 
x86_64 x86_64 x86_64 GNU/Linux

...and a btrfs-tools package more recent than the old one that came with 
Ubuntu Precise:
Version: 0.19+20120328-4ubuntu1

After I had shifted, I tried to defragment and compress my FS using 
commands such as :

find /mnt/STORAGEFS/STORAGE/ -exec btrfs fi defrag -clzo -v {} \;

During execution of such commands, my kernel oopsed, so I restarted.

Afterwards, I noticed that, during the execution of such a command, my 
FS free space was quickly dropping, where I would have expected it to 
increase...

Once finished, I checked a couple of BTRFS FSes using btrfsck, but I 
interpret the results as having some errors :

root@fnix:/# btrfsck /dev/VG1/DEBMINT
checking extents
checking fs roots
root 256 inode 257 errors 800
found 7814565888 bytes used err is 1
total csum bytes: 6264636
total tree bytes: 394928128
total fs tree bytes: 365121536
btree space waste bytes: 101451531
file data blocks allocated: 20067590144
  referenced 13270241280
Btrfs Btrfs v0.19


root@fnix:/# btrfsck /dev/VG1/STORAGE
checking extents
checking fs roots
root 301 inode 10644 errors 1000
root 301 inode 10687 errors 1000
root 301 inode 10688 errors 1000
root 301 inode 10749 errors 1000
found 55683117056 bytes used err is 1
total csum bytes: 54188580
total tree bytes: 191500288
total fs tree bytes: 103596032
btree space waste bytes: 49730472
file data blocks allocated: 55640522752
  referenced 56466059264
Btrfs Btrfs v0.19

It doesn't seem that btrfsck attempts to fix these errors in any way... 
It just displays them.

Besides this, my filesystem looks sane, but I suspect that at least my 
"STORAGE" FS uses much more space than it should...

Are these errors serious ?Is there a way to get rid of them without 
reformatting ?

TIA for any clue.

Best regards.
