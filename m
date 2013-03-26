Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17355 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965480Ab3CZPYQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:16 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r2QFOEu8029967
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 15:24:15 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r2QFODhX017367
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 15:24:14 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r2QFOD8Z030247
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 10:24:13 -0500
Message-ID: <5151BD92.2010802@oracle.com>
Date: Tue, 26 Mar 2013 23:24:02 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [bug] mount and /proc/mounts disagrees
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


3.8.0+ #3

This happened after 'umount /btrfs' was interrupted by ctl-C

# mount | egrep btrfs
/dev/mapper/mpathe on /btrfs type btrfs (rw,degraded)

# cat /etc/mtab | egrep btrfs
/dev/mapper/mpathe /btrfs btrfs rw,degraded 0 0

# cat /proc/mounts | egrep btrfs
# umount /btrfs
umount: /btrfs: not mounted
#


-Anand
