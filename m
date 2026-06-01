Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5491D3921E6
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780307519; cv=none; b=X9fldagN3zTUdAkXa2zWSEbxqew+2ehBMnbucvVCps5hlfE4d92m5u/pJWEV30xOWRQMHplMbTFZVZ6XmOSRHWTgfYp+EADN57NlLAuefxnBBiyMZhDLCUKIoeOs3IbluYgQZRwtxEAwM9iQQ78dTvuhN/lH7a15X40u7aKNl6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780307519; c=relaxed/simple;
	bh=RSQa8zBnl0q9UCeLvCkp4eif1yvJCdz1OIFNT6AIkK4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pU/iKMOqH4bUKVO4t6fAZmkXifVL13Lvdf0AmlnTPUqKWQ/NY0qOBYnT0fJAEKwE98rJb2pIw5J2Sfvx2RC9JCV6CEQzPq3Mlpj/XDO4Wm47spyrObKnF2kh/cfgm+hwiouEtEhzhF/sS6XPHWFjXTwYvKgBr7zVWlB4IJR7xWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCxmPUX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCxmPUX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D231F00898
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780307510;
	bh=ezYa7icGVJkbrI+j/0fAMJIvf6pzbOcpAMMfq5npyuA=;
	h=From:To:Subject:Date;
	b=hCxmPUX6FeHkmBF3B8x1rduJYwWinyVigf+Y771m27PmSqNMir5UIVrFTzu+M8WDN
	 CngCN/g6G2xQcQkJXKxWwOjbf9P/ZqfKTSkDZsffSoQMZ7ZKAq9WISfbKoDSj1FiXC
	 L84+4SROpKIVijfVkqirOfyyLwNQnHyl7YtUidI9M2dfVWC741K/NsHn2NSLJTpHju
	 ZrWdYJ4U7Db5D7eB8wDbsvZWMQ3v1NSSShDyw2b9+NXNN4wnDlnnFUBaID+/IJaVxm
	 JCzxFGbc6DyXiLZXsqMnxQqpd9yCEMHrAlbCF82vvG2L+czl25j0LOETnzcxbBvd00
	 6TTZV+c6kFuhg==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: return real error after lookup failure in btrfs_ioctl_default_subvol()
Date: Mon,  1 Jun 2026 10:51:48 +0100
Message-ID: <e8443af84991f7c4cc6ebea885b850a1c51dc554.1780307495.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If we fail to lookup the dir item, we are always returning -ENOENT but
that may not be the reason for the failure, as btrfs_lookup_dir_item() can
return many different errors, such as -EIO or -ENOMEM for example.
Fix this by returning the real error, and also fixup the silly error
message, including the id of the directory and the error.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ioctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 561f4a90981b..9d47d16394fc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2829,9 +2829,13 @@ static long btrfs_ioctl_default_subvol(struct file *file, void __user *argp)
 	if (IS_ERR_OR_NULL(di)) {
 		btrfs_release_path(path);
 		btrfs_end_transaction(trans);
+		if (di)
+			ret = PTR_ERR(di);
+		else
+			ret = -ENOENT;
 		btrfs_err(fs_info,
-			  "Umm, you don't have the default diritem, this isn't going to work");
-		ret = -ENOENT;
+			  "could not find default diritem for dir %llu: %d",
+			  dir_id, ret);
 		goto out_free;
 	}
 
-- 
2.47.2

