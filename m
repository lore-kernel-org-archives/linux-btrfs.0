Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6C62E3FE
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790831822; cv=none; b=nNh1+VgM+6JXRy7+B0TZmo/BzTjh1hQxTlw0Ok+X3a61oCmjvLQo0whgyvg6X0nUIWGH4malFWjMhjZN5ab5bE1RqWuZDpEC4GRPX/2hEb2xIgQKfZ/qlK0UAu5w2O+fpF1QnFfFPvOt1ZmdYr41S/9NQd4sWerjPWhgkNOdFM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790831822; c=relaxed/simple;
	bh=wl37p9MyEM732ki57rYZou+sZOnAwZzsLz1FBdk/8Kc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ad9WSX8JMmBco9ePBGQhesQpKZ8DIIH72rHJp50wGrHaPk1GFc+YXY3B4dU44hfBHeWYU2MbqVbzQ3GTlkdw1zD0TtGKV1a0bSi6CcC34xkP8mXLJErsTMAUDzzBmzzpRDjvp4oaHltgb3aVLrvu5BSl1S1vUNVuIxDAdnOgHMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=j+iMf61/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jOjh96cT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j+iMf61/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jOjh96cT"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 824DE1FCCF
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4HhcopkmocCEPFNe6z+sQTsSAIu9q1twJzameDWJ6c8=;
	b=j+iMf61/7lKf4Fdp92Qt53jJqUNdliAI4OWPSe1UTOsvw+oLbIteeY7cjP0oz/NphTYF8o
	w7m/GDFKkjw1eN1u2WraLZcaVNvobdLU7qRZ80ElR0C603riPSxb8YXz3OCEsWduwPQfUY
	2BqBrWHQRidMUF+UyAtvKFfMfnGARHQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jOjh96cT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4HhcopkmocCEPFNe6z+sQTsSAIu9q1twJzameDWJ6c8=;
	b=jOjh96cTP6jiiPq296zGxmX8YT934QZ1kVU1Ia5GKK/O0DskNHVj1ab+sdlcP2Jq7wcFjj
	AT8IhlDmyaIn9PlWKabxXK74cSEDzLfECQboKm7/5tfaHkWm9tRsp7bJUOrzuudxHVCjH4
	KdSF/tRLsipQFe32OLQ4XQp0GANFSPo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DD0D136A8
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aRXOE7vsvWrVGwAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2026 05:16:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: qgroup: do not leak -ENOENT from btrfs_remove_qgroup()
Date: Thu,  1 Oct 2026 14:46:17 +0930
Message-ID: <aa615350eb99f56402f896e8ad5515c7d9bdac88.1790831600.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790831600.git.wqu@suse.com>
References: <cover.1790831600.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 824DE1FCCF
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

If btrfs_remove_qgroup() is called on a qgroup that only exists in the
rb-tree, then del_qgroup_item() will return -ENOENT, and we tolerate
that -ENOENT.

However if the to-be-deleted qgroup has no parent qgroups, the @ret will
not be updated, and will leak to user space.

It will make the ioctl() caller incorrectly assume the operation failed.

Fix it by resetting @ret to 0 after a successful or tolerated
del_qgroup_item() call, so the -ENOENT from del_qgroup_item() won't be
leaked.

Assisted-by: LLM (exposing this pre-existing problem)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index d3401a6df530..46de0a5e80d5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1850,6 +1850,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	ret = del_qgroup_item(trans, qgroupid);
 	if (ret && ret != -ENOENT)
 		goto out;
+	ret = 0;
 
 	while (!list_empty(&qgroup->groups)) {
 		list = list_first_entry(&qgroup->groups,
-- 
2.55.0

