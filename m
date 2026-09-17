Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6A93B7744
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 04:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789617636; cv=none; b=Eqm+9vGRYDRqEtuid/aM4Urmg7D39U/Siy14EbufNUSrIWQZpd5aB1OcYUw33oKixzZicnOiYtHpApELfl9UgO9E5s+XQ2gQgJdA5xkX3BVWft/f01QtsCwwmxV3Jfl9nXlEibRfnTz2N/c73FnNwz3MRwnyYCM7AYUHThHCSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789617636; c=relaxed/simple;
	bh=DiozgMR/ICapXx8MBD2toeCbM/4lq8wJDPp6LEj8JSc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=YP0n78SVnHu1MWX3ojAOx1XCT4gVOAxFJVDlhdI/efbQU3794AyBqmtAELHpFN1o0APMB37IcziR9b1ij7sDHIBoyyOhF81E0qsb1WY/X1Ej9BvDFkVXbV6cI6X1BM01os5PhRyLdr1KS+qgdaIJtHKnojuyh1GjxmK5lvFbjlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=iY6BK0nQ; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=GJP8x1GI; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="iY6BK0nQ";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="GJP8x1GI"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68H2YOKw203011
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=bhJLqbqf95E9IJAGnTjETl50E/
	hErPUFqcLv3tZTRfY=; b=iY6BK0nQ60jothWfwPihV+XzRhXbOOYSAnjd9R0zm5
	9nt8NFN6kPG7gWqvmQm6aEXKh9WQLs8wqiVPLUpa08earBg0U3B0s2qs6atm5SVa
	2PRiNjlAIPrzLTOGZsczs965rV7ytsUlRmI0ySsmsPw0gx7jNgC8y3nnPaMHDvBw
	S/gD8BosyDS0Z0xUZa8aLGID+7H7RlsW6EQeXbr6y8h4DqOtobRKZ2KOMO/bMhpc
	4EP1ats0yDYaC95BvgLC7rSagCihn8V3WABh/P4sk80Zav4MlfSusBdUM86Wa0Yt
	2pefh3rdQ7caclX49ZOWApsVFNb4fRzmHGzH4ZQM1QJg==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gr1x6adnd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 00:00:26 -0400 (EDT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-90cddf4f59eso8921376d6.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789617625; x=1790222425; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bhJLqbqf95E9IJAGnTjETl50E/hErPUFqcLv3tZTRfY=;
        b=GJP8x1GIa7qwt+VAfwH/mgrUAzh14sUVLbSwx4EJfK9FiH35ojtzFk9IzsKhDSRH6r
         PiURogyXNFgml7cbzzXwAZcwPqMdCPQ8PEJlFIYakeXd2yGE5gn7mxiRpshwkhHXSyN5
         LIuRx4jKvGNXlU9KyUhju4WqhCGnxBSIlGAulR8K6o3j/4LgcayKbKMEucgLM5lmbhuX
         NPXfv6XnHCf6bIlbtvRe56g9Qs7OzJ6jJUjRWH0B2rHJepMBmvJ48sGAXSWqeAelLAMK
         fHrmVS712VlONEBS1kLkChHC0/JY2EvDA7ud9krLcaawIBmX4fh+38cTvx0YTv8bcLNY
         gtig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789617625; x=1790222425;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bhJLqbqf95E9IJAGnTjETl50E/hErPUFqcLv3tZTRfY=;
        b=L10SOowB4iUKuDMRB2JYS0WW7EtqQl+bd0m2fzYmYKZjGqZSd5fJNTLLbSc6/CAhXT
         dNFI4pYjbkjCJ5khP0tPqhvIsZiPq+d056qDJwIJ5yotOB88QrUDL7urHjceOPvhgAjz
         Tv+5MHMiR6PQQw7t7h0zz5pePEVawMO4UxaMlxyc9fvXzPo1MWcFuAEdAOKzH8rOVWI0
         kO6xy8HWIrXfIUR4pjf+g5xQtM38G5GHBB7QTYO6WM4o/N+b9IloKFZXTigFFxoN5pTq
         AP+GzyHrLyXH5FAd/oMxcRES2PZA5eWQleUsBQK3dkT2X0dESDoF8WaIPwMnUki3xn5Y
         uP6Q==
X-Gm-Message-State: AFuF++mpLTvheERt307V6ndON/kTH2hoelfxQM+K+gM/8D7VLhYXx/tu
	r2VxhWx+Jmrg2D6AIMBqdI6oHupaSBYWD43w9K4KELfYUHfMWuEpgtS4jnXugVnx1Dr3A5lbwYV
	evn93weOAlthAh7nWVTz7HWGLSodiH2MOUfKR5lcqrj8Fe+Nu0j5yZaK3zAWT
X-Gm-Gg: AYBFou2YyZRFLC7D/1THIMF6pZjd9b/W8HiFqfB6H/JWnnSIQgdweUkxBBOjhd7nkEA
	4Poowe/KGkNwjp+u3hvsLyRsFraCpnY7FUF8bPzxGaeGfgwmBccd/DnDhvQb9JK21FXTlyn2to+
	xnmj9htqxGAO+6yI5RikETL8eiNLBNAmkrI3EQ1559l5+g63UWoRU1Lz3DFNjBU+20rYcMuIiAZ
	bHX7BbT4IrzlFZcDn+q8zcTFBk68OoeOi2KisGd3ewgwmq5I6163XoSoXwF2wGBVJn+shn08gU8
	2XZ6lI+uylYgYyVfaaODrNieuTGd6cGZ6OcRf/zO3CBc94UZaU4Ue2qgvAeMU9p5Fwm4u25VrV+
	9HgjTbWt9AR5lfhol/t4n/FMlxmuVigZwWVRSw3mcLa/EHw==
X-Received: by 2002:a05:6214:21c5:b0:910:345c:b7e5 with SMTP id 6a1803df08f44-9123d8e461amr100771626d6.36.1789617625189;
        Wed, 16 Sep 2026 21:00:25 -0700 (PDT)
X-Received: by 2002:a05:6214:21c5:b0:910:345c:b7e5 with SMTP id 6a1803df08f44-9123d8e461amr100771026d6.36.1789617624539;
        Wed, 16 Sep 2026 21:00:24 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123beadde6sm41748766d6.35.2026.09.16.21.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 21:00:23 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v3 00/17] btrfs: remove the v1 space cache
