Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17923 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbAVJ54 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Jan 2015 04:57:56 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t0M9vtab029322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2015 09:57:55 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t0M9vsHD028912
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2015 09:57:55 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id t0M9vsTq028900
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Jan 2015 09:57:54 GMT
Message-ID: <54C0CAFB.4020708@oracle.com>
Date: Thu, 22 Jan 2015 18:03:39 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: replace seed/sprout hangs  (regression ?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  The following test case hangs as of now, but as I remember Fujitsu
  had sent a patch to fix this, a long time back. Can't find now,
  any idea. ?

  Test case:
    add a spout device
    replace seed / sprout device

  hangs at:
   (btrfs_reada_wait+0x4d/0xb0)

Thanks, Anand
