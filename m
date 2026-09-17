Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAAE51475F
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789655755; cv=none; b=hF1Tm/qHQQsmSkwBIPAWb2lxte1RiOe3EI52EuiwP9ZmtL3KAO+fjyikbAmFdSHvFOEiIScgj0yzi2jzWEwk5tdsJaWaaSkumSVrkP0mO3LRFDCS7bp6K0f0s2P4KSjVb1KHkffKryvvZSZqhvayNLJaCNoLiexTZI9G9ChtQLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789655755; c=relaxed/simple;
	bh=tkugapicG+oS5Jhk0MhEdLUD3rf9GOCor0Wj7bcB3aA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+qB+zZxyu3hTRpzx7B27Rd1LFYDFhJV1UdEiOo8TnzZisxZcb5uqSsRWdWtzXL74aQpNaAxN+E8OGhlgypG7TXxqM5JGP+Yj3Dkr5RULVIlZ2Ayx9SGSxyemuNDWjZzN7DIIF56HcvVijheDpGEVtDvEuJOksrzi24fZa//8C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZSjBwtcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZSjBwtcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF991F000FF
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Sep 2026 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789655753;
	bh=/Qxi8LLopFmVDHUxX8jyvTzahLxVg0pQCDJA1fBTl6k=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=ZSjBwtcjZEkOsmGWN8a4LCzTF4ZMVkxV+RwaFQhehI4sumJ2uhHLZ10QsFamBDG5R
	 rFn5V0+SYMBN0YAaNRfY3OemakK4T0Ta6mJhXa4ZLh0IWJdItk6CkFrH1SUDXnHM5H
	 9FYnFFl8EQWevrmZ2jcPIhhtCNTfsJLtkJYnbAQFw9CPt/zYgX9mx7DHcbMgSJmVuw
	 VMgprIYrkDwpOhRRCIeiQEMCNB7uslQYnDO8EaM7ht1Z7WS8mfRRosxZmryLkqIDrZ
	 ydS5NL936TWLUCZGJl738a+sMs64fU3u69kkruTpgB1d7YP8VFcDGZlLXRI6Be5uZF
	 nV3FzYOzciZBA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix off by one super block end offset calculation when writing super blocks
Date: Thu, 17 Sep 2026 15:35:50 +0100
Message-ID: <1fe43f9a18a78de389ef66c699cfa906408285db.1789655618.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <c5e7ed76826ca4504f5b0bb7de9f5f2e45365143.1789642741.git.fdmanana@suse.com>
References: <c5e7ed76826ca4504f5b0bb7de9f5f2e45365143.1789642741.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are skipping the write of a super block mirror if its end offset
matches exactly the device's end offset. This happens because we are using
a greater than or equals comparison instead of just a greater than
comparison.

Fixes: 935e5cc935bc ("Btrfs: fix wrong disk size when writing super blocks")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Fix the waiting counter part in wait_dev_supers() too.
    Changed subject.

 fs/btrfs/disk-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a8535e309b57..90cf0647c47e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3909,8 +3909,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			atomic_inc(&device->sb_write_errors);
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
@@ -3988,8 +3987,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				primary_failed = true;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		folio = filemap_get_folio(device->bdev->bd_mapping,
-- 
2.47.2