Date: Wed, 16 Sep 2026 23:59:56 -0400
Message-Id: <20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALxlq2oC/33N0Q6CIBiG4VtxHEcDDMiOuo/WwS/+Ji3FgbKa8
 95DW1vrwMN3+/Z8EwnoLQZyyibiMdpgXZci32XENNDdkNoqNRFMKFYwRcvB14F6bF1EGjkNPRi
 kBkyD9CBNLbUppAZBktB7rO1z1S/XT4exvKMZFnJZNDYMzr/W+8iX3fdJbz6lZFTWBcgScilAn
 417jG1pYY/VSJazKH44nm9zInH8qLTSoJEz9cfN8/wGhtOgmSoBAAA=
X-Change-ID: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789617622; l=5648;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=DiozgMR/ICapXx8MBD2toeCbM/4lq8wJDPp6LEj8JSc=;
 b=qP/XBQJ0XBp6ND9b1EIG92HzSSJZC+qcsvdgwtuYW5bgLEDEv6cqhsG8MWdMyEEjTf/qymI/Q
 8LMUIsZuDYMAjxFuGDAakiV3AHy03q6RJaDwOdq6EwoZtfyQcNlDtZY
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX72U2b4winICm
 c8LyOB46PfnyULvYGE4qGqK97tbQNwsbDlDOprbg63CNz8ta4uAbnK6p4eSF7Dcx5A3MXLAU/rX
 4eTn8KTXjap5vxiB3Q8PIyJXHsW2QIxuyvI7SCxe8epjhlFdgceW
X-Proofpoint-ORIG-GUID: zjEMqsLWeVXmvhuHlmzI9VInvrYNibSb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE3MDA0NyBTYWx0ZWRfX9MicKF6LbSwN
 T6DX97BlLwdAWS7b5NajDzK3XQ17frrqMYVCvcU4Q618jxrvSUFmdd+tS8RKZIUrPL7kLPlkdEO
 AtNOS0mI1Xisj82JMsy73VfCRqCq8+GGxS6Hj4shj4eP63jhvJW0xD+w24g9QtLl4RDsslI/Tig
 VNRERm3pCPtZn101bX9tuHERInSpOxOkNpZoAG+bkBJ1QEIIHbq4Fdxhp8jiyMccAx6JK8X3mt5
 E1t7gmZjYugogQ7niqMgX17oZVIm0E3F1B5GZXeHefbjms0i9S74Y1RNloW+nC/775bLUj5l41n
 6UY9ih2jK7OA7k+Ngm6/cGDNLyReIZIG3I0S1YcYRUsoQW2QmcNJ0ICuzivjgPUi/0spzf0D2gM
 Qbk74kOxDD75LPx7/uMSLeHLxk0lxfolm+7V/Z8dYEgxVEQ5bRrxWzcUOe5RTcLffZGxzmfgQaX
 zHmRdwAy2wgkYqDPNgQ==
