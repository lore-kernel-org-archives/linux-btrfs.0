Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157183859C0
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775722318; cv=none; b=NDhqtBOM0nSs9/w+iAZ4jXYWp/DsRjkOC229aOluSG3R0PgHXdEAr76X9hXc3fuXw8ifmcdbs+g1DEKhO749bIQhi/nJWBfUUQMiXUxm4OfIFH4+gmszQdgRL1YXLhw2rKax5nC1MIJvn9Fk1J2ccHvaNO09gZt8sxeVNwYUChI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775722318; c=relaxed/simple;
	bh=4FmYzVSLwZ4TOjkqmnh54MQ8cMq8i1uy4Ite11pD2oU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ogCkBeIS06hbyMh8wmiwkVuuZvUw0suU5YUv7zJm2UGrYAVA1Ktra4zc097sleUArdztpUqEvO2WVS5ynuX8GHSi2BYXs1WhiVL/YQdu5wFGVvocLjuUal1dDCTYvCZhTGxfkprGLyXq0DkL3jjjcihnqvHAEetO3ZxiVf+6Ajk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HfEOEJ0L; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HfEOEJ0L"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c74f0c3fc16so239040a12.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 01:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775722316; x=1776327116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4nsehLI9jIB2pvtAUMLCIGtoJBjqHEt2917WeRtwqXk=;
        b=HfEOEJ0L5kpWcGo/ia96LqjbvwlwVEfUjvP1k4gBLNUCmT0tpV00CzEIvnf+SiKhMe
         3bkTWDF3bQYPCefcOAm511jaEu4Zj/731W76M0/8Lf/F9vH3eekTLbQkGduAlF10gfBy
         swyyE3AQVzlsCi3SpbRBVhj7KaCDwQ+dmiS0Dy1KKIXwxAkgbzQFV+01ydT3k3Erh0AQ
         8aNGF2fvRXV3WsebAKg8BitR7FMmxbBUbpcRJ7otvhbf4N6GjRuZynNNjBUCQf/Wfnf6
         sN97cKtGptS7ms/4H9JEmCVrsMztobo1H5KOTWa0oDeWNcpas4pzYk6igJiKi8k+9hgp
         oArg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775722316; x=1776327116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nsehLI9jIB2pvtAUMLCIGtoJBjqHEt2917WeRtwqXk=;
        b=T5pwZHytj4DbPzc4m+70T6Rq6f7F5C0fasfc5UFIMn++tymVoaRTKgxvj4GZEspQJt
         3DrrShdk5OkiNwJaQvDmGIQlPvl18DEuo/DORwqU00w4eN0jqT64Nh1LsLDgS+hVRk6k
         h4U4YwPVCNTu7WEFc5mc1BIxhAqhOO0qa6aYvH6XEMzslg01ADiubiqIFcM9TsLFC+BX
         xt7+mJJLLdhlrm9U/4sTRJFqqXj7ahyCS9ir9fbV2RdO+DWvZa5gnKwaZp3VB6hUeCL3
         pu1cmbv11qiJiojfsmJRQfSDlPyVoROENj1J8FA1rjYJJOZsbfnSgB5krJub4NyQYLt0
         PmRQ==
X-Gm-Message-State: AOJu0YzQ/qxQG0LJyUgxw2AJawWomAU+CMkbgPnNEkvSUakANfIDKIAb
	DNIyIXMV38SpuzeaA8JThu9FUfnrc/csh3zInqRt5tCGeqs41x/nxJ/r
X-Gm-Gg: AeBDietv0BEGj1wHpc4Z5kB6vt0pnnFxPkBtvajKinxllooXoFGqAiBaZpnNzGzTunU
	qDoPBNntMt/03r58vNluIquB99y5tCsCJ/7qmBKPuRCSBgbJ5E8N1Wl80yLIFQ/+2cHhfL+DcD0
	M1LReEuZ3ycmVTld/IC+zPcID/EjJlM/tTVbNiF0gCPs97YdX+CSKTWdQCgIxtFoiozzrIYz/WH
	DKcImS1ALzKq58Y7iBmg5p85P39O98Sv/Szc/4mcSdbmyIDSenJgIyznIsmjMbw9snGc8O1ku85
	wsHTlV0sd89y+8NzJtZ+kN/vhzTLuPHOPw1mey5+49kbYtmk25o+sI6Pwuzs+/GObtbnZysQtB0
	cN9ikoUjXJ6G7xK8OC+dPKMbdJLfBh88QTR0ru/fXP/XljWb3s6cwI4xaJGNuSGNRe1FN5CGXDU
	A06vfc3iQ/Lmvr3jyG4X8P80mJArH3fLY6y53asojXQ3atC7B4fCYXwipBo74nOvNTN+C+hoTyQ
	BN5ptba
