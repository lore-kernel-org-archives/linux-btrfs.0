Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794524281;
	b=dQYEA0pHSbL+AL9hmev+LUTaJN6rPNmhHfEpT40NMywO2QW0yhUoPRYPFksT4K+v/1uk
	 Xh1Mrz2zDvKoG9XulAq3T/4fdGSajaHYGrtiXCwfGChul8/O6HC/2Z0mnqXPiclZJtrMG
	 4jYwAUHDHICPSCztZf6CKgCJBc46ED1bxbbGpoyBRteyGcCr2tC1Xip/eSPhk2DVVnCT6
	 e5nyewIrsfMRj3Vr55PNdPLX9mvXOpocrc0da8DG79g59jOtb0s5tC/Uwt/AbYsS+jUFj
	 jBb63H+9mkwmC0pFCvaspUl35XH0ARYj0gwCrWUSNKIFgUa44wuNtgfpkLIckAXq3Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794524281;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=Za+nUij785zqzjEWD8nnl+yZPGcA+Zq8SZ2a6rDQL0k=;
	b=cRGAR6TkPxjZYBwzP9p+LUQhTwiVm9BXc/CTQ388QK6+/ABbO1cjH9JeJCIowxeHYpj6
	 FNGuYKjQmx0tu1AQ4jAnX5rInAixCWBdc3sRkTs+Nmx5YpftIkmgY4lzfjIJEqxnHxrEN
	 yT0vfkHfd2qfH9ZC4hmvronl37V4ySKZC/CTHnOMOUKa4izhzq3zi3/Y4LXyqd5PSzOBo
	 hnWGjKORV/iwLvE2/T9J66f54EehrnXx90XSr/Kzg3kEi1e9IcRq5Whhu7+G6Eu9lM2wW
	 PN0gHqvYf/SNqxFarAlgwrTcSEtKqWmf9jonSpUUp8NmgV+wW68eqA8jL9uX8qm0YDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Tayo85Nn;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Tayo85Nn;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41272606A31C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 22:58:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41272606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Tayo85Nn;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Tayo85Nn
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0B8B51FD10;
	Thu, 12 Nov 2026 22:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794524279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Za+nUij785zqzjEWD8nnl+yZPGcA+Zq8SZ2a6rDQL0k=;
	b=Tayo85Nn8hS1z1IW8Dlu7Byzb71FgDR6WdsiSHsQ0W8w5lErl67w9BQL9m+RR/Yb3UofpG
	XKsN+52MDoWQN8geUfhX1vIs+HZg0xy7lB3rBrXOtpOCzSISe54r4l3HmW9Rl3KvdupCHb
	fBBSyN9SpXnCxGvlJkkeo/gMLic96Kk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794524279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Za+nUij785zqzjEWD8nnl+yZPGcA+Zq8SZ2a6rDQL0k=;
	b=Tayo85Nn8hS1z1IW8Dlu7Byzb71FgDR6WdsiSHsQ0W8w5lErl67w9BQL9m+RR/Yb3UofpG
	XKsN+52MDoWQN8geUfhX1vIs+HZg0xy7lB3rBrXOtpOCzSISe54r4l3HmW9Rl3KvdupCHb
	fBBSyN9SpXnCxGvlJkkeo/gMLic96Kk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 646B213432;
	Thu, 12 Nov 2026 22:57:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 25MtK3RE9mpgSAAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 12 Nov 2026 22:57:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] btrfs: do not unwind a committed device in btrfs_init_new_device()
Date: Fri, 13 Nov 2026 09:27:38 +1030
Message-ID: <02d1a8fbadb25335495cdcf147785216b5cd8934.1794524252.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,sashiko.dev:url,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

Sashiko reported an use-after-free bug during error handling of
btrfs_init_new_device(), that error from btrfs_attach_transaction() can
cause use-after-free:

 btrfs_init_new_device()
 |-btrfs_commit_transaction()
 | ^^^ device is now in the chunk tree, chunks are allocated on it
 |     and the fsid is changed
 |
 |-mutex_unlock(&uuid_mutex);
 | ^^^ uuid_mutext unlocked.
 |
 |-btrfs_attach_transaction()
 | ^^^ fails with -ENOMEM for allocation failure or -EROFS for
 |     aborted transaction.
 |
 \-goto error_sysfs
   |-btrfs_sysfs_remove_device()
   |-list_del_rcu(&device->dev_list)
   |
   |-btrfs_rollback_sprout()
   | ^^^ asserts uuid_mutex, which is not held anymore
   |
   \-btrfs_free_device()
     ^^^ chunk maps still point to the freed device

Since the device can not be unwound once committed, do not go through
the unwind path. We have no transaction handle to abort, so call
btrfs_handle_fs_error() to force the fs read-only (a no-op if it
already is), release the freeze protection and return the error.

Also let the -ENOENT and attach failure exits run btrfs_forget_devices()
and update_dev_time() like the success path, as the device is committed.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-c339b137-b739-4f8d-8cc5-0960dee662ee
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2b4664b5fd4..8b94c509b85d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3165,17 +3165,24 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
 				    "Failed to relocate sys chunks after device initialization. This can be fixed using the \"btrfs balance\" command.");
 		trans = btrfs_attach_transaction(root);
 		if (IS_ERR(trans)) {
-			if (PTR_ERR(trans) == -ENOENT) {
-				bdev_allow_freeze(file_bdev(bdev_file));
-				return 0;
-			}
 			ret = PTR_ERR(trans);
-			trans = NULL;
-			goto error_sysfs;
+			if (ret == -ENOENT) {
+				ret = 0;
+				goto device_added;
+			}
+			/*
+			 * The new device is already committed and in use, we
+			 * can not unwind it anymore. There is no transaction
+			 * handle to abort, so force the fs read-only instead.
+			 */
+			btrfs_handle_fs_error(fs_info, ret,
+	"Failed to attach transaction after device initialization");
+			goto device_added;
 		}
 		ret = btrfs_commit_transaction(trans);
 	}
 
+device_added:
 	/*
 	 * Now that we have written a new super block to this device, check all
 	 * other fs_devices list if device_path alienates any other scanned
-- 
2.56.0

