Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51352 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3ILL3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 07:29:38 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r8CBTaSm018898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 11:29:37 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8CBTa3t023065
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 11:29:36 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r8CBTZnS000676
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 11:29:35 GMT
Message-ID: <5231A598.1050306@oracle.com>
Date: Thu, 12 Sep 2013 19:29:28 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: extent data disk byte 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  In the item 7 below, any idea why would the disk byte be 0 ?
  (its not an inline extent)

  ----------
         item 6 key (257 EXTENT_DATA 0) itemoff 3531 itemsize 53
                 extent data disk byte 456130560 nr 4096
                 extent data offset 0 nr 4096 ram 4096
                 extent compression 0
         item 7 key (257 EXTENT_DATA 4096) itemoff 3478 itemsize 53
                 extent data disk byte 0 nr 0
                 extent data offset 0 nr 258048 ram 258048
                 extent compression 0
         item 8 key (257 EXTENT_DATA 262144) itemoff 3425 itemsize 53
                 extent data disk byte 456265728 nr 4096
                 extent data offset 0 nr 4096 ram 4096
                 extent compression 0
  -----------

Thanks, Anand
