Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC3D2DA76C
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 01:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830401; cv=none; b=MYTa4rzL5ibzcYP+SoFy6itBDQjvRwqM5rb2ZMqXLvELJzpmrWMhJ3kKfLBlEjF3b+tscW4OclKNo/jtdiFTLFXB88uCuRjQz+BwFqlDt4eRIlyAe6/ZNbvdKg0mnFx6AT88x/OCGgrLe/pXjufO/JIRbUYJB9YHwgUlIJuKnHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830401; c=relaxed/simple;
	bh=u+l5WqfZyP1A6ijQPmcJ6iUUh0+1QxN6dCzOI9I6rJ0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=E5+ZxeQZYmH9ldjR0BILFDx17rBmmOPaGs3dbDaGmlb3P8tqSmbeKttMVK0CVQtZWzITBaAA5Yo/0BE4iGwShLbecyW2CHmLZ0cFG9KqWuYq/2YIj2y+8t6xirdQ7tv05twb0Zj6FbR6v4RB1QJEFZxKsuEatqSN2lzw1qaBkw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=XTnlbxKQ; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=wB11mLQ6; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="XTnlbxKQ";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="wB11mLQ6"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6880ueCp3140125
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Sep 2026 21:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=t0Ln7X7H2GEOTi/inzoAc0KOS8
	FBpzJbnedrNHut9G4=; b=XTnlbxKQoIXmJRvXH8n5N6BIxmDsUUrPajTBrWw8N5
	VvWyGhKFSzbJ3pXjJI3GmYzT6AtveOsMTVf63hpJIf1fwpNg/wu8+FqK2I1/3i/b
	Fb9RLIhHMESNtFH9qZpcLihoOgf5CBTiV47gs/IJ+BdH2rFaH5i0uE2lQ4IleB/I
	EAkSttbzakQemFCYFApXnibDoUk7rVgX9+qoVhCdG54yuCoXoyVKHMBdq6G3bu6V
	TvW9MhjUyG9s+oYKbq7n6H1Y5hRtCAmlhMaZfNOeUWsHi1z30//sVNBr/29tw4Bx
	1gSOUdl8DASm6HxtKJWRV88mSPPYFbox2vRP1+/hEVrA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gj4aas6th-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 21:19:51 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9103c9c0b34so86672356d6.1
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 18:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788830390; x=1789435190; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=t0Ln7X7H2GEOTi/inzoAc0KOS8FBpzJbnedrNHut9G4=;
        b=wB11mLQ6bgavw1Mo+V0Whz/wEFLsz8767PUY4y2N8HDS/5+1M25cef7wm42VXEA94F
         8Wm9g9rQOu2mJdNr8ZIfYL4VdaOnT4QyEL5pD6F87tHu4WEAZzYVO+4dHiMcMVaWT9Pf
         SGilGoFMHsEt/9SvQZIrMTeTbWPEbwy5TLh6X35rPnt/GkOhHdNPVL71FBkpvkWNHiLX
         tzdg2kx0LrBSgyz+sONC4Vpb7NW/iXiaO8B4wZRqPVuVRvZRl2qGIJ4KNMlHqHsUsOhS
         ceQpUOPNgySWkDPAgu+9dkspetxIk21ah/ugMHWG4cWcTzRzc8VjD6+pgfpAP+pl4QBD
         21Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788830390; x=1789435190;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=t0Ln7X7H2GEOTi/inzoAc0KOS8FBpzJbnedrNHut9G4=;
        b=DUZUxot9SQ2UxiTyvkcr6w56OE13uz+7En1L7slMO7lUuuteftuo61c0bYmA9Xc/3e
         ER5Oq+Ec2UbGqn0y6C/ZhaDXsTq1HDi0b0l3KOJ135d6/HNYO2u5J4gTGtxz52cQhBVq
         FJ1SWGc531CWrnqjlKOgx3l+tUmFi5gbdiS9YNZO7VibG6EyfK6qd8lnizjbes6r3CZV
         ZTI1QYZtNygY/t+Ta6tjwHHo08v+pI2MDSyDl9SIFG1s0UGhs6zdN5kvmNgYsw4x6rqI
         0DCWb7tCvxgHpJ4mnES48R1enEofZWasDkN7213ASfCceolSkKJ9YObnAIb4Zodt0IFe
         EUgg==
X-Gm-Message-State: AFuF++l2gKPEwZ/gaAl7NsIweaOjurjftyaaz0hU3xY3/wvABSMHg+5B
	Sath0RrGshULPYdzEvY8jjHbXQNQRJP2WKBf7PrhOeP79cJGkKGddmomcu3ye+5FDYjbxzpevD4
	XlpEknw3S2ClUaft930nIw5G6/i/R4GlatMNEPlcPdqHZ5kXKM/wqLueJhXcgfjfaOA+DFa8=