X-Proofpoint-GUID: zjEMqsLWeVXmvhuHlmzI9VInvrYNibSb
X-Authority-Analysis: v=2.4 cv=CLS/zhrD c=1 sm=1 tr=0 ts=6aab65da cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=bC-a23v3AAAA:8 a=DYtDhnsrSwqEHnwMZP0A:9
 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11907
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 impostorscore=10 spamscore=0 suspectscore=0
 lowpriorityscore=10 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609170047

Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
options can't select the v1 space cache anymore, but the code is all
still there, and a filesystem with an old cache and no free space tree
still enabled it from the superblock. Qu suggested removing it rather
than converting its page handling to folios [1].

Patch 1 stops enabling the cache from the on-disk state, so an existing
cache is cleaned up on the next read-write mount, as -o nospace_cache
already did. This is the one user-visible change: the cleanup is now
unconditional, and a read-write mount fails if it fails. There are two
ways to fix this failure:

1. Convert to the free space tree during mount (the recommended
   conversion), but this could fail for the same reason.

2. Run 'btrfs rescue clear-space-cache v1' on an unmounted filesystem.

Patches 2-6 remove the write path, 7 and 8 the load path and
disk_cache_state, and 9 and 10 the SPACE_CACHE flag and the unused half
of the cleanup helper. Patches 11-16 remove the trimming ranges and the
free space inode special cases in the write path, which only the v1
writer used. Patch 17 removes TRANS_JOIN_NOLOCK, which the space cache
was the only user of.

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

Based on for-7.3-rc2.

[1] https://lore.kernel.org/linux-btrfs/e1dd5a75-9a67-4bc6-b8d8-bfff79b5b907@suse.com/

---
Changes in v3:
- Patch 5 (new): Keep the cache_write_mutex locking that serializes
  btrfs_start_dirty_block_groups() with btrfs_remove_block_group(),
  since it also protects the block group item update and not just the
  cache writeout. Rename it to dirty_bgs_update_mutex.
- Patch 8: Drop the "Old style space inode found, converting." branch
  from lookup_free_space_inode(), as it no longer converts anything.
- Link to v2: https://patch.msgid.link/20260913-btrfs-remove-v1-space-cache-v2-0-186767a7e106@columbia.edu

Changes in v2:
- Split the TRANS_JOIN_NOLOCK removal out of the ordered extent patch
  into its own patch at the end of the series, per David
- Add recovery information for a mount failure due to patch 1 to the
  cover letter.
- Link to v1: https://patch.msgid.link/20260907-btrfs-remove-v1-space-cache-v1-0-5f9a5ba352a7@columbia.edu

---
Tal Zussman (17):
      btrfs: stop enabling the v1 space cache from the on-disk state
      btrfs: remove the v1 space cache writeout from the transaction commit
      btrfs: remove the free space cache endio workqueue
      btrfs: remove the v1 space cache write path
      btrfs: rename cache_write_mutex to dirty_bgs_update_mutex
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
      btrfs: remove TRANS_JOIN_NOLOCK

 fs/btrfs/block-group.c      |  491 ++-----------
 fs/btrfs/block-group.h      |   14 -
 fs/btrfs/btrfs_inode.h      |    6 -
 fs/btrfs/delalloc-space.c   |   13 +-
 fs/btrfs/disk-io.c          |   81 +--
 fs/btrfs/file-item.c        |   11 -
 fs/btrfs/free-space-cache.c | 1630 +++++--------------------------------------
 fs/btrfs/free-space-cache.h |   29 +-
 fs/btrfs/fs.h               |    2 -
 fs/btrfs/inode.c            |  149 +---
 fs/btrfs/ordered-data.c     |   27 +-
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/space-info.c       |    2 -
 fs/btrfs/space-info.h       |    4 -
 fs/btrfs/super.c            |   48 +-
 fs/btrfs/transaction.c      |   61 +-
 fs/btrfs/transaction.h      |   29 +-
 fs/btrfs/zoned.c            |    9 -
 18 files changed, 273 insertions(+), 2335 deletions(-)
---
base-commit: 09f1294ee2abee7fe1c2d600671498b7642e0fe0
change-id: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

