Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26043 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbbDMTXA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 15:23:00 -0400
Received: from pps.filterd (m0004077 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t3DJIjXd025749
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:22:59 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1trk9x84we-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:22:59 -0700
Received: from facebook.com (2401:db00:20:702c:face:0:2f:0)	by
 mx-out.facebook.com (10.212.236.87) with ESMTP	id
 7de28e5ee21211e4aed50002c9521c9e-c83f02c0 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Apr 2015 12:22:57 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/5] Btrfs: truncate space reservation fixes
Date: Mon, 13 Apr 2015 12:22:47 -0700
Message-ID: <1428952972-1266934-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One of the production workloads here at FB ends up creating and eventually
deleting very large files.  We were consistently hitting ENOSPC aborts
while trying to delete the files because there wasn't enough metadata
reserved to cover deleting CRCs or actually updating the block group
items on disk.

This patchset addresses these problems by adding crc items into the
math for delayed ref processing, and changing the truncate items loop
to reserve metadata more often.

It also solves a performance problem where we are constantly committing
the transaction in hopes of making enospc progress.

