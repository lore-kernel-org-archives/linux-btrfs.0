Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644223A5E92;
	Mon, 20 Apr 2026 13:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691039; cv=none; b=jZSzAXFzNUckddNJ/AURAQ8NF3+aZ+6CP17olgqeqnWk8VWkv/xfXYLbpCHax95Vcslzqg4A6Jm25oFNdB77a7OLgDov5qg9wOMctMm5zdDW2HDj241TAWnfbvuIy68slhRFkWwN1Jfi7A/Q1tA0MhZvB9oVKjlfp/WwVn9kpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691039; c=relaxed/simple;
	bh=NWaMfhADkFs8adYX4BONkjmh2cuUY93pvd7Wvpcbq2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+sHL7SOhEqOqyHYjXpQyF8wqFlEneHiqaeZaw97Z0u/11cCU+k0nXj0/ms6FapNfZubB6VXA9f1mhKRDUF19WwLW3230XIZg5JsNGpWic0Hao4YTSMBMGcHM7xKoadaLKfT8NecHP3zAnSGKaJh6mF2tchdYb2X/Ufpq+tf7GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ip+OD/nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ip+OD/nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C3BC19425;
	Mon, 20 Apr 2026 13:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691039;
	bh=NWaMfhADkFs8adYX4BONkjmh2cuUY93pvd7Wvpcbq2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ip+OD/nq2ETmHoGAArfGZ9a6mxIAqIjiLRRXiX/JiBQmR/+06C9RkWNe0lXRia4Xu
	 QbdFU43WJ3OTvAb+6xBaAZQa9wbVDe+fRSxinb+9FraDS0HlQRKas3D8z1im837sCf
	 xvsRreBWCuy5UTbVbH/xbNYNy6r8W8DukoElGTBQ4G8Dloi8xrnMtyerQCzaI6Ej1c
	 QPZ4zTzeZLB9FRaRfb0c0X4Pbphl17068iajvXsCUJy4UIEPa1gKJ3imqYf9i1DhVc
	 SVWL7cLEasl7Y/kAtY+blkUHdNCLpv73zl3yxq1WUeJeCifHO8aya1rvrsXxG9jpyq
	 SmTs+a7U05kIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Boris Burkov <boris@bur.io>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	clm@fb.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] btrfs: tracepoints: get correct superblock from dentry in event btrfs_sync_file()
Date: Mon, 20 Apr 2026 09:08:44 -0400
Message-ID: <20260420131539.986432-58-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

[ Upstream commit a85b46db143fda5869e7d8df8f258ccef5fa1719 ]

If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
super block and fsid assignment will lead to a crash.

Use file_inode(file)->i_sb to always get btrfs_sb.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 include/trace/events/btrfs.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 125bdc166bfed..0864700f76e0a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -769,12 +769,15 @@ TRACE_EVENT(btrfs_sync_file,
 	),
 
 	TP_fast_assign(
-		const struct dentry *dentry = file->f_path.dentry;
-		const struct inode *inode = d_inode(dentry);
+		struct dentry *dentry = file_dentry(file);
+		struct inode *inode = file_inode(file);
+		struct dentry *parent = dget_parent(dentry);
+		struct inode *parent_inode = d_inode(parent);
 
-		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
+		dput(parent);
+		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
-		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
+		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
 		__entry->datasync	= datasync;
 		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
 	),
-- 
2.53.0

