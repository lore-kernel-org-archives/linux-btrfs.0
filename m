Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33381 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758481Ab3CDQ1Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 11:27:16 -0500
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r24GRE1e019092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:15 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r24GREjT004306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 16:27:14 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r24GRDBr020385
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 10:27:13 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] Several bugfixes
Date: Tue,  5 Mar 2013 00:25:35 +0800
Message-Id: <1362414341-17306-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Patch 1-5 can make balance process bail out gracefully after we get into
readonly by aborting transaction.

Patch 6 addresses a hang when we have two or more trans handle aborted
and committed themselves.

Liu Bo (6):
  Btrfs: check for NULL pointer in updating reloc roots
  Btrfs: build up error handling for merge_reloc_roots
  Btrfs: free all recorded tree blocks on error
  Btrfs: do not BUG_ON in prepare_to_reloc
  Btrfs: do not BUG_ON on aborted situation
  Btrfs: avoid deadlock on transaction waiting list

 fs/btrfs/relocation.c  |   74 +++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/transaction.c |    7 ++++
 fs/btrfs/volumes.c     |    9 ++++-
 3 files changed, 71 insertions(+), 19 deletions(-)

-- 
1.7.7

