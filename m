Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739D13E49FC;
	Tue,  6 Oct 2026 21:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791322730; cv=none; b=MdnfxlN97TVDs24+Sd/45Rv9pOxnv2HW/Z9nMl3F3+J1fEKMkElhzQTUo7R44SaHihQnch1Px7OnBJx4vknWkc9bRxn/I5QXwczW+wtMtxmeX2QuOoKlLryL/SZGcR8fiTZU+6gbAIL6s1+lTVIhB1s5GphJaxm4zmvHyxPohTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791322730; c=relaxed/simple;
	bh=BJFJx3Arx09q/AtItfyhd9jmfb/3TDiksmUhP7CQCE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=beFhulkZWjOToW2t19Wf+0jqBicKg75GpZXUC+kdM/1KGINPwnGuJThnUqYyB/V/5yiCFrILwa/2EnhVwnuknX0krt0PSKNxlbvYr9CqQsTjJ9/H8m3a1r+gd9++XELzj8BBM1I1LkYOi0vyXVIf73xA6ae7tuNpH2JRiQBLM/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFQnHDma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFQnHDma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D991F0089B;
	Tue,  6 Oct 2026 21:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791322729;
	bh=CQWIdwKslbnIaELadXYoisPN3RXMytzjIxhkvh94jLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFQnHDma7n4T3ET9tEjF0uhJlqbOsXJPx7zwTH6WbIV48NkFF9DZifIOkU7Gh8BTH
	 Eox8iVwYJDy+xTiU11lOLwcIgNu+xBygVAlr3gsE0pTtf97JLp4XCISn42S3YW8R/N
	 p6VemfRoBKsX/mC24GwbT2owSN45EPsiq2UEbSnmUla21DhyTVdwV/t1anSCDk+TCr
	 Bttg4ExOxunFIsUqOB/FxI3NgrW2jGbzV35PQUOEDF9YaJmEBYZO8Vp8kKUO061hzB
	 sQ8ucfxmPl2xZeAnUpDPZXli7ASQEXHnZ2tg1CfImmHWvmkRvbxr2huVbRRY3QgJ7Q
	 vPKEwyiEGLPqQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: fsverity@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 2/2] fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
Date: Tue,  6 Oct 2026 23:38:15 +0200
Message-ID: <20261006213815.47194-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261006213815.47194-1-ebiggers@kernel.org>
References: <20261006213815.47194-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrey Albershteyn <aalbersh@kernel.org>

commit d2f96bcb89d36d488a10e3bcf819b98536968286 upstream.

The check that fs-verity is available in the kernel is not necessary
here. Filesystems could have fsverity files even without fs-verity
enabled. In that case, truncate on fsverity file will succeed, what this
check is trying to prevent.

Fixes: e9734653c523 ("fs,fsverity: reject size changes on fsverity files in setattr_prepare")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260727094352.1734826-1-aalbersh@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/attr.c b/fs/attr.c
index c2302fc4b333..dd3b0b5115af 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -180,7 +180,7 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
 		 * covered by the open-time check because sys_truncate() takes a
 		 * path, not an open file.
 		 */
-		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
+		if (IS_VERITY(inode))
 			return -EPERM;
 
 		error = inode_newsize_ok(inode, attr->ia_size);
-- 
2.56.0

