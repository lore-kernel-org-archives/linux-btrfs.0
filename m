Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11697 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbeIMIVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 04:21:04 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <dsterba@suse.com>
CC: <jbacik@fb.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 0/2] change some function to be void function
Date: Thu, 13 Sep 2018 11:01:13 +0800
Message-ID: <1536807675-25086-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


zhong jiang (2):
  btrfs: change unpin_extent_cache to be void function
  btrfs: change remove_extent_mapping to be void function

 fs/btrfs/extent_map.c | 10 ++--------
 fs/btrfs/extent_map.h |  4 ++--
 2 files changed, 4 insertions(+), 10 deletions(-)

-- 
1.7.12.4
