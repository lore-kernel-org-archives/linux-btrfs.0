Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47794 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751498AbaJJU5Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:24 -0400
Received: from pps.filterd (m0004003 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s9AKsF3l012661
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:23 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1pxmbv8mv0-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Oct 2014 13:57:23 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: Btrfs-progs: fix horrible things
Date: Fri, 10 Oct 2014 16:57:05 -0400
Message-ID: <1412974637-31334-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the culmination of two weeks worth of work with Jaap Pieroen and his
broekn file system.  This pulls back a few things from the kernel in order to
support the dir item stuff, and the rbtree stuff to fix a weird bug we were
seeing.  There will be more test images coming, but this is what I have so far.
David if you want this in a branch to pull let me know, this has the updated
"repair missing dir index" patch so you can drop the old one.  With these
patches we can now deal with most if not all dir index corruption issues and be
able to fix corrupt blocks that are pointed at by multiple snapshots.  Thanks,

Josef

