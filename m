Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52662 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbaGYBkl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 21:40:41 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s6P1de3S021332
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 18:40:40 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1nav4h3k9a-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 18:40:40 -0700
Message-ID: <53D1B595.7070908@fb.com>
Date: Thu, 24 Jul 2014 21:40:37 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: integration tree updated
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

I've pushed out my current integration branch.  It does have a few of
Miao Xie's patches missing because there were some rejects.  I think
this was just because some things got pulled in out of order, and I'll
get it fixed up.

Also missing is Mark's quota snapshot deletion fixes.  They were
crashing during btrfs/011 with CONFIG_DEBUG_PAGE_ALLOC on.  We'll get
that nailed down.

integration is subject to rebasing, so please treat it more like a patch
queue.  It is very lightly tested, the goal is just to show which
patches are already applied and which ones are still pending.

Thanks!

-chris


