Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45163 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2LKWSC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 17:18:02 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBBMI0ha004595
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 22:18:01 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBBMHxUd010772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 22:18:00 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBBMHxRl031811
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 16:17:59 -0600
Message-ID: <50C7B0A3.7040408@oracle.com>
Date: Tue, 11 Dec 2012 23:16:03 +0100
From: Koen De Wit <koen.de.wit@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Bug: trying to create reflink on different device results in empty
 file
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When trying to create a clone (reflink) of a file on a different device, 
you'll get this error:
     Invalid cross-device link

However, an empty file is created on the target location. An invalid 
clone operation should not result in the creation of a file.


Example:

# mount
(...)
/dev/sdb1 on /mnt/diskb type btrfs (rw)
/dev/sdf1 on /mnt/diskf type btrfs (rw)

# ls -l diskb
total 4
-rw-r--r-- 1 root root 11 Dec 11 22:45 testfile.txt

# ls -l diskf
total 0

# cp --reflink diskb/testfile.txt diskf/testcopy.txt
cp: failed to clone `diskf/testcopy.txt' from `diskb/testfile.txt': 
Invalid cross-device link

# ls -l diskf
total 0
-rw-r--r-- 1 root root 0 Dec 11 22:56 testcopy.txt

