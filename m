Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23424 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaBKISI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Feb 2014 03:18:08 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s1B8I65Y014775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 08:18:07 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s1B8I61s012405
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 08:18:06 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s1B8I5ug017426
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Feb 2014 08:18:05 GMT
Message-ID: <52F9DCBA.1010002@oracle.com>
Date: Tue, 11 Feb 2014 16:18:02 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org >> btrfs" <linux-btrfs@vger.kernel.org>
Subject: btrfs multiple mounts stacked on the same mount point
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



per mount(2)

  ---
   multiple mounts can be stacked on the same mount point.
  ---

  In this situation how could ioctl communicate
  (using mount point) with each FS stacked on the
  same mount point ?

  BTW I don't understand the need for multiple
  mounts on the same mount point ?

  Any idea. ?

Thanks Anand
