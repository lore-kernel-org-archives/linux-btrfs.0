Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42468 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932555AbcIBTkP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 15:40:15 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82JZCuE010616
        for <linux-btrfs@vger.kernel.org>; Fri, 2 Sep 2016 12:40:15 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 257b5sssyx-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:40:15 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 0/7] Kill the btree inode
Date: Fri, 2 Sep 2016 15:39:59 -0400
Message-ID: <1472845206-22870-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to provide a better way to do subpage blocksizes we need to stop
allocating pages from a per fs btree inode and instead allocate our own pages.
This work depends on 3 generic patches that I've sent previously

remove mapping from balance_dirty_pages*()
writeback: allow for dirty metadata accounting
writeback: introduce super_operations->write_metadata

This is a pretty big change but ultimately makes extent_buffer reclaim much
cleaner and will make the sub-pagesize blocksize work significantly cleaner.
I've been hammering on this for a few weeks now and seems to be pretty solid.
Thanks,

Josef

