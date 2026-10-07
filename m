Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E8A345EA3
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791384979; cv=none; b=UBFOoA731JkPVehhDlgy4u2mJF835Gw3Bf4wgVcO4jP0/qqyXTwgAUlkVh+YaHTem6oTORfRmrWGH+4xeBVReGtjKGegSR7PmzohSpVS8W7dXP2XMGhBF0HDete+qQDm4wBT/oZcWMVDo7XM3dSlKSsPIjNX4cuOkt7iA2ctO8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791384979; c=relaxed/simple;
	bh=9jzR4ONKMKiJROihpor/zhP0GkHS1nKxdtfKCkB50dw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZC/+/Ir9Z6Q6Kk20t57FtW6QaGbKXsIFKj3VsUQe73Oyk/WrtxvyrU7coEcsAPJWrq3fKZLR8tyzi68R3k+fEEHAhARU5OT/3ihh28i2kGXXM5wB3JnE9v4hdppoYDtdIWK0s0ketj7FJf5UdwXoyasMYmD/wWk7Q1eAFchmZEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAGqp8qj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAGqp8qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDC41F00893
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Oct 2026 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791384973;
	bh=bp4yx7RZkiCzgg62v/1MlcsLEO+hidTrUTALG8Nk0s4=;
	h=From:To:Subject:Date;
	b=jAGqp8qjZA50aISYRPOd6vgaoLk1Ry4jB2kKDFWmG8ML67oP99hv94NLHJYM1437/
	 D4MekxJ4N4HPzhSa8m2m2/Pq9e8UogeZzoAW62kTozcvZIZS3/M9PiYHpKnS7qBU7x
	 g4hBEXKCY3ZSjkTARgP91lVBp4vrDfiEeRQ2qdJGZRKv+uoVe2MSyrTL7FIueEW/Jx
	 3CmioaYi8VZrN3qnY8xkWXhNQt/O9QnRnz/ZXNqq8hXfT8hszYsTJGNgDAJQpu3p/L
	 tKjphDw9gadJ3oX17WMfr5/2sqaKMgxTi0vJvadTAMRUWMZZcr9SkCORExjCzzNuoF
	 PQlnNPI8cPYdw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: defrag: fix key comparison with max defrag key in btrfs_defrag_leaves()
Date: Wed,  7 Oct 2026 15:56:09 +0100
Message-ID: <7c5964a3dc1d6cfef098dd3d4f1abdfac068aafe.1791384948.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The comparison can not be done in isolation for each key component (type
and offset) after the objectid component. For example if the defrag_max
key is (300 2 0) and the defrag_progress key is (301 1 0), the existing
comparison makes us jump to the 'done' label with 'ret' set to -EAGAIN
because 2 > 1, resulting in continuing to defrag despite having passed
the objectid of 300.

Fix this by doing the comparison correctly with btrfs_comp_cpu_keys().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/defrag.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 6ec5dd760d42..75c87aee5de9 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -530,11 +530,7 @@ static int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 out:
 	btrfs_free_path(path);
 	if (ret == -EAGAIN) {
-		if (root->defrag_max.objectid > root->defrag_progress.objectid)
-			goto done;
-		if (root->defrag_max.type > root->defrag_progress.type)
-			goto done;
-		if (root->defrag_max.offset > root->defrag_progress.offset)
+		if (btrfs_comp_cpu_keys(&root->defrag_max, &root->defrag_progress) > 0)
 			goto done;
 		ret = 0;
 	}
-- 
2.53.0

