Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753622AbeBLPim (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 10:38:42 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1CFai9E066838
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:38:42 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2g3d8x08cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:38:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1CFXf4g009246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:33:41 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1CFXfuU023426
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Feb 2018 15:33:41 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix extent_buffer_uptodate() return
Date: Mon, 12 Feb 2018 23:34:56 +0800
Message-Id: <20180212153456.19358-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

extent_buffer_uptodate() returns from test_bit() which is of
type bool, so update extent_buffer_uptodate() to it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/extent_io.c | 2 +-
 fs/btrfs/extent_io.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bae57b408901..96879c1c1651 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5229,7 +5229,7 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
 	}
 }
 
-int extent_buffer_uptodate(struct extent_buffer *eb)
+bool extent_buffer_uptodate(struct extent_buffer *eb)
 {
 	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 }
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 72e5af2965a8..d4ea3a2070ee 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -489,7 +489,7 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 void set_extent_buffer_uptodate(struct extent_buffer *eb);
 void clear_extent_buffer_uptodate(struct extent_buffer *eb);
-int extent_buffer_uptodate(struct extent_buffer *eb);
+bool extent_buffer_uptodate(struct extent_buffer *eb);
 int extent_buffer_under_io(struct extent_buffer *eb);
 int map_private_extent_buffer(const struct extent_buffer *eb,
 			      unsigned long offset, unsigned long min_len,
-- 
2.15.0

