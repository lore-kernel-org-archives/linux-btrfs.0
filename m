Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29967 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162241Ab3DEVGo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2013 17:06:44 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r35L6h7X013992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 21:06:43 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r35L6ga2014520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 21:06:43 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r35L6gFC025312
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 16:06:42 -0500
Message-ID: <515F3C0A.8080603@oracle.com>
Date: Fri, 05 Apr 2013 23:03:06 +0200
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [BUG?] Btrfs quota: overwritten space is counted twice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When data in a file is overwritten, starting somewhere in the middle of 
the file, the overwritten space is counted twice against the space usage 
numbers. Is this a bug, or did I something wrong?

This is what I did:

I create a subvolume and limit it to 4 MB, and create a 1000 KB file in 
the subvol:

     # btrfs subvol create s
       Create subvolume './s'
     # btrfs qgroup limit 4m s
     # btrfs qgroup show ./ | grep 260
       0/260 4096 4096
     # dd if=/dev/zero of=s/file bs=1024 count=1000; sync
     # ls -lah s/file
       -rw-r--r--. 1 root root 1000K Apr  6 00:13 s/file
     # btrfs qgroup show ./ | grep 260
       0/260 1028096 1028096

Then I overwrite the last 900 KB of the file, and add 100 KB of data, 
resulting in a 1.1 MB file. The space usage numbers shows 2 MB however:

     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=100; sync
     # ls -lah s/file
       -rw-r--r--. 1 root root 1.1M Apr  6 00:13 s/file
     # btrfs qgroup show ./ | grep 260
       0/260 2052096 2052096

I repeat this twice, the file becomes 1.3 MB but the usage number goes 
to almost 4 MB:

     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=200; sync
     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=300; sync
     # ls -lah s/file
       -rw-r--r--. 1 root root 1.3M Apr  6 00:14 s/file
     # btrfs qgroup show ./ | grep 260
       0/260 4100096 4100096

Doing the same again results in "quota exceeded" errors:

     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=400; sync
       dd: writing `s/file': Disk quota exceeded
       78+0 records in
       77+0 records out
       78848 bytes (79 kB) copied, 0.00138135 s, 57.1 MB/s
     # ls -lah s/file
       -rw-r--r--. 1 root root 477K Apr  6 00:15 s/file
     # btrfs qgroup show ./ | grep 260
       0/260 4182016 4182016
     # touch s/emptyfile
       touch: cannot touch `s/emptyfile': Disk quota exceeded

Koen.
