Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34634 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3E0DfK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 May 2013 23:35:10 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4R3Z6fe031602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 03:35:07 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4R3Z8x9003644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 03:35:08 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4R3Z7o6003640
	for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 03:35:07 GMT
Date: Mon, 27 May 2013 11:34:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [Question] How to restore btrfs raid0 image file?
Message-ID: <20130527033434.GC15816@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

So the case is, now I've got a btrfs image file, which is created from a
raid0 btrfs fs.

And if I run 'btrfs-image -r image_file /dev/sdf', then I have to mount
it with 'degraded' mode, and that still fails because raid0 requires two
disks at least.

So any ideas how to make it work?

thanks,
liubo
