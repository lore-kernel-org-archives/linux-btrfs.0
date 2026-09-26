Received: from mail.archlinux.org (mail.archlinux.org [95.216.189.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8771640E8FC;
	Sat, 26 Sep 2026 10:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.189.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790419059; cv=none; b=eeqQY257pw4QWxIAUY1fjB/f9apM6YBEq0DQdhTGHNHFN0Q1hhgOk339627TUvoq0KGR9J652j3TjyXQ7g5mJlReoGVtz+npyageT8owu3BmN2jUq5qk0se8FqUpnDJggTd9/X8qDISyPxHAYkf3WwU/QVXHJxBY/WO8LSTGCaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790419059; c=relaxed/simple;
	bh=4GVeqMERXyHpmGSmlHtJlc98rb5ykv8YtG7KQHafA6I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pVe1Cfdf7kJiuNfCrKZLleN7yauaDQMFlLLYozDzpkgTBISUClym85NvbKwq4+7Bpaz0eRDHKECJqrWsmiR1wj7mUGDUCvRWbHXmZdifyUSrKTL0/AFiqS/v+1Wg/QDq+WFXYcdU5udwb4TKmnMzNX+ZVjbahd/0HRgUVpuaRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org; spf=pass smtp.mailfrom=archlinux.org; dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=4JCWWDUT; dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=lTNYagwC; arc=none smtp.client-ip=95.216.189.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinux.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="4JCWWDUT";
	dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="lTNYagwC"
From: George Hu <integral@archlinux.org>
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-ed25519; t=1790419048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P/cPyPSknvkI8/btH4kSPiddxwVWDItnGF0wVFHGT70=;
	b=4JCWWDUTF8YH/tL1vFeYCB+wqu/CcKycDDBMiNawf8u42mYZyhdNXcFGwjhj6jzha42jAS
	8dqGxhxDOvvU5+AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-rsa; t=1790419048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=P/cPyPSknvkI8/btH4kSPiddxwVWDItnGF0wVFHGT70=;
	b=lTNYagwCaBrr0VWJZmOmgxsv+H81r8pZjxW2SAHD2aP0z7AKfFWupV9P3xXpqwKRL5CEGQ
	EIvQPc6Wk7g0awrr8rV0I1S9FiFDwU+i/fdCz1oMZqolj2d+JAaNCxVbLWcZN1LCJhEz42
	khjOWzYQsOo8WMWPf3X8ZNmo0WSWLkQquqZdEvnPjcXUWTxcz/JYEGb5RZnp1VndA0U7NI
	HblVsaqpRAgv71vHMT9wzzZbapVnggnrbu3sYgJuEeuWj9SkpXd7nry72etpoH7baD7dTd
	NUStNpFyp40ObddcBOB7Cf7dgvcphz44HuBigfWhcvAIqr+eQK7D35Ww3OxxlvIXvNVJ0x
	LCkMenbeHkeqe0pdN6y+cj3ItP5/fkfZGAwitlT6Xk2Dp9XrFYTLTdbbKyOI1/KWUBXzbd
	x4s0XazxjX3PbO+8pumgN2Ys3JbR8vMmLsw9g4aq4EdxIK5DAe8QrHjamXm6hvrYx+Fv+7
	C6kg/TMQYGq/cHMFpF2ST3rnGk5VQP5b5TYAjWoQigF1NXk1nJo8KEaV0REvxcRtmQs6de
	yDR30YT1dnAMWPPm0OyY/oT7WwrsfsJ78ORYEyBc2CBw8COAwQ5f96p5qtR5ChIatyaDPm
	9ATdd4cFUtGp1r5V5k+GlwN9YFDpJ590jBFJHh2U0Mx8NN1IKLGw4=
Authentication-Results: mail.archlinux.org;
	auth=pass smtp.auth=integral smtp.mailfrom=integral@archlinux.org
To: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Hu <integral@archlinux.org>
Subject: [PATCH] btrfs: use helper functions to check if a string has a given prefix
Date: Sat, 26 Sep 2026 18:36:51 +0800
Message-ID: <20260926103651.41722-1-integral@archlinux.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace strncmp() prefix checks with strstarts() when only a boolean result
is needed, and with str_has_prefix() when the prefix length is needed after
a successful match.

This makes prefix checks clearer and more concise.

Signed-off-by: George Hu <integral@archlinux.org>
---
 fs/btrfs/compression.c | 15 ++++-----------
 fs/btrfs/compression.h |  2 +-
 fs/btrfs/props.c       |  2 +-
 fs/btrfs/super.c       |  5 ++---
 fs/btrfs/xattr.c       |  3 +--
 5 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c62b5148d5ac..82d0413e6236 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -70,19 +70,12 @@ static struct compressed_bio *alloc_compressed_bio(struct btrfs_inode *inode,
 	return to_compressed_bio(bbio);
 }
 
-bool btrfs_compress_is_valid_type(const char *str, size_t len)
+bool btrfs_compress_is_valid_type(const char *str)
 {
-	int i;
-
-	for (i = 1; i < ARRAY_SIZE(btrfs_compress_types); i++) {
-		size_t comp_len = strlen(btrfs_compress_types[i]);
-
-		if (len < comp_len)
-			continue;
-
-		if (!strncmp(btrfs_compress_types[i], str, comp_len))
+	for (int i = 1; i < ARRAY_SIZE(btrfs_compress_types); i++)
+		if (strstarts(str, btrfs_compress_types[i]))
 			return true;
-	}
+
 	return false;
 }
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 1022dc53ec51..1d8e12fcd488 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -131,7 +131,7 @@ extern const struct btrfs_compress_levels btrfs_lzo_compress;
 extern const struct btrfs_compress_levels btrfs_zstd_compress;
 
 const char* btrfs_compress_type2str(enum btrfs_compression_type type);
-bool btrfs_compress_is_valid_type(const char *str, size_t len);
+bool btrfs_compress_is_valid_type(const char *str);
 
 int btrfs_compress_heuristic(struct btrfs_inode *inode, u64 start, u64 end);
 
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index bb77d46376d4..c33930c58802 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -301,7 +301,7 @@ static int prop_compression_validate(const struct btrfs_inode *inode,
 	if (!value)
 		return 0;
 
-	if (btrfs_compress_is_valid_type(value, len))
+	if (btrfs_compress_is_valid_type(value))
 		return 0;
 
 	if ((len == 2 && strncmp("no", value, 2) == 0) ||
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index ddb620ac241b..287cdc45bef8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -263,10 +263,9 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
 
 static bool btrfs_match_compress_type(const char *string, const char *type, bool may_have_level)
 {
-	const int len = strlen(type);
+	const size_t len = str_has_prefix(string, type);
 
-	return (strncmp(string, type, len) == 0) &&
-		((may_have_level && string[len] == ':') || string[len] == '\0');
+	return len && ((may_have_level && string[len] == ':') || string[len] == '\0');
 }
 
 static int btrfs_parse_compress(struct btrfs_fs_context *ctx,
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index ab55d10bd71f..9011d8096e2d 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -239,8 +239,7 @@ int btrfs_setxattr_trans(struct inode *inode, const char *name,
 		 * block_rsv of the handle and trigger a warning for the start
 		 * case.
 		 */
-		ASSERT(strncmp(name, XATTR_SECURITY_PREFIX,
-			       XATTR_SECURITY_PREFIX_LEN) == 0);
+		ASSERT(strstarts(name, XATTR_SECURITY_PREFIX));
 		trans = current->journal_info;
 	}
 
-- 
2.55.0

