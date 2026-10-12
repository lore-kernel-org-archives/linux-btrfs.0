Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EC93168E6
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791822521; cv=none; b=HRK3GdRPh2O/b1LJosbd5lhUevb4+CBjjNYEI0I2TxSSD+CKbippj5dMJojqufKxwLgGCP0wf09/YxGmClUHxRdV4P7jllqZEYlIy6OcChLzfyFwOfmwBuK5aTkOWx1SVP8aPbRLjHXaCzYf/krfoQEGH8l2Qa/xTVOBmbMOkws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791822521; c=relaxed/simple;
	bh=JAcD7i94Ac2+PLIMMjoqYux1WH2Dy++j0v9LJLa2Qqc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Cfv+sN7xB1D/zeC1b6voo71E3pLnACRFOKYWbhodqwztPFJXylEhBZThhICRFRRMz4+J7aT1dgdrVS/GRuWOhkkxCA9WV2aXTpEASQGjweTZ0AcC48e5PM3blRp3sUn9ZaO825TfgE9SFr96xg6Js9tE2yTNOlUFlYAWJbk7S+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=K32lLuaB; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=llA0fNjr; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="K32lLuaB";
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="llA0fNjr"
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69CExDWw915278
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=539Tx3d+i4nncCaf+noQuTTiO2
	p34fSq5OUzHLLDqqA=; b=K32lLuaB8l+kg3YO8vfiD09bCc7OVwWi1rO2TlJaSl
	4DEwFCFZSjZ71UTA+Ki9/FfEju4HFI8/IxEXjamhSuqvM4/OtaWYpyfmNqynkwSh
	EdRVmyg5Oyp4N89+OqbhJ3Bf0wcAbJBNt7jUK+aPGPcnkmllK298QuJdiEAm7AQ3
	I9iZPBHJVywZTqwMvWLNYarLAq0jQ6XSlau+Fl9B67hObQ/ISEKKZcmko5iYlpPf
	QnMDEzMEPuhNcsWmRIwpSC63vNppwlH1pPXbzfXjdkD+bZrHrqHl7dUPYjeaG8Fl
	hH9m25n0luqHjgxOuFYKHvy2eTbK37VJp77Hlg01JhjA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4h91sy90x1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 12:28:37 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-535213e3a7aso47573861cf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 09:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1791822517; x=1792427317; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=539Tx3d+i4nncCaf+noQuTTiO2p34fSq5OUzHLLDqqA=;
        b=llA0fNjrsDp1Mt4Ik1TnCgLOM1RQizr1O6GbO0VdJnus/YLOlOOA2Nv1KQIALoe+j+
         Lcd+/TUE5jaUfuMfZLahDge2PS/7vC70UB/fNwGTJLNFf8kSUYvCXlSPUi5zSRMjdlKT
         idJbmO4TWtL9soOYqpwB55qu+DLbuGMz0dlxIHhPVytW3VQJw8300/khci8wOp9o3XOp
         fkPhEswX4OdNJoY0CC1gbmPuIp66KXr3F/OYJRO7z0bI1J9I0d6Q0a94x2ZGv6fmQrDF
         MYbBFIxJKwKaab6oqtFHWfCF8ryl3MUvF24TYRtV4R9I+yOOKPbd/Mysg9heZD/X5u1f
         97rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791822517; x=1792427317;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=539Tx3d+i4nncCaf+noQuTTiO2p34fSq5OUzHLLDqqA=;
        b=NVPbFPjuzee03uEkYNGberdYryuBRltwOcj0L0Wv4S/uskUzRX0DsN9bVdrOjat5XT
         C+o5P8/ifBB2asQm1it1GwWuBQe1XZTir5mOV9uzSuIFnzFhncVx9ip/cbCmaixJqS+C
         3H4J6Z5rY5Dsq94RxvzMESL2vRF+cdzjlAM5QmEodDOVuqMGtOF93/WSNx0FTxhqitYM
         1Q0uqkqBqaJ5L/N7FvfNorIT3LHonmOvon66mtX3t4Kpf9KgEzH+yoiHKhXcVBGsLUpt
         40YlKJYhgHthQ5IT2/6WNTRXuJFoURQqByJuZByLSZlUMY1Sil7gaj2EZ2j4JqGIdoV9
         Tkbw==
X-Gm-Message-State: AFq9FYINvHCcqul8ko/9ELdM/j69s3CBhyD53O5MEV78FULDRGHrUz4K
	aUioFjpSvngnCdZ5zC5bvyehAUgN/52te4K8p84Vm5DeTG8bssBqBDK55OfeMwUYln1BwGS62oT
	Aeu38O513M2kuX/yn79r8rDYto6FUdA5vKG+vOesZgbvqOWziwsQ2xhY3w0SG
