Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63E046D54C;
	Tue,  4 Aug 2026 15:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858291; cv=none; b=PF/3lOUhQD20Ad9An40ssfq/dvJni+KLlPfy1AN0g36lcoqvO3QQgqTZtws7ZO0mxKQpDrZRWtEJumdPbX0kg8Jsbu6qtO894N92LSnZ16toWlN6u1j8ZRRzjlmUpaDK1RdOOKxC9q+bil+cz0mbZMMlRwWc9gpmPgJ8d/di3zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858291; c=relaxed/simple;
	bh=JJLdQjp2qSQf0aItoG8nHyAXtBvLlBsw1sE1bdwEsZc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S3qrrgVRw/rsrDXr9A8TYNOBDRxTmsz2P+mpXxRTFrCnXl9CZKx5M3rYPuCqql+cBkSJ3DjixLvPjZ0XeJY4BqZc0ghjgB7eColOS1OXv8RwB37lwab5/LMnWIwbUT7L5YeZzIXuZd5RSC5JVc5zyMwL983dW01oixqnetoEdCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BULEJteY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BULEJteY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB8E1F00A3D;
	Tue,  4 Aug 2026 15:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785858289;
	bh=vYcEkLUykBWNnjCNZyZnh5ss9UkSISblO9GuleIRpL8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BULEJteYOPpne1BaRtT5B/DYRdoEXIFoP0SM5JXHGkdcJ0ozjsAEnh19baME7JvI7
	 YaCsyQr2iLLNUZvkISprYt+O8XlOQxVMduAQcEBz2eG2Yu/vmlmIxiKrE8edGi8M8C
	 W/fH5MaGnTUiF1KiSxCRo5Z28c955aGiABvMyAFI4r2m4y7EqwctxYZmFNZXCCqY0T
	 nuW5J0j2JoR/L4OX22723cPH5fd0Q1W6e3F21SixFmXgjk2mV7/ki8QrXutVOxAJPE
	 Nrz1gG6cctJZOsYJtwaLqnAxC7df1AWacNuhJmhEXNs1EluT1JqwnK1T+FLRTCH67g
	 t/o9L0ApwDDrQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 04 Aug 2026 11:44:33 -0400
Subject: [PATCH v2 1/5] btrfs: use an on-stack path in
 btrfs_insert_orphan_item()
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-btrfs-enomem-v2-1-4d923170e8c1@kernel.org>
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
In-Reply-To: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1322; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=JJLdQjp2qSQf0aItoG8nHyAXtBvLlBsw1sE1bdwEsZc=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqcgjuSXbvF9GJBqepwDzeo5mDCPTE7cQqKloL9
 TUi+4wrwjSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCanII7gAKCRAADmhBGVaC
 FZl1EACnMHSigGCM3nnJ4q2/tTl/umGx4TE91WdwgD9S/VLzqZt/o8Hl7wspnFJGGMCGwudUDgn
 VxqpfqdNG2/qSSHQdskoH3GYtlMGUCCMszGUSElSpoGkvAnT0nocfagSfiokMyE1TQMcT2hG4Cf
 MejGqOkkBCYRGFOu1COyrUKN7uN3CQLMBsRY3QZlpwqbsZrkhPYNadY4V+YzWDht/DL3izvKdIo
 jUqyW8pCUmiSMQyDeULmZTOdlskPRhf6Yra6S1qYrsPisV8eQ5WIo09IYFWN/6QeGeC7guzkoS4
 gtfohAU/ZgUldq8A+HcDu0xbUUNyQN/1b78Y9V//gDA1MYnPGdnEXSv9hf+Oc8piEjOFF1nUQVi
 u5EuAyGUG35191422LERyUxhgVRAlkU3zpkKlwYZRe58Ow0jTJyNlS8DqK4rG/gmneEtjq1MVbP
 dH3CRkfXJztwQxA0rI45yJVhSeeUWjJxPwqjN6Ceefpay+eI3ZnhSCORDeGHukBKiimemk2YEn/
 yHVHTNpCsWIyKAWbfSFZZPZbkQaE43E9NCl1uOwdtJawv71SxFImtQxB/8MFJj6WHmOCYjIiqOD
 XKz+NmO0ne4Imemra/Hrczxdvwt64TgJ+SpI+NLYf97+IWIjuCpsqjZXWUm4EnBzcZ2uW2gaZ4g
 X5eLv56kIVIg50A==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

btrfs_insert_orphan_item() allocated a btrfs_path with btrfs_alloc_path()
which returns -ENOMEM on failure. It is called from btrfs_orphan_add(),
so a path allocation failure there turns a recoverable error into a
transaction abort.

btrfs_path is only ~112 bytes, so allocate it on the stack instead.

Assisted-by: LLM
Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/orphan.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/orphan.c b/fs/btrfs/orphan.c
index 9f3ad124104f..72e1adec39d8 100644
--- a/fs/btrfs/orphan.c
+++ b/fs/btrfs/orphan.c
@@ -9,18 +9,17 @@
 int btrfs_insert_orphan_item(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 offset)
 {
-	BTRFS_PATH_AUTO_FREE(path);
+	struct btrfs_path path = { 0 };
 	struct btrfs_key key;
+	int ret;
 
 	key.objectid = BTRFS_ORPHAN_OBJECTID;
 	key.type = BTRFS_ORPHAN_ITEM_KEY;
 	key.offset = offset;
 
-	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
-
-	return btrfs_insert_empty_item(trans, root, path, &key, 0);
+	ret = btrfs_insert_empty_item(trans, root, &path, &key, 0);
+	btrfs_release_path(&path);
+	return ret;
 }
 
 int btrfs_del_orphan_item(struct btrfs_trans_handle *trans,

-- 
2.55.0

