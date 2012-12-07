Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422888Ab2LGRHw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2012 12:07:52 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qB7H7pFN029939
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 17:07:51 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qB7H7o1O008000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 17:07:51 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qB7H7ok9002601
	for <linux-btrfs@vger.kernel.org>; Fri, 7 Dec 2012 11:07:50 -0600
Message-ID: <50C223B4.8050301@oracle.com>
Date: Sat, 08 Dec 2012 01:13:24 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [Bug] Remove and add a mounted device gets a new dev path
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



# mount /dev/sdb /btrfs

# echo "scsi remove-single-device 1 0 0 0" > /proc/scsi/scsi

# lsscsi
  [0:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda
  [2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc

# btrfs su create /btrfs/sv1
Create subvolume '/btrfs/sv1'
ERROR: cannot create subvolume - Input/output error

# echo "scsi add-single-device 1 0 0 0" > /proc/scsi/scsi

# lsscsi
[0:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda
[1:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdd <---
[2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc

The same disk comes back as /dev/sdd

(the issue is same if disk is mounted as an ext4 fs)

Thanks
