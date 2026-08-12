Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2705025771
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 03:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786504819; cv=none; b=Svw5Te5J5sEeRf0zpx3zcjPyzmDRwvSCVhNxqzxEanVFESpRX2ybVCUcRkPRksq1O7dckQjwqz1lKiZJGKUzW94M3InmK/3T0L8JID/KmAIarj1tHW+zj9ur9PbCTiuqxA5yWtuyYy/0Q3Ws9gOHqLJAZ+Qcyo5TSoaSQMTuQVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786504819; c=relaxed/simple;
	bh=VyzBFwdjOeVrcjkwM4g76IJvzwMo2dAQnogvR/f1Pi0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rSflAn7ridy8eHbPI+1iMLVyeElAWNR51fzjsxiyPrWQaQUbl2U7cnliP+u07U37ud/RkPGmRJkAfZxNkqn7ZuKaZUe/wEJtLF0sCWSHJ2zEGAoQWjkPR+dDMDlpq7ynXsIGtwQ0RAwYrIC0W3115pVRPlI8rOE793LHQQq+T0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MdasOkPn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oaVhyESV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MdasOkPn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oaVhyESV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D5E423E33
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 03:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786504812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GGaaOTm1f7RAlS6/IH08oaKOFdV3gHE2wWuK9TQ3ksc=;
	b=MdasOkPntMErxjjWZ6gx3sJKTpUXWEZjRbPsphW+GpXy1V6pPhf1629GNp96fH+cXgCCTH
	TNtJVZxJPQzHDB2lCrnAMW7WDFLR/w/PRZNFef/nWAe3tbV1qrZms5vMXuXicZCi774qLI
	A6UelmLrqGQvCK2z2xZ9OziBlgoYTDs=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=oaVhyESV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1786504807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=GGaaOTm1f7RAlS6/IH08oaKOFdV3gHE2wWuK9TQ3ksc=;
	b=oaVhyESVeUdl7EMLYbOqiBIISkDwlrQiXo/UdL7kJEwhgXWpKi57UMgQPEXmTwgwWNgfq7
	6fRKsAwsdjUXvdbdK1wSkW2I6HTHf/HYgStT3CPAyxz6GFhoiN4QFPjxQln3jsEVwk75nu
	U3y6c/M9zicgd+42viREHr6YhZYk0ko=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B55AF779B1
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 03:20:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QXrnFWbme2rReAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2026 03:20:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: docs: add a note about RW degraded mount
Date: Wed, 12 Aug 2026 12:49:47 +0930
Message-ID: <7a1f1d24f2a8c09b3791eac78cce64d5d8130dd4.1786504762.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: D5E423E33
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:email,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

When a new chunk is allocated during an RW degraded mount, btrfs can
allocate new chunks with other profiles, like SINGLE, if the current
devices can no longer support the original profile.

This can cause unexpected chunk profiles, and the end user is
recommended to balance them out if they want to maintain the current
allocation profile.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/ch-mount-options.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ch-mount-options.rst b/Documentation/ch-mount-options.rst
index 7ce56c7068ee..b3997edda7ff 100644
--- a/Documentation/ch-mount-options.rst
+++ b/Documentation/ch-mount-options.rst
@@ -180,6 +180,14 @@ degraded
         then the constraint of single/data is not satisfied and the filesystem
         cannot be mounted.
 
+	.. note::
+		During a degraded mount, if BTRFS is going to allocate a new chunk,
+		and the existing devices can not meet the requirement for the
+		current profile, BTRFS will fall back to other profiles like SINGLE.
+
+		It is recommended to check and balance chunks with unwanted profiles,
+		after an RW degraded mount.
+
 .. duplabel:: mount-option-device
 
 device=<devicepath>
-- 
2.54.0

