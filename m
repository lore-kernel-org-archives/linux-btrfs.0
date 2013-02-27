Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46985 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3B0N3z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:29:55 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1RDTsqP032483
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 13:29:54 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1RDTrOF014429
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 13:29:54 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1RDTrTQ028612
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 07:29:53 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] bug fixes for error handling
Date: Wed, 27 Feb 2013 21:28:23 +0800
Message-Id: <1361971705-8933-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These two fixes are for error handling after we abort a transaction.

One is a memory leak fix, and the other one is a NULL pointer fix.

Liu Bo (2):
  Btrfs: fix memory leak of log roots
  Btrfs: fix NULL pointer after aborting a transaction

 fs/btrfs/disk-io.c     |    5 +++++
 fs/btrfs/transaction.c |    8 +++++++-
 fs/btrfs/tree-log.c    |    6 ++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

-- 
1.7.7

