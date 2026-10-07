Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C9D221F24
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388608; cv=none; b=ibv+Wj6fi3ru1ipnjj+AeEQ9/xQkAJ+mNyvfb5+AVkCQfIMELAdx4wN0/eW0bjtXzuo1GDueCJH+sSZ8rEqfLgs61O0fweIvgM8nckTLRTSXxbMvRbO9WSOA8op5d3hcYlkb9pmrGVW6M0bh7lKscnyR/ZIw49BnHb+/zye+TwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388608; c=relaxed/simple;
	bh=pPVrV/2WzL7N96nw0kgeAidh+olLE1M63O2AzyLesmM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y9yoNDlDI3ksPINutTsjpXNxAWP+2J8RWYKUxkK0mSAIlvEMEAVBCl7idPvF5nKTdgwtFB0/NfwWRYXL+x1FRkiwnpJCADAmxl15nYooJe801PMP3GW4dX0Y7iVqO/bHiVKeNbhZBsR5f+yb61uZ6GRJAWgxU3Xt+atmSFKCnJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VA6vG+JW; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VA6vG+JW"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3a4b9732d5aso1933890a91.3
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2026 08:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791388606; x=1791993406; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7giGpQ+uI3o2xiXlAINjrMFLTWGSCC1i0BPrzI4PYPE=;
        b=VA6vG+JWzgrr02Ijgd+ho5+jzaTovoNHQG+5oW3S+LCPODY7sVqXBYv0+vlb6VHCQ8
         vsRUzOXBHoXctQoN3SHqsIRbG5n1xNicsMoPOsv34uqG4FyjcPKTU3xx0U6g+MyxPr/R
         zx0HPmJCiTesdwpeuW01I/HzWNdTYSvDHwUeOv5jAyQXFC2GxdicydKFmJMYkWQNxrbu
         /sHjAS6OEk0v45tpzf8tNobX9zuBD/Vua9K9g0GVyeEINum/4H8fh5uHRJW2SJjS/eYC
         rxnWUPfjuQBNko9V839kycpy56+f6cse+zDq+/N2ZeoKNmEgUApCTpCMMk1z8b/tyrrD
         X46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791388606; x=1791993406;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7giGpQ+uI3o2xiXlAINjrMFLTWGSCC1i0BPrzI4PYPE=;
        b=fByoRd2Q20vIz9fxOkP1CWUW+XUoCPcGi30AqGlm0qw9Nq1Vxj/Fs2Khfiliu5gmON
         QEERc1N/odKa69Os6e5VckK6+iT3KL3vxhPMYabj44peDVU+nncr2r71SG/qu1RBrr38
         0UisldYBSScjua9rs5E+5tISvN8HQkVPvQkBTJaz6eFFJdKMTAVixn6zowO9Ymj3dses
         YuUsww8VQilqdAyPdOx/bMDSi0ItA/GzdMf2SNf+iYODKhS/bDqKcR8aJXXi3UwHQ0tG
         feOCJeF5gL/TEvA7hDEUjMzjvuRqOmDdlb3SFqZ9YRxMrdV/Zc8MdAp7JFeJKt/yW2wH
         vmqw==
X-Forwarded-Encrypted: i=1; AKwUvBzI0JHb9XPYiwF8kPaVxaWkQ3mK3Uwv63r2ly+vmiEbk5XKzYTIbL2ZAF7xoJNhj232nMzVSPCwwPVBCA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIbJvlItouNkvg7RTe02h7k2GuxDEqN7gfOTcPuDPu0HWVwrWq0
	0Cm6BJ1LXZ+aAOnqKrMa54vcpRFo2eq4tRnOWlVD2UktyUoQUQ6Wq9IZ
X-Gm-Gg: AYBFou2yEWCfsOxBPjJU5uSm8uapRjiKlC2F3JyK/3OYKJfG+p9O04PL4hvKrstIMWS
	jdJtxrEoP9mabO0eKLt1xjBfW9+uU9cfTzgrWMV08W7OGRWz8Z5gZjB2z0BwhOerpv0e4hN/q+j
	m13nGIweanyDXEY9gObZM5vRdFMU7BKnx2IoHlTvIVZ0Le/9iNwPRwXmUih4WT55XJIJ79vbSyF
	edUtT3DeIGOyXlWpykc9rXeGizrSOjBUDQJ/nXog/5njqmEfr4fYFWE0tIYSXf9ZkBEp5T9R3Bp
	wUqbSoWxJK511WX6EbnFlEkC7edvjFIAoOQBQ+QWK6F2lRaVSKUliq3DpFulA/uHqvCJk8hS21j
	8j0ww7AFO+/7ky20ZiH8CXHQRbJ8kMgaIgjZQnNFOzS6t/qoclAGOm+WiT6iORug8LfDzjtTKRh
	yeuDnRwV0UhLkQ2M1ij+73OAwJrto4Me2ebj01VYqb94xNnEgOZIzqJvwKyODISoOpgOnqyaovO
	X+Kew==
X-Received: by 2002:a17:90b:3809:b0:3a8:6e79:6e35 with SMTP id 98e67ed59e1d1-3a8a0851561mr2418450a91.19.1791388606298;
        Wed, 07 Oct 2026 08:56:46 -0700 (PDT)
Received: from user.. ([2405:201:c052:b00b:836d:b1f5:934e:51ea])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff8d5896sm22432a91.12.2026.10.07.08.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 08:56:45 -0700 (PDT)
From: pavankumaryalagada@gmail.com
To: dsterba@suse.com
Cc: mason@kernel.org,
	wqu@suse.com,
	fdmanana@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>,
	syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
Subject: [PATCH v2] btrfs: fix use-after-free on quota enable allocation failure
Date: Wed,  7 Oct 2026 21:26:32 +0530
Message-ID: <20261007155632.155645-1-pavankumaryalagada@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>

The quota root remains on the transaction's dirty root list when
btrfs_quota_enable() fails to allocate a qgroup structure and releases the
quota root. Later add_root_to_dirty_list() accesses the freed dirty_list,
causing a slab-use-after-free.

Abort the transaction on allocation failure to clean up the dirty root
before releasing the quota root. Also remove the quota root from the dirty
root list under trans_lock before releasing it.

Reported-by: syzbot+947286c775f432b073a8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=947286c775f432b073a8
Fixes: 8d54518b5e52 ("btrfs: qgroup: pre-allocate btrfs_qgroup to reduce GFP_ATOMIC usage")
Signed-off-by: Yalagada Pavan Kumar <pavankumaryalagada@gmail.com>
---
v2:
- Keep the transaction abort from v1.
- Remove the quota root from the dirty root list under trans_lock before
  releasing it, as suggested by Qu.
---
 fs/btrfs/qgroup.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cf8dfd5c692b..d5eaed5eec03 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1207,6 +1207,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
 	if (!prealloc) {
 		ret = -ENOMEM;
+		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
 	qgroup = add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTID);
@@ -1296,6 +1297,14 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		 * sysfs entries.
 		 */
 		btrfs_free_qgroup_config(fs_info);
+
+		if (quota_root) {
+			spin_lock(&fs_info->trans_lock);
+			if (!list_empty(&quota_root->dirty_list))
+				list_del_init(&quota_root->dirty_list);
+			spin_unlock(&fs_info->trans_lock);
+		}
+
 		btrfs_put_root(quota_root);
 	}
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
-- 
2.43.0

