Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59239 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751722AbbDMTyU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 15:54:20 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t3DJk97n008976
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:54:19 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 1trj5hrkgu-16
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:54:19 -0700
Received: from facebook.com (2401:db00:20:702c:face:0:2f:0)	by
 mx-out.facebook.com (10.212.232.59) with ESMTP	id
 aa0d6072e21611e49c070002c991e86a-79aa62c0 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Apr 2015 12:52:49 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/4] btrfs: reduce block group cache writeout times during commit
Date: Mon, 13 Apr 2015 12:52:35 -0700
Message-ID: <1428954759-1304912-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Large filesystems with lots of block groups can suffer long stalls during
commit while we create and send down all of the block group caches.  The
more blocks groups dirtied in a transaction, the longer these stalls can be.
Some workloads average 10 seconds per commit, but see peak times much higher.

The first problem is that we write and wait for each block group cache
individually, so we aren't keeping the disk pipeline full.  This patch
set uses the io_ctl struct to start cache IO, and then waits on it in bulk.

The second problem is that we only allow cache writeout while new modifications
are blocked during the final stage of commit.  This adds some locking
so that cache writeout can happen very early in the commit, and any block
groups that are redirtied will be sent down during the final stages.

With both together, average commit stalls are under a second and our overall
performance is much smoother.

