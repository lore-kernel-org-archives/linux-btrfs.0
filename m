Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D811DF73A
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180661; cv=none; b=BMU2DEmkrAkj/JmrSCfUf7xZdQdoU5sGfjy3gpCCC3J/vxlPVFgn+xDjdwdZWcQ1isb1APJXKwyYFXq76rk6Bfehjuqwb4L08qXitHyCDbxvMRX/6coLVO5JaOBtqfNAtg+hTy5lfBlguR3Hu2ITL/QyS8GGI2o4G56Pzq+vhok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180661; c=relaxed/simple;
	bh=e8KnKajJFO47+yJSxQxbafV8aoZKvfxGlHJu2MKW3hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+eqVcyZ09IVfScxFxreNh4Snvc+e6gl5fjeFue1n0ZSfneg3htK/+J7gDZxS/3JStycdRnxg3EzHWdfJCtDbnHdo6qL+jE6AYl7+VYuf3K+3fnDWk/2COfXI8aILPkKcn0SaQWsGD/gOiYwp5LLcU3CGp9lgykhSfpjvs+fTCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 432A56A8F7;
	Tue, 14 Apr 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C68E4B4F9;
	Tue, 14 Apr 2026 15:30:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ctu9DrJd3mkdPAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Apr 2026 15:30:58 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/6] btrfs: handle unexpected free-space-tree key types
Date: Tue, 14 Apr 2026 17:30:31 +0200
Message-ID: <23bf53315a59a3acc0abdf4f4d8f4c9336c936e1.1776180388.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776180388.git.dsterba@suse.com>
References: <cover.1776180388.git.dsterba@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 432A56A8F7
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Replace the conditional assertions with proper error handling and
transaction abort if we find an unexpected key type in the free space
tree.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/free-space-tree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 9efd1ec90f031f..472b3060e5ac32 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -259,7 +259,11 @@ int btrfs_convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
 				nr++;
 				path->slots[0]--;
 			} else {
-				ASSERT(0);
+				btrfs_err(fs_info, "unexpected free space tree key type %u",
+					  found_key.type);
+				ret = -EUCLEAN;
+				btrfs_abort_transaction(trans, ret);
+				goto out;
 			}
 		}
 
@@ -405,7 +409,11 @@ int btrfs_convert_free_space_to_extents(struct btrfs_trans_handle *trans,
 
 				nr++;
 			} else {
-				ASSERT(0);
+				btrfs_err(fs_info, "unexpected free space tree key type %u",
+					  found_key.type);
+				ret = -EUCLEAN;
+				btrfs_abort_transaction(trans, ret);
+				goto out;
 			}
 		}
 
@@ -1518,7 +1526,11 @@ int btrfs_remove_block_group_free_space(struct btrfs_trans_handle *trans,
 				nr++;
 				path->slots[0]--;
 			} else {
-				ASSERT(0);
+				btrfs_err(trans->fs_info, "unexpected free space tree key type %u",
+					  found_key.type);
+				ret = -EUCLEAN;
+				btrfs_abort_transaction(trans, ret);
+				return ret;
 			}
 		}
 
-- 
2.53.0

