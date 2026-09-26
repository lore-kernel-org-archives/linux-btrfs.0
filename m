Received: from mail.archlinux.org (mail.archlinux.org [95.216.189.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE003411665;
	Sat, 26 Sep 2026 12:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.189.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790425362; cv=none; b=mr40GQv573aY2+nNfP5T1V/o9jauRp4x8Vo0VE8j2A6czrZRAqiezTzdPYamhQ8/Ae+dNpTl/8kgb0BEaSIH4DyVv3Ml9Cs3al3TGV/PFS20CMc/hTbMgKFGPwX867S0vB8UMkzgYNby2n5ktjt2h4HQtXRw9F5ZA1DP6i9T5pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790425362; c=relaxed/simple;
	bh=gdFIIPEI9f69baSrtwHh1qe//OFb/yCzuPtR/tvmgVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1pygi65++IY8TgJVMof/zMyv+HipMDma7qHDO8tkGkOAc2IEetiNLWeNeyOC+eJnKrAzbZ4EtSMR4W4NjdnR71TjoNBS7AczToL57ywBpHZDTWfzxbGVeFa1qMiqcOLDB3LtOrFQ5A7oThgmvOdNgb9QTUsVtLiF+UC3MT6x9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org; spf=pass smtp.mailfrom=archlinux.org; dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=JAY3PtYl; dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=/juWzd5q; arc=none smtp.client-ip=95.216.189.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinux.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="JAY3PtYl";
	dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="/juWzd5q"
From: George Hu <integral@archlinux.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-rsa; t=1790425357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Caraqs7zEAWhQIGFWAn2aeOAD5041gOjm9MXYHOOGU=;
	b=JAY3PtYlk85Xtcxd/aL3IoSCbYsTIeXxUAmMtfJMH6EYAcis8/TZDrcJyzLWUpTX204wKJ
	RHFQwN2fKR3pHdjdDOAssn6t4hrxIf7UKpxYeM1mIhZlfj+lESgJPE632pdI1EC7u8Mlm2
	fPXYrLB6tAW/t//kt6B1bEX0g2xl7+weFwTfTaH5fLoTb/kItg0Axbcty3ztYZ4KI3gATV
	xQg16eFoGSwOIDtLYLGJDt/q23eCLXGJGaD2PD07EMPKpnOZYd3rVrV3CE8HfF0e7Cy63v
	6iH/ESSgqGLOfyuVia2GaMA9D49581OxD8r+yQWIGlY2u/RaKEMS2tL8cvukGVnIwKErjr
	Xfj6DucOwJVRQbGxJ7g6uTmWLWQTIeY8XU16zTHD5cnBxiZzoFwG/w2E3uqYFJ1DZUlwQk
	4lO/nqY3Z3OlwPXGn63J58cRx6z2piP2V0JIHoayHLZFL5RtnIEz0nqHYSMhwgqadnawVj
	pOm5LGUeV6oPYin2adI1sV59oGOe2C79g8ftE3aR1b18GPDXT3x34YtLkkY3rLlD+Ro8oS
	G3IaISvyZ0HcxRisQTPryFc/CrE2VJ7N4zCYv5oXO5Q8xVruqvAZBPetz8u0wkdF02xqku
	rvsWVnLYEJII8VnvrZqlYvBLjnBes8V2zrhOFpeQUn4O0weBQtG70=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-ed25519; t=1790425357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Caraqs7zEAWhQIGFWAn2aeOAD5041gOjm9MXYHOOGU=;
	b=/juWzd5q1z3iul1v8fhUn+OhOiB5IYxYACM7KBlnbmCAiktRhTQKnKG2z64JfhnraYdSfq
	uEK2Av+YAoCKdnBw==
Authentication-Results: mail.archlinux.org;
	auth=pass smtp.auth=integral smtp.mailfrom=integral@archlinux.org
To: wqu@suse.com
Cc: dsterba@suse.com,
	integral@archlinux.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mason@kernel.org
Subject: [PATCH v2] btrfs: use strstarts() and str_has_prefix() for prefix checks
Date: Sat, 26 Sep 2026 20:22:17 +0800
Message-ID: <20260926122217.22759-1-integral@archlinux.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <a7d68d73-3ba1-46d3-a6c9-5ee213e5b551@suse.com>
References: <a7d68d73-3ba1-46d3-a6c9-5ee213e5b551@suse.com>
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
V1 -> V2:
 - Avoid replacing strncmp() with strstarts() when the parameter is
   not NUL terminated
 - Revise subject

 fs/btrfs/super.c | 5 ++---
 fs/btrfs/xattr.c | 3 +--
 2 files changed, 3 insertions(+), 5 deletions(-)

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

