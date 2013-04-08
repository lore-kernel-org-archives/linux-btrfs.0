Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23004 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934790Ab3DHDi3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 23:38:29 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r383cSOU006445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Apr 2013 03:38:29 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r383cRVk000119
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Apr 2013 03:38:28 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r383cQUa011605
	for <linux-btrfs@vger.kernel.org>; Mon, 8 Apr 2013 03:38:26 GMT
Message-ID: <51623C0C.4060709@oracle.com>
Date: Mon, 08 Apr 2013 11:39:56 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [bug] error communication from kernel to userland
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

  the below example tells a problem..

  ----
  # btrfs dev del missing /btrfs
  ERROR: error removing the device 'missing' - Invalid argument

  # dmesg | tail
  ::
  [ 4295.258686] btrfs: unable to go below two devices on raid1
  #
  -----
  as of now the more accurate errors are being logged to dmesg,
  which a normal user might not notice and there are few other
  btrfs cli cases similar to this.

  We need to get the kernel errors to the useland as part the
  cli being used.

  However the btrfs is relaying on the limited set of errno
  defines which is insufficient / inappropriate in the
  btrfs context.

  As a solution we have 2 choices broadly.. as of now

  - Update the errno with more FS and RAID related defines

  - Get the error string as part of ioctl arg.

  - ?


  any comments / questions / views / ideas are welcome..


Thanks, Anand
