Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBACB448B99
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045411; cv=none; b=GkeobetIOpdPcQl+hwxi4WnW49TQaYwNnsnyxA4dLmw88RaPefGMen8YAqGemSiZ8YxwW+ZtQP3EmHQpgASvp2QirHjdH4qw8NMMfcrr2x0O7+cLqIfig/A5GTBy9QjjA08OmLFSkLg+Ncnp9UDAm4633fgys9K/jc3/Y5kPzLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045411; c=relaxed/simple;
	bh=mkYP0TAhCfjiCGRmPViAZA97dLO2zasE1syLoTzwyy8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBCxTZtbqjlA/xwl5Oxyrajz90khX8j7A/2RgV4yVGZ63lJZMY+/3R8cBTWdlySPx8m3iP5Tj6z9uHgngwa0Ak3SfWmVfp8C8VXoYGth1gmVOhiNq1ecu4bU8nXtcd68tT8FQtOOTwbRX/ypI3EW/EuX5hil5Mc3m088XgcwLX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hQ1X2iXU; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Tz+WiPkY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hQ1X2iXU";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Tz+WiPkY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BF9A73E76
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wYLwcqepvUJpocIksWjLlHtwMFesM/MWGyLkZSbZp4=;
	b=hQ1X2iXUKCEbH/Iyjt5RXt3E5mK1UoryVEd1DAax8/uh6bQ6zrbq2ciUX+Uj2fPsqjqOWg
	ysbvUQt3BHYC+TkmK/JPd8Jxep1o/EgVMtYPHvm3MdO8d4Lmhy5F3RpoFLKPFomVgfCC9I
	xRvb0/g6oKb4J3qwSHoVg5X0SvAUSTU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Tz+WiPkY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wYLwcqepvUJpocIksWjLlHtwMFesM/MWGyLkZSbZp4=;
	b=Tz+WiPkYPWnyZsbLMwhxxrFUWk7KALVINp9QNgSLyafBIBQxewf6Fj6re7virh4sIVcG0c
	1y77ISKILhA/e3e49I3xYCbNcpEwJzmwOn01ze8yfM3sNEppJ6DzdUv6dD4v2B3Xfi8mRs
	/3M4QIGnzh2Nfnvsnd+m2UKuT641UnU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2C40364F
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gIfwERYmhGrKWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] btrfs-progs: corrupt-block: allow dir item corruption to use --value option
Date: Tue, 18 Aug 2026 18:59:32 +0930
Message-ID: <ad705804b71787f295cb5044489f75233e98dee7.1787045341.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1787045341.git.wqu@suse.com>
References: <cover.1787045341.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,suse.com:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_NONE(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: BF9A73E76
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

For now this only affects DIR_ITEM location objectid corruption, but
later this will be utilized for more dir item member corruption.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-corrupt-block.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 9323643d2366..1e49f6ec50db 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -625,7 +625,7 @@ out:
 }
 
 static int corrupt_dir_item(struct btrfs_root *root, struct btrfs_key *key,
-			    char *field)
+			    char *field, u64 bogus)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_dir_item *di;
@@ -636,7 +636,6 @@ static int corrupt_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 	unsigned long name_ptr;
 	enum btrfs_dir_item_field corrupt_field =
 		convert_dir_item_field(field);
-	u64 bogus;
 	u16 name_len;
 	int ret;
 
@@ -677,7 +676,8 @@ static int corrupt_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 		goto out;
 	case BTRFS_DIR_ITEM_LOCATION_OBJECTID:
 		btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
-		bogus = generate_u64(location.objectid);
+		if (bogus == (u64)-1)
+			bogus = generate_u64(location.objectid);
 		location.objectid = bogus;
 		btrfs_cpu_key_to_disk(&disk_key, &location);
 		btrfs_set_dir_item_key(path->nodes[0], di, &disk_key);
@@ -1559,7 +1559,7 @@ int main(int argc, char **argv)
 	if (corrupt_di) {
 		if (!key.objectid || *field == 0)
 			usage(&corrupt_block_cmd, 1);
-		ret = corrupt_dir_item(target_root, &key, field);
+		ret = corrupt_dir_item(target_root, &key, field, bogus_value);
 		goto out_close;
 	}
 	if (csum_bytenr) {
-- 
2.54.0

