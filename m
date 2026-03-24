Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5C543147
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774396096; cv=none; b=ZmB90HBlRs9oVE+Gz+SGIapNLSqs/9hsgT+lsTBdKFCKiXjjn3JCi9nucjx1u1GfEVv30/xOIPyscBLjH+jB1o4mE2k1KTQTE+K8a9XiGD5uvoMFAjuHZNcL97Y579hZpMP7jz9P1h/m1p0WIzVu6zpn0QfrZAg6Uvu0c08wj7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774396096; c=relaxed/simple;
	bh=zRs4WSF9ol9S8uldQCZapbi0HatdGD56LyaE2T00NJg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ1+aNj8hf6TbePC0NAihESPFcrpMd6MSIsNpn9GZPEn5jfZxjaM2/uu5wqJo30vZD5tTMEASjkQ2YVSu9etzZ2wwC2K/6CtHTnu0N6X/BTSX0QUWl/cX6GfzIr77wHXCwPZc8sn9+P/PWZHlVr09uS9ImTxdGTBdEG58CJPIAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sk0XTRtr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sk0XTRtr; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sk0XTRtr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sk0XTRtr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 06B384D216
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774396093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDCax6ORqUzREtSxDwvJuW+PrGLjKhp9xZSnsJ6JSwA=;
	b=sk0XTRtrknv5lxDK1FMJl8qhXcqXB+J4wzVeVYFGhO/5M2u+bm7P0oYpSJXKTl2mzsnz1p
	nXwX33ks69BJjrxTWB8RLkxAzfIBM7ZyS8fILfsFNWom1F9UktsXjZFd/t3Bp5rO3FysLw
	OkzBeprkQMpBMznGiQxSdZ7s6xYTnFU=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=sk0XTRtr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774396093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pDCax6ORqUzREtSxDwvJuW+PrGLjKhp9xZSnsJ6JSwA=;
	b=sk0XTRtrknv5lxDK1FMJl8qhXcqXB+J4wzVeVYFGhO/5M2u+bm7P0oYpSJXKTl2mzsnz1p
	nXwX33ks69BJjrxTWB8RLkxAzfIBM7ZyS8fILfsFNWom1F9UktsXjZFd/t3Bp5rO3FysLw
	OkzBeprkQMpBMznGiQxSdZ7s6xYTnFU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44C36440D9
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2BQ+Arwiw2nlIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 23:48:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: check/lowmem: recognize verity item keys
Date: Wed, 25 Mar 2026 10:17:52 +1030
Message-ID: <2fe8927a275f1e4d635ab11dc57006972be8aa24.1774395991.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774395991.git.wqu@suse.com>
References: <cover.1774395991.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 06B384D216

Commit 4e88bb6e ("btrfs-progs: enhance detection on unknown inode keys")
added stricter validation for inode keys in the lowmem mode checker,
flagging unknown key types as errors. However, it did not add cases for
BTRFS_VERITY_DESC_ITEM_KEY (36) and BTRFS_VERITY_MERKLE_ITEM_KEY (37),
causing any filesystem with fs-verity enabled files to fail the lowmem
mode check with the following error:

 [5/8] checking fs roots
 ERROR: ITEM[257 36 0] UNKNOWN TYPE in leaf 30490624
 ERROR: ITEM[257 36 1] UNKNOWN TYPE in leaf 30490624
 ERROR: ITEM[257 37 0] UNKNOWN TYPE in leaf 30490624
 ERROR: ITEM[257 37 2048] UNKNOWN TYPE in leaf 30490624
 ERROR: errors found in fs roots

Add the missing switch cases so that verity metadata items are
recognized and silently skipped during the lowmem check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 4375b92a5d12..5f41cda965a4 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2817,7 +2817,10 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path)
 			err |= ret;
 			break;
 		case BTRFS_XATTR_ITEM_KEY:
+		case BTRFS_VERITY_DESC_ITEM_KEY:
+		case BTRFS_VERITY_MERKLE_ITEM_KEY:
 			break;
+
 		default:
 			error("ITEM[%llu %u %llu] UNKNOWN TYPE in leaf %llu",
 			      key.objectid, key.type, key.offset, node->start);
-- 
2.53.0

