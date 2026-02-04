Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC92421A09
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770220337; cv=none; b=tlb+R1mFZxWsXodAZXZmju8YjtgLrfmxrUMJjH2kcSCNii4OwAmfKxnt6UIdHgjGpZehIFuucivnCZxDG2P6nclwKrJ84CYmCqDqCOjdR99XcU6XadaPz+vQ4iTxY9gZPm/p/a9eefi4iXfT/juykzepbbEprZZq1lXuUGzThdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770220337; c=relaxed/simple;
	bh=EWwYm0nYqMXmp7JNWr5pwnl8bQI2CtvpHVqbF4g9aeM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoZ2zweaSzZG76oZ4bzyXMGaCa0eYfvkB6G5Fb58PvLCNoDbxN1meCqAKDG0uMrsT5APyBcUZyiL31q7pq26gqOy1g3QzOMVNVmMSAtZgoFslcSYg1c1tlvxu/KfuHTQ1PGlLuyKC6U7ghCGZlSNobqyUBDqITM1h5orpQ8rFuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VBVEghIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VBVEghIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0B6C4CEF7
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Feb 2026 15:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770220337;
	bh=EWwYm0nYqMXmp7JNWr5pwnl8bQI2CtvpHVqbF4g9aeM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VBVEghIWRzA43ytVXshuuHECtPUYZh6tNA9e4zIKhtpL/kcprSnePbQ6PbsouFDb5
	 BetMwZPl0L9Ri0MsdxEYiMRJcv4NROcBo14OEyt6suxZnQyxkB45pLLEM49EpKzI9F
	 pDIQYCFqKaPdEY4TFnvzzmfMl74ZqUpfg5mz2uFCqWjLt8beylMue4g2OD6bxfuudL
	 tLL33QiKcTp1hYwhy6Qs5wt9WJrHsUEKqRzS5UKQOXNF6JCDJqoR55UaTPEwV5j5y1
	 M1SGLHliT/1OZGApby39S2Hh0HLK0PTw5nbfPyvQ2ayPPEqbpTgXrlQC7q0a6rfSDf
	 3WhZdh2zr/dZw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/7] btrfs: abort transaction on error in write_all_supers()
Date: Wed,  4 Feb 2026 15:52:01 +0000
Message-ID: <0242bb37bee8b5df8abd8c663b1d626e3e3b8b61.1770212626.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1770212626.git.fdmanana@suse.com>
References: <cover.1770212626.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

We are in a transaction context and have an handle, so instead of using
the less preferred btrfs_handle_fs_error(), abort the transaction and
log an error to give some context information.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/disk-io.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6454cbbcaa88..6e474c2d6b74 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4054,8 +4054,8 @@ int write_all_supers(struct btrfs_trans_handle *trans, int max_mirrors)
 		if (ret) {
 			mutex_unlock(
 				&fs_info->fs_devices->device_list_mutex);
-			btrfs_handle_fs_error(fs_info, ret,
-					      "errors while submitting device barriers.");
+			btrfs_abort_transaction(trans, ret);
+			btrfs_err(fs_info, "error while submitting device barriers");
 			return ret;
 		}
 	}
@@ -4089,9 +4089,10 @@ int write_all_supers(struct btrfs_trans_handle *trans, int max_mirrors)
 		ret = btrfs_validate_write_super(fs_info, sb);
 		if (unlikely(ret < 0)) {
 			mutex_unlock(&fs_info->fs_devices->device_list_mutex);
-			btrfs_handle_fs_error(fs_info, -EUCLEAN,
-				"unexpected superblock corruption detected");
-			return -EUCLEAN;
+			btrfs_abort_transaction(trans, ret);
+			btrfs_err(fs_info,
+			  "unexpected superblock corruption before writing it");
+			return ret;
 		}
 
 		ret = write_dev_supers(dev, sb, max_mirrors);
@@ -4104,9 +4105,8 @@ int write_all_supers(struct btrfs_trans_handle *trans, int max_mirrors)
 		mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 
 		/* FUA is masked off if unsupported and can't be the reason */
-		btrfs_handle_fs_error(fs_info, -EIO,
-				      "%d errors while writing supers",
-				      total_errors);
+		btrfs_abort_transaction(trans, -EIO);
+		btrfs_err(fs_info, "%d errors while writing supers", total_errors);
 		return -EIO;
 	}
 
@@ -4124,9 +4124,8 @@ int write_all_supers(struct btrfs_trans_handle *trans, int max_mirrors)
 	}
 	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
 	if (unlikely(total_errors > max_errors)) {
-		btrfs_handle_fs_error(fs_info, -EIO,
-				      "%d errors while writing supers",
-				      total_errors);
+		btrfs_abort_transaction(trans, -EIO);
+		btrfs_err(fs_info, "%d errors while writing supers", total_errors);
 		return -EIO;
 	}
 	return 0;
-- 
2.47.2