X-Gm-Gg: AYBFou2LWtNEsHAwyUlkKcFzqxBJdrWrQkpe6C5oRD6HshoSEjh+w6RYkHie9fr9D/B
	ByUUBrVA0yCZ7ZRlsR4CEppR6lrcZ/Gvy2n7pDp584YOtSRg9Kk0tlns5FFCwIFc/xu2vej6CQt
	FDm6ojq9QRDhpLID6OMVgj6XJUzklht003/dvBgqwU4o455lNftub36wxKBLGifQ8I9fWVxlZrI
	CTtepnEI2xG4iz8tVgfWF1GzZtbTcHn5e/elevY/aZiM0F5sg24f7vpGDgEdz4uESeDuQFOe12K
	8T7eEYFn+WlwdwH+YM+92ybo3g8P3z6zQ5O0wHheZMvzI5dcKghNmX18qz/ufO9jTl01T754IGK
	Yu6NJXepQqSY8Lbrj2BIN3PmeESal3RzSAAp7cXxGEftgH8s=
X-Received: by 2002:a05:622a:1342:b0:533:a4a:8826 with SMTP id d75a77b69052e-5359fade0d4mr170239231cf.19.1791822517044;
        Mon, 12 Oct 2026 09:28:37 -0700 (PDT)
X-Received: by 2002:a05:622a:1342:b0:533:a4a:8826 with SMTP id d75a77b69052e-5359fade0d4mr170238651cf.19.1791822516460;
        Mon, 12 Oct 2026 09:28:36 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-231.net.columbia.edu. [128.59.178.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97c27146sm1411796d6.29.2026.10.12.09.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 09:28:36 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v4 00/18] btrfs: remove the v1 space cache
Date: Mon, 12 Oct 2026 12:28:12 -0400
Message-Id: <20261012-btrfs-remove-v1-space-cache-v4-0-f125bd8c07f9@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJwKzWoC/33QzYrCMBSG4VuRrI3kxyTWlfchLk7Sk2lEW0nao
 Ejv3UQZkGHo8oXD88F5koQxYCL71ZNEzCGFoS+xXa+I66D/QRra0kQwoVnDNLVj9IlGvA4ZaeY
 03cAhdeA6pFvlvDKuUQYEKcItog/3t348fTpN9oxurGS96EIah/h4z2de736XzOJSSUaVb0BZk
 EqAObjhMl1tgA22E6ljWXxxXC5zonB8p402YJAz/Q8nv7nlP2RZOYa2RSZto/0fbp7nF4mRRd5
 5AQAA
X-Change-ID: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
        Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791822515; l=6566;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=JAcD7i94Ac2+PLIMMjoqYux1WH2Dy++j0v9LJLa2Qqc=;
 b=cTYeegRWhu43b32CWa3f8NMcR8+rGJjcWwKRy78qx2MXRr1t6Kpx6uHsPmK7WfehBHXAGv+bq
 KjDSzotmgBzBY70EbtF9x4CSdUdAtoH7P5P0dL0TM0dqumqLxJjkeAD
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX/S5OFJAI3cNH
 v9HWmFuviJa+Quf/COu/py2fWwViTO0CAwbYQTPwv6lxDxfaJW9vf7+ABBnqnATJkVZGbAPNcVN
 fPOH0475v+aGTrOUHgBHwDNuOkpssvKBfHs1DIPRC2i6OLOIRCZw
X-Authority-Analysis: v=2.4 cv=JMSuIMKb c=1 sm=1 tr=0 ts=6acd0ab5 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=9fnr1hFzp71kSIFw8uYQYA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=VwQbUJbxAAAA:8 a=iox4zFpeAAAA:8 a=bC-a23v3AAAA:8 a=IXpjHA8lEWY8KwlMyKwA:9
 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22 a=WzC6qhA0u3u7Ye7llzcV:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: Uc1hCFfmfnjaxKH0BispuBSEFA3ysBWx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEyMDA2NSBTYWx0ZWRfX0fuUjL/c3xQp
 2U/OVa94aHRShePQIk4YDC17m2X3oH2cDuYF5DWWZwWBcrcbMdtqSR9GZsKiIKVdOQYxkT4gitN
 TAt1pJEtmrRZHJWJtOrrp60l40erVLzW5r5eA9+g1fnyHtY+OcWjkiwLS1400wMFPYbxIRtzzAy
 Y2yg/jtRYyD+Gdk5D/6q7pbxn64jwp4MHNQ3OAHu+FO2Sv2oUqOxCk9xx+4Shut88OXY1Qdv6Aa
 vbyjYs/X8ry56pILEmrNLKN/b0StwaxHp2ZWFEJNN8kJ7Xjd1Nri3EM7hsQ/wIFBmTzohYLQNfS
 r9GMeXOhsiNA0wOsHolzQKmwdpAs9mSLAhIbjg+uv5GYBLcVxHn5bbnV3eIGuDqaJ10pZ9BLyrn
 zL26U8L0461OJk122k1OkYbl8Wznl+eOiMVqfcZvdWo9fnIeKHX1RY0WtcOZqV+AiqmXcgy4/3S
 A6iZ8XqJAERYGMg57Sg==
