Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165745;
	b=aCoqe5NoJJ4ZudzLrSRn9n42T64gYUL/uQ+wpvrxN5YQB6mUJ0ax/B8Ph+cdT/ejDRWV
	 OR9i71UvvkH+BklUpbaGRzwjL+08CgtPVY66ormgQjx6SMfhFXQ46kYBPBFEvo0r7g92k
	 UYOCeXNm5puaiQXg9ULx62I043b1WNdYSPs9QFDZmE7bTOwK3jJGOtdaVS/YyYiSIDTyQ
	 y0zpEXBIhUqe33b6VT2JqZvBrRn0BKPDv4nGOx0aqgIklRZ6c287kmJtFGZw+3+8e0g1q
	 MCpgBiIFzHruqMNyBVPXTx6yF37lwUqtoMuzJnJXRTPclQOuYlXXm5q0aEF+AO+Z7/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165745;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=s7AwHVFXN74P6rAXHynoTYbx1cW3o6tGizph3GcEfz8=;
	b=nObGljmcick5PVBHlhjr67MupeOB+qH/vOr/Jw7UxZ8aqTZZyioveTyqv9Ra4lsxyREL
	 jBsGhpGk7FjKaftI9rS1wZS9brwoMsgypzFDnJxAOE4iwiTECU8kOi/uub/c4Osg23Czi
	 njAyllerAxRGGWslX+hHu7dy7GnmLZJAw/a8p6N5rSFX9yEeihEM5CwC/nUAELIYW+cFT
	 SEkNLL5z4hdJFrG2XZ0FGq/EKLT2K9djLX8SCqD3igatugWIMdJZj5NbOzVVmspBgo+Dd
	 CoYPXWZgZZcHACka2IB20cuUAvxZXvYfUbn4Xamr85HNSFs50vV0cA1MeA6vnNiDeWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YxiPV7ih;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YxiPV7ih;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82288606A333
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82288606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YxiPV7ih;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YxiPV7ih
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD0C122538
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s7AwHVFXN74P6rAXHynoTYbx1cW3o6tGizph3GcEfz8=;
	b=YxiPV7ihQhd2tXa4GJpOZE5SqL+0fNlQjtdLm6g+ZeD9f6uekxlgF8NkE7C7SWbEYsqsZj
	GOjwIFuhiQUHOuc19QD8UnHN4OyFyL/ucCN/PhwAwMPirfOm8NXPRo3Tb0owvfvkDAF1FF
	0aDbJYvsQAAzMUDgd6OvbeRmdbkrmXM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YxiPV7ih
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s7AwHVFXN74P6rAXHynoTYbx1cW3o6tGizph3GcEfz8=;
	b=YxiPV7ihQhd2tXa4GJpOZE5SqL+0fNlQjtdLm6g+ZeD9f6uekxlgF8NkE7C7SWbEYsqsZj
	GOjwIFuhiQUHOuc19QD8UnHN4OyFyL/ucCN/PhwAwMPirfOm8NXPRo3Tb0owvfvkDAF1FF
	0aDbJYvsQAAzMUDgd6OvbeRmdbkrmXM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A808C1342D
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7jwnOScOAGsJYwAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: qgroup: show the "qgroup scan cancelled" message correctly
Date: Fri, 20 Nov 2026 19:38:37 +1030
Message-ID: <2ce9cd2d54cb4a69c26c40cdf9ebb2652d2866c0.1795165635.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795165635.git.wqu@suse.com>
References: <cover.1795165635.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: CD0C122538
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

There are several reasons why we won't output the "qgroup scan cancelled"
message:

- We always clear BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN before the
  message check
  So that test_bit() will never return true.

- @stopped has a higher priority
  When a rescan is cancelled, it has a high chance to be caught by
  rescan_should_stop(), so in that case @stopped is also true.

  Then when checking which message to output, @stopped has a higher
  priority, thus it shows the rescan as paused instead.

Fix the problem by:

- Save the previous CANCEL_RESCAN flag into @cancelled, and check that
  variable instead

- Change the message priority so that cancelled has a higher priority
  And for @stopped/@cancelled check, if they hit, output the message and
  return. So we don't need the complex "if () {} else if () {}" logic
  anymore.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index afac7402af36..3be159541e4c 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3900,6 +3900,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
+	bool cancelled = false;
 	bool stopped = false;
 	bool did_leaf_rescans = false;
 
@@ -3982,18 +3983,24 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		}
 	}
 	fs_info->qgroup_rescan_running = false;
-	clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags);
+	cancelled = test_and_clear_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
+				       &fs_info->qgroup_flags);
 	complete_all(&fs_info->qgroup_rescan_completion);
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
 
 	if (trans)
 		btrfs_end_transaction(trans);
 
+	if (cancelled) {
+		btrfs_info(fs_info, "qgroup scan cancelled");
+		return;
+	}
 	if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
-	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
-		btrfs_info(fs_info, "qgroup scan cancelled");
-	} else if (ret >= 0) {
+		return;
+	}
+
+	if (ret >= 0) {
 		btrfs_info(fs_info, "qgroup scan completed%s",
 			ret > 0 ? " (inconsistency flag cleared)" : "");
 	} else {
-- 
2.56.0

