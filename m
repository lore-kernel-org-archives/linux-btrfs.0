Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:51630 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933025AbeBMEeT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 23:34:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1D4SH7d012563
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 04:34:19 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2g3p3v8f59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 04:34:19 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w1D4YIxv005002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 04:34:18 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w1D4YImY012725
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 04:34:18 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: extent_buffer_uptodate() make it static and inline
Date: Tue, 13 Feb 2018 12:35:44 +0800
Message-Id: <20180213043544.25225-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

extent_buffer_uptodate() is a trivial wrapper around test_bit()
and nothing else. So make it static and inline, save on code
space and call indirection.

Before:
   text	   data	    bss	    dec	    hex	filename
1131257	  82898	  18992	1233147	 12d0fb	fs/btrfs/btrfs.ko

After:
   text	   data	    bss	    dec	    hex	filename
1131090	  82898	  18992	1232980	 12d054	fs/btrfs/btrfs.ko

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/extent_io.c | 5 -----
 fs/btrfs/extent_io.h | 5 ++++-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index bae57b408901..f300edae044b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5229,11 +5229,6 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
 	}
 }
 
-int extent_buffer_uptodate(struct extent_buffer *eb)
-{
-	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
-}
-
 int read_extent_buffer_pages(struct extent_io_tree *tree,
 			     struct extent_buffer *eb, int wait, int mirror_num)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 72e5af2965a8..953d94662b8e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -489,7 +489,10 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb);
 int set_extent_buffer_dirty(struct extent_buffer *eb);
 void set_extent_buffer_uptodate(struct extent_buffer *eb);
 void clear_extent_buffer_uptodate(struct extent_buffer *eb);
-int extent_buffer_uptodate(struct extent_buffer *eb);
+static inline int extent_buffer_uptodate(struct extent_buffer *eb)
+{
+	return test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
+}
 int extent_buffer_under_io(struct extent_buffer *eb);
 int map_private_extent_buffer(const struct extent_buffer *eb,
 			      unsigned long offset, unsigned long min_len,
-- 
2.15.0