X-Received: by 2002:a17:903:38cf:b0:2b2:ccfb:8387 with SMTP id d9443c01a7336-2b2ccfb8623mr10523125ad.28.1775722316202;
        Thu, 09 Apr 2026 01:11:56 -0700 (PDT)
Received: from kernel-fuzz.. ([138.199.21.245])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27478bc96sm239544935ad.33.2026.04.09.01.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 01:11:55 -0700 (PDT)
From: ZhengYuan Huang <gality369@gmail.com>
To: dsterba@suse.com,
	clm@fb.com,
	zheng.yan@oracle.com
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	r33s3n6@gmail.com,
	zzzccc427@gmail.com,
	ZhengYuan Huang <gality369@gmail.com>
Subject: [PATCH v2] btrfs: reject empty non-root tree blocks at read time
Date: Thu,  9 Apr 2026 16:11:40 +0800
Message-ID: <20260409081140.3400650-1-gality369@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[BUG]
A corrupted tree can contain an empty non-root tree block linked from
its parent. If that block is later used by normal tree balancing,
btrfs can hit:

kernel BUG at fs/btrfs/ctree.c:3388!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:__push_leaf_left+0x11f8/0x1610 fs/btrfs/ctree.c:3388
Code: ff48c1ea 03803c02 000f85bd 00000048
Call Trace:
 push_leaf_left+0x3b3/0x540 fs/btrfs/ctree.c:3511
 btrfs_del_items+0x74d/0xf10 fs/btrfs/ctree.c:4541
 btrfs_del_csums+0x44d/0xa50 fs/btrfs/file-item.c:969
 do_free_extent_accounting fs/btrfs/extent-tree.c:2984 [inline]
 __btrfs_free_extent.isra.0+0xded/0x41d0 fs/btrfs/extent-tree.c:3372
 run_delayed_data_ref fs/btrfs/extent-tree.c:1599 [inline]
 run_one_delayed_ref fs/btrfs/extent-tree.c:1779 [inline]
 btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:1972 [inline]
 __btrfs_run_delayed_refs+0x86e/0x39a0 fs/btrfs/extent-tree.c:2047
 btrfs_run_delayed_refs+0x181/0x420 fs/btrfs/extent-tree.c:2159
 btrfs_commit_transaction+0xc9b/0x3d90 fs/btrfs/transaction.c:2211
 btrfs_sync_fs+0xf0/0x630 fs/btrfs/super.c:1057
 sync_fs_one_sb fs/sync.c:84 [inline]
 sync_fs_one_sb+0xf4/0x140 fs/sync.c:80
 __iterate_supers+0x1be/0x290 fs/super.c:923
 iterate_supers+0x24/0x40 fs/super.c:938
 ksys_sync+0xb4/0x160 fs/sync.c:104
 __do_sys_sync+0x13/0x20 fs/sync.c:113
 ...

[CAUSE]
The old btrfs_verify_level_key() path rejected tree blocks with
nritems == 0 whenever the parent check provided a first key.
Commit 947a629988f1 ("btrfs: move tree block parentness check into
validate_extent_buffer()") moved the parentness checks into the read-time
validation path, but it dropped that guard. This lets an empty non-root
tree block pass read-time validation even though slot 0 must exist if the
parent provides a first key.

[FIX]
Restore the nritems == 0 rejection in btrfs_validate_extent_buffer()
when check->has_first_key is set. This rejects empty non-root tree
blocks as soon as they are read from disk, before later btree
operations can hit BUG_ONs while trying to use them.

Fixes: 947a629988f1 ("btrfs: move tree block parentness check into validate_extent_buffer()")
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
---
v2:
- Move the corruption check from push_leaf_left() to read-time validation
- Restore the old nritems == 0 guard before reading slot 0

 fs/btrfs/disk-io.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0aa7e5d1b05f..ab2044d83155 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -430,6 +430,15 @@ int btrfs_validate_extent_buffer(struct extent_buffer *eb,
 		const struct btrfs_key *expect_key = &check->first_key;
 		struct btrfs_key found_key;
 
+		/* We have @first_key, so this @eb must have at least one item. */
+		if (unlikely(btrfs_header_nritems(eb) == 0)) {
+			btrfs_err(fs_info,
+				  "invalid tree nritems, bytenr=%llu nritems=0 expect >0",
+				  eb->start);
+			ret = -EUCLEAN;
+			goto out;
+		}
+
 		if (found_level)
 			btrfs_node_key_to_cpu(eb, &found_key, 0);
 		else
-- 
2.43.0
