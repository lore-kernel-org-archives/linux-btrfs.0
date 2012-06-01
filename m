Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab2FANz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jun 2012 09:55:59 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q51DtxND010004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:55:59 -0400
Received: from localhost.localdomain.com (vpn-9-98.rdu.redhat.com [10.11.9.98])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q51Dtwng031587
	for <linux-btrfs@vger.kernel.org>; Fri, 1 Jun 2012 09:55:58 -0400
From: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: Transaction abort fixes
Date: Fri,  1 Jun 2012 09:55:48 -0400
Message-Id: <1338558955-4944-1-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is my reworked series of transaction abort fixes.  The only ones that have
changed since yesterday are patches 5 and 6.  Now we use the fs_state flag to
tell if our transaction aborted and we make sure to actually call the
transaction abort stuff if we have a commit error so the error gets set
properly.  Patch 6 was fixed up to get rid of a memory leak we had when we'd
abort a transaction.  With these patches I've been able to do all sorts of
horrible things and have the transactions abort properly and still have a nice
clean file system left over.  Thanks,

Josef
