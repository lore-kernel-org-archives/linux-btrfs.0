Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333759;
	b=CcxdkrQaAwZkS9BdymhByXyLXA6KmSyUn63S+sWgZezKRUu6PVqUuNUCdardKm8rglVX
	 iFPpfKfgQQcZxIZS2upgAPZ44BR/yraRGQUFNTBueGYgegHF4Y+Wc+E2EElQHVIPMC564
	 9R6kWlKL/Md2S9YfffF3loPLgZp7B0PIiodcD0nRfHJXvDo75Hz9YyC/J8azNmQB62oCV
	 pvlYDpjI1SGvwhPfuEL3CICvWua7+WY7JdPVOxWrgM35JrdPvVAjzMAIX7EucrDEYrDGj
	 z804WDUbt2qOHPNZlpjCUUfhKrI3pC0sPrJ8VkrVGKgC9LNbUwHmqP8Jj39EAtkx8wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333759;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=CDf5aVuptx/52583quL2Qh09EwaoUD4n3whWY35VJuw=;
	b=kmyQjimNaW8yf9MV/iv0vdiY+tkEzaqNfo/zhF4y6AtsY3m0tRuxJ9OlBuZ/CVGKpy0j
	 dIMJWVicY/6to8BWfxLDfCtMSv25URsx8mQ5xhe9rwFlMu53nzamOAMEkHYj5zhPDaTOR
	 aoscV5BmD0uC002B2lR4kdlHsU1nsCYXHkoEFDCy4XQzQ1KB/M2UCl5VIX6uGNFbwIWTq
	 X5IYYONWlyuVGoNvcf6enW0+S13WvcJW/irrOUn9h0deNk7bCcWi7r08DVgDDUsO6HujD
	 cv4NHvbm97R9pXUTdAAEkj4rH7/8NRjbaU5oqYo0o8DmLLuENLoNRCtJyPprNsu/SoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=h1hFmQAR;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=DczFK0h9;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFC7606A323
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AFC7606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=h1hFmQAR;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=DczFK0h9
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F24B51FCFA
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDf5aVuptx/52583quL2Qh09EwaoUD4n3whWY35VJuw=;
	b=h1hFmQARnLoBJkYwD2YXMZ4ZDDc+zjwlmSxKk4uh6dFqPG2/TiGiKolu5vUYNivsLvYZ+X
	mmnmvF8xUxJaHdOwKI4qL4D7yQmSBF/B2L8DsNIpwU7YbdKCxr8/vx9Oit0rzUvLsB1MR1
	+Wu/7ySz4e0A324uTj+jBEYXvSoe95A=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CDf5aVuptx/52583quL2Qh09EwaoUD4n3whWY35VJuw=;
	b=DczFK0h9+BY1j6dOUvs35sIaMkqKwu3xy85ydq6SVLPDw2wTFzeXMcZtsBHLTnNFjv3Kvj
	ibDFvyTdjl9NqgF2WBF2lcZlC8pXXCxRUH4n5zArbu0AjIqBBdwwS/1IvGUTUUokNajKxT
	mjQTIhVoq6RGiX/g9zGtCQZ+uUePTMQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E143F13432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig:T12
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/12] btrfs-progs: dump-tree: fix exit code and leak on open failure
Date: Fri, 30 Oct 2026 14:45:18 +1030
Message-ID: <f9c76b6a170acfc3d6f7f7406ca726ee228e7c8b.1793333606.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
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

If open_ctree_fs_info() fails, or the fs root can not be opened,
cmd_inspect_dump_tree() prints an error but returns !!ret, and ret is
always 0 at that point.

So the command exits with 0 on such failure. Furthermore, if the fs root is
missing, the opened fs_info is never closed.

Fix it by returning 1 for both cases, and close the fs_info for the second
one.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/inspect-dump-tree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/cmds/inspect-dump-tree.c b/cmds/inspect-dump-tree.c
index 09ac9e181376..a9b369b4aba2 100644
--- a/cmds/inspect-dump-tree.c
+++ b/cmds/inspect-dump-tree.c
@@ -412,7 +412,7 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 	info = open_ctree_fs_info(&oca);
 	if (!info) {
 		error("unable to open %s", argv[optind]);
-		return !!ret;
+		return 1;
 	}
 
 	print_mode = follow | traverse | csum_mode;
@@ -426,7 +426,8 @@ static int cmd_inspect_dump_tree(const struct cmd_struct *cmd,
 	root = info->fs_root;
 	if (!root) {
 		error("unable to open %s", argv[optind]);
-		return !!ret;
+		close_ctree(info->chunk_root);
+		return 1;
 	}
 
 	if (!(extent_only || uuid_tree_only || tree_id)) {
-- 
2.56.0

