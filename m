Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34229 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbD0EtM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Apr 2015 00:49:12 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Wolfgang_Mader@brain-frog.de, dsterba@suse.cz
Subject: [PATCH 0/2] serviceability: add event log when missing device is created
Date: Mon, 27 Apr 2015 12:46:17 +0800
Message-Id: <1430109979-9397-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolfgang was in a situation that he wanted to know the device-id
of a missing device as indicated by 'btrfs fi show'

sysfs patches sent before would help. And irrespective of that,
these are system events must be logged for better pathological
analysis of the btrfs issues.


Anand Jain (2):
  Btrfs: log when missing device is created
  Btrfs: check error before reporting missing device and add uuid

 fs/btrfs/volumes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.0.0.153.g79dcccc

