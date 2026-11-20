Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795167722;
	b=XSlYSzyWtiV6VwmhXmyHQsUVzjZujb9bbENeHGpH4K8WdkewJ2utky6FasCp14cKX4bc
	 foqyCEBvoJ4uIq0FzQLVA6G2RbtYQxUYLmtn5qL2WH9FitlD7U+tjnitW2psZuAAhCI9G
	 kgJbsUdC3tyoYfa7LyhrpWhAEdCwfUQRi9+GCVbDqDI4e4P4wtbvoTO2S86DDQQXeNML4
	 ve4LU5m4Q7be3K9KVqTFmlYFyhfJBZRP+fwV13nzbyBTpkwpFfIHopoNnde4LmSb5Wje9
	 yYmnD5FEVzHGYzV/HbWd1YKAmE7zoswrAF1JoIp5Ojbcqbvg0QaA+W6DecmiwVIkkzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167722;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=+A5pxRb7bzt5+nKR5bczxwsUF2b9Qz5uFrRd9spYNDQ=;
	b=LaYRSDx3DQxsoKiHOqehSXZ0x7VahwqEnHwcL2DVKJiy8AgaugsvnZ8HJg0cvRnxZZTa
	 6nR/P2bkX3TCF2nfZfWn6M+sqSgoWsDKt33h+X/zuakQkDWPnMoE2S/6c2eaB+QCRc62m
	 BVPkuT+BEpXxssCCEUUo8wNMzdJsi1f//lmukhXIt7wnHx8eH4luqagMOGK7zghcAdpLL
	 tzoGFjxQY+w1UrQXK8XQ0sLQlDCiJ9MGa93+AGF9PFiqNwOGi7CJVX/uKuGr//PG1mdQf
	 EIpeKomPYp7oj5M2rf/ZKSuSywK/mkI6lpNJ3Weoy42pcVvZUeoeO6oYaQ8cjksQ2PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Y5bcGnLe;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Y5bcGnLe;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37868606A33B
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:42:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37868606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Y5bcGnLe;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Y5bcGnLe
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C6071F7BE
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A5pxRb7bzt5+nKR5bczxwsUF2b9Qz5uFrRd9spYNDQ=;
	b=Y5bcGnLeNzM5CcT5ePXNfFs/eEe8WiNQe2COO5PbSqI61cbN7yEok+E1ISsE4vczUuEhtb
	5umaHZWhNjsLTMpgl9WqpL9ebgo5bGqn+FShKDuSq5ZFyVqOX7BI7RA/XB1SsGK+o4qRU3
	peudRo2nCJlJo6Nn0MUJ7iQCYSVhbYU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+A5pxRb7bzt5+nKR5bczxwsUF2b9Qz5uFrRd9spYNDQ=;
	b=Y5bcGnLeNzM5CcT5ePXNfFs/eEe8WiNQe2COO5PbSqI61cbN7yEok+E1ISsE4vczUuEhtb
	5umaHZWhNjsLTMpgl9WqpL9ebgo5bGqn+FShKDuSq5ZFyVqOX7BI7RA/XB1SsGK+o4qRU3
	peudRo2nCJlJo6Nn0MUJ7iQCYSVhbYU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7E16B1348F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id maa+MOEVAGsBBgAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: qgroup: show the "qgroup scan cancelled" message correctly
Date: Fri, 20 Nov 2026 20:11:35 +1030
Message-ID: <769a006802a6faf25316e05e21b62b6d29d6ddde.1795167390.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795167390.git.wqu@suse.com>
References: <cover.1795167390.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

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
  And @cancelled is only updated if the rescan is stopped.

  This is to handle finished-then-cancelled rescan a little better.
  This won't completely solve the cancel race with rescan though.

  But the cancel-race is already there, not caused by this commit, and I
  don't think we should bother too much on the mostly cosmetic error

- Change the message priority so that cancelled has a higher priority
  The new priority list is:
  - Error (ret < 0)
  - Cancelled
  - Stopped
  - Finished

  And we no longer go the complex "if () else if ()" way, instead each
  hit branch will return, so only one branch will hit.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index afac7402af36..1d4a185dd9fa 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3900,6 +3900,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	struct btrfs_path *path;
 	struct btrfs_trans_handle *trans = NULL;
 	int ret = 0;
+	bool cancelled = false;
 	bool stopped = false;
 	bool did_leaf_rescans = false;
 
@@ -3971,8 +3972,11 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 
 	mutex_lock(&fs_info->qgroup_rescan_lock);
 	if (!stopped || test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
-				 &fs_info->qgroup_flags))
+				 &fs_info->qgroup_flags)) {
+		cancelled = test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN,
+				     &fs_info->qgroup_flags);
 		clear_bit(BTRFS_QGROUP_STATUS_BIT_RESCAN, &fs_info->qgroup_flags);
+	}
 	if (trans) {
 		int ret2 = update_qgroup_status_item(trans);
 
@@ -3989,16 +3993,21 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	if (trans)
 		btrfs_end_transaction(trans);
 
+	if (ret < 0) {
+		btrfs_err(fs_info, "qgroup scan failed with %pe", ERR_PTR(ret));
+		return;
+	}
+	if (cancelled) {
+		btrfs_info(fs_info, "qgroup scan cancelled");
+		return;
+	}
 	if (stopped) {
 		btrfs_info(fs_info, "qgroup scan paused");
-	} else if (test_bit(BTRFS_QGROUP_RUNTIME_BIT_CANCEL_RESCAN, &fs_info->qgroup_flags)) {
-		btrfs_info(fs_info, "qgroup scan cancelled");
-	} else if (ret >= 0) {
-		btrfs_info(fs_info, "qgroup scan completed%s",
-			ret > 0 ? " (inconsistency flag cleared)" : "");
-	} else {
-		btrfs_err(fs_info, "qgroup scan failed with %pe", ERR_PTR(ret));
+		return;
 	}
+
+	btrfs_info(fs_info, "qgroup scan completed%s",
+		   ret > 0 ? " (inconsistency flag cleared)" : "");
 }
 
 /*
-- 
2.56.0

