Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20786 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760457Ab3DCGVa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 02:21:30 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r336LT5F000417
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Apr 2013 06:21:30 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r336LTxe027228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Apr 2013 06:21:29 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r336LTCF006200
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Apr 2013 01:21:29 -0500
Message-ID: <515BCAB5.30403@oracle.com>
Date: Wed, 03 Apr 2013 14:22:45 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [bug] btrfs fi df doesn't show raid type after balance
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Did something break.. ? we are not reporting raid type after balance.

-----------
# btrfs fi df /btrfs
Data, RAID0: total=2.00GB, used=2.03MB
Data: total=8.00MB, used=0.00
System, RAID0: total=16.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, RAID0: total=2.00GB, used=216.00KB
Metadata: total=8.00MB, used=4.00KB

# btrfs bal /btrfs
Done, had to relocate 5 out of 5 chunks

# btrfs fi df /btrfs
Data: total=1.00GB, used=2.78MB
System: total=4.00MB, used=4.00KB
Metadata: total=1.00GB, used=276.00KB
#
-----------

btrfs-progs is at integration-20130321 and 3.8.0+


Thakns
Anand
