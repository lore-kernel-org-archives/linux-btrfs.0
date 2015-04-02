Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15386 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752093AbbDBOR5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Apr 2015 10:17:57 -0400
Date: Thu, 2 Apr 2015 10:17:47 -0400
From: Chris Mason <clm@fb.com>
Subject: Please add =?us-ascii?Q?9c4f61f01d269815bb7c37be3ede59c5587747?=
 =?us-ascii?Q?c6?= to stable
To: stable <stable@vger.kernel.org>, Btrfs <linux-btrfs@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Message-ID: <1427984267.10670.0@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi stable friends,

Can you please backport this one to 3.19.y.  It fixes a bug introduced 
by:

381cf6587f8a8a8e981bc0c1aaaa8859b51dc756, which was tagged for stable 
3.14+

The symptoms of the bug are deadlocks during log reply after a crash.  
The patch wasn't intentionally fixing the deadlock, which is why we 
missed it when tagging fixes.

Please put this commit everywhere you've cherry-picked 
381cf6587f8a8a8e981bc0c1aaaa8859b51dc756

commit 9c4f61f01d269815bb7c37be3ede59c5587747c6
Author: David Sterba <dsterba@suse.cz>
Date:   Fri Jan 2 19:12:57 2015 +0100

    btrfs: simplify insert_orphan_item

    We can search and add the orphan item in one go,
    btrfs_insert_orphan_item will find out if the item already exists.

    Signed-off-by: David Sterba <dsterba@suse.cz>

-chris