X-Gm-Gg: AYBFou2cmdulteiUWesu83fW0MTrzb6B58t2vDaW4NE7uNsXfgtaDBk2mGZ1O09xaMF
	iJpGa/ON/3PQ+lLrbS8gjZus5wi/wyKCVZN4L/jOhiNwngbMiKDlqZZxVb9hVqFNydRboaJbzM6
	tuaiq+P00eYY5Lh8ZRtIFbwk9IRg3uh0vnawLli/R2n9b0ss4zuWDujPEyudNur6o9B1r14b1Gm
	5YC1aULttG7IAOpkT1c4VPPTtB5zf6eVCTGpKpGkqdLCxPsBLEUDX8ScDmQZz4dCBaXiK8LHShL
	WHT4t5NPz0WpUFMj6zEgjhb6My+e+UNiXu2x4yPKLgoYETCcvh9+jbg2iPyg9Zn/NsgqGP9JGt4
	j4o8PBpwIagwSZxuAE0bJJyM4+ytgBa2bLfVzYzmLvZxrUDEp4FY=
X-Received: by 2002:ad4:5f4a:0:b0:90e:7f15:36fd with SMTP id 6a1803df08f44-9103efa4ef8mr334871196d6.14.1788830389654;
        Mon, 07 Sep 2026 18:19:49 -0700 (PDT)
X-Received: by 2002:ad4:5f4a:0:b0:90e:7f15:36fd with SMTP id 6a1803df08f44-9103efa4ef8mr334870666d6.14.1788830389220;
        Mon, 07 Sep 2026 18:19:49 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694543sm104322656d6.33.2026.09.07.18.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 18:19:48 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH 00/15] btrfs: remove the v1 space cache
Date: Mon, 07 Sep 2026 21:19:15 -0400
Message-Id: <20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJNin2oC/yXMwQqDMAwA0F+RnBeoZVXcr4wdakxnBlNJtAzEf
 7fbju/ydjBWYYNbtYNyFpN5KqgvFdAYpyejDMXgnW9c5xrsV02Gyu85M+YabYnESJFGxmugFFr
 qQhs9lGFRTvL57ffH37b1L6b1W8JxnGo76q5/AAAA
X-Change-ID: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788830387; l=4342;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=u+l5WqfZyP1A6ijQPmcJ6iUUh0+1QxN6dCzOI9I6rJ0=;
 b=NZ4iR9qmiYrMMFLAOTWBeJAnjZaNrQW/5vuNg+uIE8Zx155TWAom9CyMqs0kDXFdVYMjvsQMz
 H9+nPl4MohPArC2GBPBRnSKfDgXbtGntIyahWwxnKPg5BHJM+EZI0ka
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfXx5isawBwCXq2
 0OLcJaOJMVrOgkXrIlzpp6Uwrvv8tOc3yevn/TECK5a83Dyh9CZwEKDeRm60UJQ8L7Ikd6gwsmU
 qFOBM/SZgyOg0gbyN9xqJTrX5ZEuUHmNlMhmF1zosbF7qY0dYQ6VfhxsKMxbt+nVS8v/9FHIa+Q
 LgyJAFiER5FjkcscM2Dh0pKa/1eME7doh2AIteKAECd1nTIUR25L0Z5rPekqhCBPA5//I20Lf/B
 3tV03wgDr8qRLShDhfiDSXWAngwozd60qfP/qy/dNM4YDcZQ+gX18kWKVizi/ppS4CnB0QOENkm
 zE4LOQ19o78zOzfOpKVnl8GRwcpolnnznXs3Th432bIa4JmYdcYUlI7DTdV+7D0iGK4pIzGLgpI
 2epctTOM/lewZfIIxUX1U0mVVZVCCYK4jJt1xTJ4y8cHtytJus5y/BLa+5WjoB9KK89WuSzuCra
 rP7FQizBqadomRkyVMw==
X-Proofpoint-GUID: rO1HTZeA_5wD1eFYZWXg_KU2L-pw8MfT
X-Authority-Analysis: v=2.4 cv=atuCzyZV c=1 sm=1 tr=0 ts=6a9f62b7 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=9ly2DDOFe41V05N6iNUA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDAxMSBTYWx0ZWRfXzxqRbSEU//5T
 kfWabAEhQUuc7gfjIvEkzdtym1InuwXh6QJadBO3Yygs21qI8+qbGDgilgbB6qIw8p2r6KkDgHg
 D/OUxIJ6YKVYcUpamJt6HmnmQ2RXAxf3AKOebSo5KJG5hUBw85S/
