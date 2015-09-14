Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25225 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbbINP2g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 11:28:36 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t8EFSaYT013976
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 15:28:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by userv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t8EFSZLx025663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 15:28:35 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t8EFSZng022281
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Sep 2015 15:28:35 GMT
Date: Mon, 14 Sep 2015 23:28:21 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: Horrible dbench performance
Message-ID: <20150914152820.GA25610@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Both [1] and [2] had run dbench on btrfs with fast storage, and 
showed bad numbers, I got an impression that after refractoring btree lock to
smart rwlock, we have mitigated this issue..

Not got a fast-enough ssd handy, does anyone confirm the result showed
in those link?

[1]:https://lkml.org/lkml/2015/4/29/793
[2]:https://lkml.org/lkml/2015/8/21/22

Thanks,

-liubo
