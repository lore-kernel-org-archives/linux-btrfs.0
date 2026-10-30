Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333757;
	b=eAgStQF/Qu5P9IRj6W0miMEpAeoWXzShwNdY3Ljdzu+v0UGVR8uanUsrWJSFRW9ySmuQ
	 U0MPHMVWoidArgWNEBNsmdLwrUC40Mbul50XT9ps8ADJC0eHB/IA6MT+nb+ZYzF1VWpUV
	 8tbYcKfQ6Mi6aqR4XaLBCSWWlxF8RdoG5t3Qi+Nw5/T2oAgOEk1V7Sn/jDNHu+XSsI18Z
	 K0SB4nppmkK/wGNaJyFdpGl5fq6zpRiqhk8KSCJKcHTpiTDHSe6e3oKZ9doKj3pNiMK5k
	 xN5CLSdw8buG7hqU2qTWYZvpBl2Cacf6Ws0TaD8Nv8gocHZydXq/IIY8xLHxMyhZ2WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333757;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=LI4a/JlIMCbYmnI+tH4/9mHjVNGjz7tGPPg5DECYYog=;
	b=CdDUG0p6RfGQJMhJDcepLnfrOp6gMvKMiE5i2ds35gC8hGJvVG9IcAO5oWO6kFlMRpCx
	 l4G2VdRmtGMiXEKcmuVKFdfGC7OLcqfmM/ZzSGizul2ivRobVQk2kVVCwy3NMMsTU72qD
	 DuGMWc10NxjAHHlJ2D44FLs6yikOU7nFfWTFQC2D+6R5Kqaxlhy8oH8oRRhc0aRi4b9Nm
	 xuHgXJ9zda6hMTcUo9eMw+mYUcln8bg9i7PjM8MrkZcwCPrPzyJ/04gDIMLtg0v03my25
	 MhAcQw3Z38hVe1SX08dvkGkLK0RT0Ofo6VHi7+hTZbFbGdeXc2YnZSynkYcx0h5L1CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=trayxZVC;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=trayxZVC;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A825606A31E
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A825606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=trayxZVC;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=trayxZVC
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 60ACD223FE
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LI4a/JlIMCbYmnI+tH4/9mHjVNGjz7tGPPg5DECYYog=;
	b=trayxZVCXs/aqAUNRvAQMr/agd626L9QigmwscAB2UrUhPAknPSl1ldLXosZHAmNta0E5e
	avLkn6FCM/IV9i5i0jPFn+wC4OTiiD5UhKiWRtUZ5yDV3l3hHlXlPQRcHn08uqfgQdVfuW
	B2WcGyjW/BvlFzG3NMpE06BYDIcd2cs=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=trayxZVC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333755; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LI4a/JlIMCbYmnI+tH4/9mHjVNGjz7tGPPg5DECYYog=;
	b=trayxZVCXs/aqAUNRvAQMr/agd626L9QigmwscAB2UrUhPAknPSl1ldLXosZHAmNta0E5e
	avLkn6FCM/IV9i5i0jPFn+wC4OTiiD5UhKiWRtUZ5yDV3l3hHlXlPQRcHn08uqfgQdVfuW
	B2WcGyjW/BvlFzG3NMpE06BYDIcd2cs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4DC5613432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T11
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 10/12] btrfs-progs: fix missing transaction commit in truncate_free_ino_items()
Date: Fri, 30 Oct 2026 14:45:17 +1030
Message-ID: <e15cad0bc420c22d68241e0f1913a1cd16c693e4.1793333606.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793333606.git.wqu@suse.com>
References: <cover.1793333606.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 60ACD223FE

When truncate_free_ino_items() finds that there are no more items to
delete, it directly returns, without committing nor aborting the
transaction it started.

Thus all the items deleted by the previous iterations are lost, and the
transaction handle is leaked.

This is a very low risk bug, as there are very few ino-cache users (if
any), so this ino items removal can be considered almost dead-code.

Fix it by breaking out of the loop, so the transaction is committed like
the other exit path.

Also since we're here, also report btrfs_commit_transaction() error.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 common/clear-cache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/common/clear-cache.c b/common/clear-cache.c
index bfefd325d700..d0a6700b0e81 100644
--- a/common/clear-cache.c
+++ b/common/clear-cache.c
@@ -881,7 +881,7 @@ int truncate_free_ino_items(struct btrfs_root *root)
 			ret = 0;
 			/* No more items, finished truncating */
 			if (path.slots[0] == 0)
-				return ret;
+				break;
 			path.slots[0]--;
 		}
 		fi = NULL;
@@ -945,7 +945,11 @@ int truncate_free_ino_items(struct btrfs_root *root)
 		}
 	}
 
-	btrfs_commit_transaction(trans, root);
+	ret = btrfs_commit_transaction(trans, root);
+	if (ret < 0) {
+		errno = -ret;
+		error_msg(ERROR_MSG_COMMIT_TRANS, "%m");
+	}
 	return ret;
 }
 
-- 
2.56.0

