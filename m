Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458243E6DF3
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180664; cv=none; b=Mwd+JyPcqM/sjc9IAGQMjeqbR/S4aTBYAWW0ebv2lEQB2OvObmQyPX79HV94rUuxWC7MV65Ox4f9sxyLui+fwzl6nXaDX0Fx1z4DuR+VBU5+H1Uj4cEKI9zsQ+LwoSw8eug7WlK9fBfPYm/1b5Ta2Aiy5UNJ6efQFhzVb6YeXjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180664; c=relaxed/simple;
	bh=oMnXjeAaGdDQRffWiVLC+jxFepuYdvUU4fCnYgdYQug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC/PwVTH+kGdEe1XrFP8QJwMA7/oWN/AIJPqt+EBuroMvR1bFkRotNOXKHQQQO7nrmfgaXkaMF4t69D19drffSSDbATePtxgrzhon4ZOxqI11Pe31sjj89TxbTpANmeQCjeFjhnj+xwNIpaqQvY2BFvVFsk8Vi3+afN4wOBFWQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iT7x9drJ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iT7x9drJ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iT7x9drJ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iT7x9drJ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 890355BD28;
	Tue, 14 Apr 2026 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zmRWZmM8awBkbmaKUxqYmfxgoG61C1Ll3hhdZP8FO6o=;
	b=iT7x9drJVii065+Lq0/Y0L8A5kgF6K6pWa78ObcvjYWCAc3Ez/KgUnN5i/Ae7EoM5h1Yw4
	SDvwslEIXFBuAse2TfHHr9t2Sq1sJ1NpT1g/XH+9X6tq8CGxKMR08zBrUGjQIz46gTFR/j
	jd2tg7vGnkaOyo9+RRHAjz19hLlIBvA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776180661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zmRWZmM8awBkbmaKUxqYmfxgoG61C1Ll3hhdZP8FO6o=;
	b=iT7x9drJVii065+Lq0/Y0L8A5kgF6K6pWa78ObcvjYWCAc3Ez/KgUnN5i/Ae7EoM5h1Yw4
	SDvwslEIXFBuAse2TfHHr9t2Sq1sJ1NpT1g/XH+9X6tq8CGxKMR08zBrUGjQIz46gTFR/j
	jd2tg7vGnkaOyo9+RRHAjz19hLlIBvA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 822554B4F9;
	Tue, 14 Apr 2026 15:31:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P6zLH7Vd3mkjPAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 14 Apr 2026 15:31:01 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/6] btrfs: lift assertions to beginning of insert_delayed_ref()
Date: Tue, 14 Apr 2026 17:30:32 +0200
Message-ID: <a205131fe4b625a8c1ea4c155e8fc16c96ae2273.1776180388.git.dsterba@suse.com>
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
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 

There are only two possible types of the delayed ref action, this can be
verified at the beginning for the whole function and not just one block.
Replace the assertion with a debugging warning just in case.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/delayed-ref.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 605858c2d9a952..8bc1929237f70a 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -615,6 +615,9 @@ static bool insert_delayed_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_delayed_ref_node *exist;
 	int mod;
 
+	ASSERT(ref->action == BTRFS_ADD_DELAYED_REF ||
+	       ref->action == BTRFS_DROP_DELAYED_REF);
+
 	spin_lock(&href->lock);
 	exist = tree_insert(&href->ref_tree, ref);
 	if (!exist) {
@@ -641,7 +644,7 @@ static bool insert_delayed_ref(struct btrfs_trans_handle *trans,
 				ASSERT(!list_empty(&exist->add_list));
 				list_del_init(&exist->add_list);
 			} else {
-				ASSERT(0);
+				DEBUG_WARN();
 			}
 		} else
 			mod = -ref->ref_mod;
-- 
2.53.0