X-Proofpoint-ORIG-GUID: Uc1hCFfmfnjaxKH0BispuBSEFA3ysBWx
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11933
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 spamscore=0 phishscore=0 malwarescore=0
 impostorscore=10 lowpriorityscore=10 adultscore=0 bulkscore=10 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610120065

Since commit 545e560a5b0f ("btrfs: disable v1 space cache") the mount
options can't select the v1 space cache anymore, but the code is all
still there, and a filesystem with an old cache and no free space tree
still enabled it from the superblock. Qu suggested removing it rather
than converting its page handling to folios [1].

Patch 1 fixes a pre-existing leak in the cleanup path, where a crash
before the delayed iput evicts a cache inode left it unreachable with
its link count still set.

Patch 2 stops enabling the cache from the on-disk state, so an existing
cache is cleaned up on the next read-write mount, as -o nospace_cache
already did. This is the one user-visible change: the cleanup is now
unconditional, and a read-write mount fails if it fails. There are two
ways to fix this failure:

1. Convert to the free space tree during mount (the recommended
   conversion), but this could fail for the same reason.

2. Run 'btrfs rescue clear-space-cache v1' on an unmounted filesystem.

Patches 3-7 remove the write path, 8 and 9 the load path and
disk_cache_state, and 10 and 11 the SPACE_CACHE flag and the unused
half of the cleanup helper. Patches 12-17 remove the trimming ranges
and the free space inode special cases in the write path, which only
the v1 writer used. Patch 18 removes TRANS_JOIN_NOLOCK, which the space
cache was the only user of.

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

Based on the misc-next commit in btrfs for-next (a5c77fde6730).

[1] https://lore.kernel.org/linux-btrfs/e1dd5a75-9a67-4bc6-b8d8-bfff79b5b907@suse.com/

---
Changes in v4:
- Patch 1 (new): Write the zero link count when removing a free space
  inode, so an interrupted cleanup can't leak it.
- Patch 2: Clear FREE_SPACE_TREE in btrfs_reconfigure() whenever the
  free space tree is not on disk, so a remount that only warns about
  the free space tree no longer leaves the option set, per Sashiko.
- Patch 2: Dropped review tag.
- Patch 16: Also drop the tree root check from the delalloc metadata
  release.
- Patch 18: Redo against the TRANS_* flag cleanups in for-next.
- Link to v3: https://patch.msgid.link/20260916-btrfs-remove-v1-space-cache-v3-0-10ebde03b96f@columbia.edu

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
Tal Zussman (18):
      btrfs: update the inode item when removing a free space inode
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

 fs/btrfs/block-group.c      |  497 ++-----------
 fs/btrfs/block-group.h      |   14 -
 fs/btrfs/btrfs_inode.h      |    6 -
 fs/btrfs/delalloc-space.c   |   13 +-
 fs/btrfs/disk-io.c          |   81 +--
 fs/btrfs/file-item.c        |   11 -
 fs/btrfs/free-space-cache.c | 1670 +++++--------------------------------------
 fs/btrfs/free-space-cache.h |   29 +-
 fs/btrfs/fs.h               |    2 -
 fs/btrfs/inode.c            |  157 +---
 fs/btrfs/ordered-data.c     |   27 +-
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/space-info.c       |    2 -
 fs/btrfs/space-info.h       |    4 -
 fs/btrfs/super.c            |   48 +-
 fs/btrfs/transaction.c      |   62 +-
 fs/btrfs/transaction.h      |   27 +-
 fs/btrfs/zoned.c            |    9 -
 18 files changed, 304 insertions(+), 2357 deletions(-)
---
base-commit: a5c77fde6730d32128ca69fd0c4e2b80f6012c35
change-id: 20260906-btrfs-remove-v1-space-cache-45cf57c957a2

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>

