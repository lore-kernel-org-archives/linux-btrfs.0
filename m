Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4320C42048F
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007046; cv=none; b=PBkVAi2/gTxp6a3eskCy45GoAxxUCJ3Kmmn3pb9c5P4DCifxl+wEIJxhBNroTSn0a4/VqQQ+LDk4Fj+g/vprHjP97UOsYbYJEym+uQQu9fw9baeJDYymwe3pPCKFGuETEIJsVlkqzaAgYbewG99Torz32ARj+eimCoPLebXvcGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007046; c=relaxed/simple;
	bh=hdaM0FvjU5ObLwGFDHkhqBtIiom2THKpCsuRBTn37MM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=chio7IvQi0SX0530Qtt6vJ9luDc2rsw1yf088gVQg4o1w7GXr+TMk95IEgKj0I5ze0dNzx8enq5suyXXogStM+h6B/k5OfQq02Ue+BesqkOWF/whbbtwpVH8D41MRhJBcJhNfLlm51GtOif/SHHiEvIag2UNQDoZ2daauPStzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qrm80osH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JsarFXyS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qrm80osH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JsarFXyS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 24CDE3DF3
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 09:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786007039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=f5+7H41QD3c4KSJMYQI7Z5J837njTJqp34STmGMIyos=;
	b=Qrm80osHmvgoKhGTlpDUKM9b6wfxstcr3w7xF06tq0D+HIryEzykkshsWRPP8WKywfZMZg
	xPGRDrAOV0I/5vo0jJwywi8yjaQlC5gOpGyzayYRySuEc6zvxIx83FWaZpM/H4wAM6mlVX
	mJ4tL0/CLeLy4egD1grB1+/sgPlDuDw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=JsarFXyS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786007035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=f5+7H41QD3c4KSJMYQI7Z5J837njTJqp34STmGMIyos=;
	b=JsarFXySWXO+eNaB+HmN3Y9TzXBn3rz8FB/lEL7pVXJ/3V/o2EAzZKdyz/lqz/8BaK1vvK
	dSz7OWqnK3QUIvuBEsYLTJ9gdzr7kxYrvvaMhVG8oXCbxarJXnYQ6V3YUwxhKZtcNM/V72
	OzUhd6V0Mp8ABeQ6L1FQnzw1Tx/7pWk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62A01779BF
	for <linux-btrfs@vger.kernel.org>; Thu,  6 Aug 2026 09:03:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bCGECfpNdGowEwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 06 Aug 2026 09:03:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: docs: update the stability on btrfs-quota
Date: Thu,  6 Aug 2026 18:33:32 +0930
Message-ID: <79c5e699d6433ba7c8444c2ea12eebeb58149886.1786006982.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 24CDE3DF3
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

The core design of btrfs qgroup mode is to track the ownership of every
extent accurately, but that is conflicting with snapshots, which can
change the ownership of tons of extents in a very short time, during
snapshot creation and deletion.

Although qgroup mode has several workarounds, it is not fully resolved
and still introduces extra costs, e.g. requires frequent rescan,
breaking limits etc.

So make it more clear that qgroup mode is not recommended until the end
user has a rigid subvolume layout, e.g. no more new subvolume/snapshots,
nor deletion of any existing subvolume.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-quota.rst | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/Documentation/btrfs-quota.rst b/Documentation/btrfs-quota.rst
index 131f9506d281..687a678669f2 100644
--- a/Documentation/btrfs-quota.rst
+++ b/Documentation/btrfs-quota.rst
@@ -22,12 +22,23 @@ of a btrfs filesystem. The quota groups (qgroups) are managed by the subcommand
 STABILITY AND PERFORMANCE IMPLICATIONS
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
-The qgroup implementation is considered reasonably stable for daily use and has
-been enabled in various distributions.
+The qgroup mode is considered not recommended for daily usage, unless there is
+no planned new snapshot/subvolume creation and deletion.
 
-When quotas are activated, they affect all extent processing, which takes a
-performance hit. Activation of qgroups is not recommended unless the user
-intends to actually use them.
+The core design of qgroup mode and snapshot are not compatible from day one, and
+are the cause of all kinds of performance problems.
+
+When qgroup mode is activated, it affects all extent processing, which takes a
+performance hit. Operations that modify a whole subvolume/snapshot in one go,
+which include snapshot creation and subvolume deletion, are heavily affected and
+can cause a system hang due to the heavy load.
+
+Although the kernel is taking several workarounds, the problem is not fully resolved
+and has extra costs, e.g. marking qgroup inconsistent, breaking limits and
+requiring extra rescan.
+
+Activation of qgroups is not recommended unless the user intends to actually use them,
+and the usage does not involve new subvolume/snapshot.
 
 .. _man-quota-hierarchical-quota-group-concepts:
 
-- 
2.54.0

