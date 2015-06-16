Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48767 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbFPMpt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 08:45:49 -0400
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 16 Jun 2015 18:15:46 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 8F329E0060
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 18:19:11 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5GCjg8q66781356
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 18:15:42 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5GBkxfk031542
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 17:16:59 +0530
Received: from localhost.localdomain ([9.124.158.146])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id t5GBkxuR031529
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 17:16:59 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs_setsize: Why do we truncate pages beyond newsize?
Date: Tue, 16 Jun 2015 18:15:40 +0530
Message-ID: <17286129.veoAeJPk9a@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I am trying to fix failures of generic/029 and generic/030 (in
subpagesize-blocksize scenario) using the pagecache_isize_extended() function
provided by the commit "vfs: fix data corruption when blocksize < pagesize for
mmaped data" (90a8020278c1598fafd071736a0846b38510309c).

In btrfs_setsize(), For the "newsize > oldsize" scenario, why do we have
"truncate_pagecache(inode, newsize)" i.e. why do we truncate pages beyond the
new size of the file (where pages normally shouldn't exist at this point of
execution).

-- 
chandan

