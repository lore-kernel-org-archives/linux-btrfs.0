Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23284 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2LLAWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 19:22:20 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBC0MJrH003843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:22:19 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBC0MI05012484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2012 00:22:18 GMT
Received: from abhmt115.oracle.com (abhmt115.oracle.com [141.146.116.67])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBC0MIT6016129
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Dec 2012 18:22:18 -0600
Message-ID: <50C7CE36.3060603@oracle.com>
Date: Wed, 12 Dec 2012 08:22:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: anand.jain@oracle.com
Subject: [RFC PATCH V4 0/2] Btrfs: get/set mounted filesystem label support
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This is an improved tiny patch set to add get/set the label upon a mounted
file system via ioctl(2).

I'd like to add the Signed-off-by with Anand for the credit since He has posted a
similar patch set a few month ago.


Changes of V4->V3:
- Add a new ioctl to fetch the label of a mounted file system.
- Replace "struct btrfs_ioctl_fs_label_args" with "char label[BTRFS_LABEL_SIZE]".
- ioctl(2) number changed from 50 to 53/54. I'll update the btrfs wiki page with regard to
  the number allocation to reflect this change if it is ok.


The old versions can be found at:

v3:
https://patchwork.kernel.org/patch/1124642/

v2:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12877

v1:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/12872

Thanks,
-Jeff
