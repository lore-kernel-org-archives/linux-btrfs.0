Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18971 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab3LRVHh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 16:07:37 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id rBIL5179013722
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:36 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1guah09jr0-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 13:07:35 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: Rework qgroup accounting
Date: Wed, 18 Dec 2013 16:07:26 -0500
Message-ID: <1387400849-7274-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

People have been complaining about autodefrag/defrag killing their box with OOM.
This is because the snapshot aware defrag stuff super sucks if you have lots of
snapshots, and so that needs to be reworked.  The problem is once that is fixed
you start to hit horrible lock contention on the delayed refs lock because we
have thousands of like entries that can't be merged until when we go to actually
run the delayed ref.  This problem exists because of the delayed ref sequence
number.

The major user of the delayed ref sequence number is the qgroup code.  It uses
it to pass into btrfs_find_all_roots to see what roots pointed to a particular
bytenr either before or including the current operation.  It needs this
information to know if we were removing the last ref or an just the last ref for
this particular root.  The problem with this is that it has made the delayed ref
code incredibly fragile and has forced us to do things like
btrfs_merge_delayed_refs which is what is causing us so much pain when we have
thousands of ref updates for the same block.

In order to fix this I'm introducing a new way of adjusting quota counts.  I've
called them qgroup operations, and we apply them in very specific situations.
We only add these when we add or remove the only ref for a particular root.
Obviously we have to account for shared refs as well so there is some extra code
for these special cases, but basically we make the qgroup accounting only happen
when we know there was a real change (or likely a real change in the case of
shared refs).

In order to do this I've also introduced lock/unlock_ref.  This only gets used
if we actually have qgroups enabled, but it will be relatively low cost even if
we have qgroups enabled as it only locks the bytenr for reference updates.  So
delayed ref updates will not trip over this since we only do one at a time
anyway, so we'll only have contention if we have delayed refs running at the
same time as a qgroup operation update.

Then all we need to account for is the fact that we will get the full view of
the roots at the time we run the operations, not what they were when our
particular operation occurred.  This is ok because we will either ignore our
root in the case of add or not ignore it in case of remove when calculating the
ref counts.  We use the same ref counting scheme that Arne developed as it's
pretty freaking awesome, and just adjust how we count the ref counts based on
our operations.

In addition to all of this new code I've added a big set of sanity tests to make
sure everything is working right.  Between this and the qgroups xfstests I'm
pretty certain I haven't broken anything obvious with qgroups.  This is just the
first step in getting rid of the delayed ref sequence number and fixing the
defrag OOM mess but it is the biggest part.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