X-Proofpoint-ORIG-GUID: rO1HTZeA_5wD1eFYZWXg_KU2L-pw8MfT
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11899
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=10 malwarescore=0 lowpriorityscore=10
 spamscore=0 bulkscore=10 clxscore=1015 adultscore=0 priorityscore=1501
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609080011

Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
options can't select the v1 space cache anymore, but the code is all
still there, and a filesystem with an old cache and no free space tree
still enabled it from the superblock. Qu suggested removing it rather
than converting its page handling to folios [1].

Patch 1 stops enabling the cache from the on-disk state, so an existing
cache is cleaned up on the next read-write mount, as -o nospace_cache
already did. This is the one user-visible change: the cleanup is now
unconditional, and a read-write mount fails if it fails. Patches 2-5
remove the write path, 6 and 7 the load path and disk_cache_state, and
8 and 9 the SPACE_CACHE flag and the unused half of the cleanup helper.
Patches 10-15 remove the trimming ranges and the free space inode
special cases in the write path, which only the v1 writer used.

What's left is what's needed to find and delete the cache inodes of an
existing filesystem:

1. lookup_free_space_inode(), btrfs_remove_free_space_inode(), and
   btrfs_cleanup_free_space_cache_v1(), which runs on the first
   read-write mount and zeroes cache_generation in the super block.

2. btrfs_truncate_free_space_cache() and delete_v1_space_cache(), which
   relocation uses to get a cache inode's extents out of a block group.

3. btrfs_is_free_space_inode(), for the evict and inode update paths.

4. The on-disk definitions: cache_generation in the super block,
   BTRFS_FREE_SPACE_OBJECTID, and the free space header and entry
   items.

space_cache and space_cache=v1 still fall back to nospace_cache with a
warning.

This also removes the page-based I/O in the free space code.
btrfs_io_ctl used a struct page array and was one of the last users
of clear_page_dirty_for_io().

Tested with fstests (btrfs and generic quick groups), with and without
the free space tree, with no regressions against the base kernel.
Upgrading from a filesystem with an existing v1 cache written by a 6.8
kernel was also tested. The cache is removed on the first read-write
mount and on remount from read-only, and the resulting filesystem is
clean under btrfs check and still mountable by the old kernel.

Based on btrfs/for-next.

[1] https://lore.kernel.org/linux-btrfs/e1dd5a75-9a67-4bc6-b8d8-bfff79b5b907@suse.com/

---
Tal Zussman (15):
      btrfs: stop enabling the v1 space cache from the on-disk state
      btrfs: remove the v1 space cache writeout from the transaction commit
      btrfs: remove the free space cache endio workqueue
      btrfs: remove the v1 space cache write path
      btrfs: drop the transaction handle from the prealloc helpers
      btrfs: remove the v1 space cache load path
      btrfs: remove btrfs_disk_cache_state
      btrfs: remove the SPACE_CACHE mount option flag
      btrfs: replace btrfs_set_free_space_cache_v1_active() with a cleanup helper
      btrfs: remove the free space cache trimming ranges
      btrfs: remove BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
      btrfs: remove the free space inode ordered extent special cases
      btrfs: remove the free space inode special cases from the COW paths
      btrfs: stop special-casing free space inodes in the delalloc accounting
      btrfs: stop reading free space inodes from the commit root

 fs/btrfs/block-group.c      |  461 +------------
 fs/btrfs/block-group.h      |   14 -
 fs/btrfs/btrfs_inode.h      |    6 -
 fs/btrfs/delalloc-space.c   |   13 +-
 fs/btrfs/disk-io.c          |   81 +--
 fs/btrfs/file-item.c        |   11 -
 fs/btrfs/free-space-cache.c | 1603 ++++---------------------------------------
 fs/btrfs/free-space-cache.h |   29 +-
 fs/btrfs/fs.h               |    2 -
 fs/btrfs/inode.c            |  149 +---
 fs/btrfs/ordered-data.c     |   27 +-
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/space-info.c       |    2 -
 fs/btrfs/space-info.h       |    4 -
 fs/btrfs/super.c            |   48 +-
 fs/btrfs/transaction.c      |   37 +-
 fs/btrfs/transaction.h      |   27 -
 fs/btrfs/zoned.c            |    9 -
 18 files changed, 226 insertions(+), 2299 deletions(-)
---
base-commit: 69b26c13e520480d1869171e2c2b8a59f0c857ec
change-id: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

