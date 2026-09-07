Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7948E37E5D8
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788757718; cv=none; b=fi5BJF9xgRFwe8pHS1OsSDK16C1h/azJf3/vHjyZXDxMhc4pJv+ZGB4I4gCePgi1RGRrOc9bpeZ2CMRkZkO70Av9fCucS7is6llAcDjS5JJCOYMVOFcUSn4CuH3Vi14HM3ND0JJZR1zHvXrQ4u1iLOTZ99Lf84D53icLxVXAsA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788757718; c=relaxed/simple;
	bh=Y+FRjUO0B7wTPyAuTHv1j07mh3a9wGA73A1kRUIHjQA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2HuH7WH532UtwpBOO2J5WafTSe/dIRx0NKNF6Anw3I6vgyNJQ2m8w7XbRrfDnqUSIdhpSQN2EP3b7uYwO5wEkqftVwVy8soPqhlkawt5FgrKR8qFC8TP/ebGLH2tyqNM3wprW9Z7dxQiMfPisEkZ+kHidxTJa9ppKhCz1OucJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VmFVZi6K; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VS/noFW2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VmFVZi6K";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VS/noFW2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B6A3F21AE9
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywFa9vbncilu7cavXjSWITntsFe3WELyAavkAbkMmVk=;
	b=VmFVZi6KYDtxSrvyvlUxuwgVGEfm/n1v3yeHbYdyAHknibttCwTBUx4MwJ3tJ42sFDx1J6
	/5H2EGF/bc6sIa7usEfEHwb0GLZ+RZ3J0NL4azTxbZpGsOnUoVLBUz72yewskeguHzWalB
	lG/+SnrgZyvS00mhY4cvhMR17v2vP3k=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="VS/noFW2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788757701; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ywFa9vbncilu7cavXjSWITntsFe3WELyAavkAbkMmVk=;
	b=VS/noFW2BqqtY8Ain33cnQW1OaOwllUnl/Q8omGc50SQp0PmiipTqCst1mw1XouQj8fdg4
	T6HPulBBofiK/TpTPeEyagHMgu1Ihy1NRki2bBs0jez60rnD0fYB3xDHMmqerANFwHEZLJ
	FTWFNc1eg0wBDpwgyEk/M0TzqGO895M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DB661368D
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Sep 2026 05:08:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sLFlC8RGnmoDBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 07 Sep 2026 05:08:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: docs: update the rescue=usebackuproot option
Date: Mon,  7 Sep 2026 14:37:52 +0930
Message-ID: <ff72fa4c04e333cf25d2dd90bd024b0c1de72920.1788743334.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788743334.git.wqu@suse.com>
References: <cover.1788743334.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: B6A3F21AE9
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

This is to co-operate with the kernel changes, and allow end users to
have more control on exactly which backup slot to use.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/ch-mount-options.rst | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/Documentation/ch-mount-options.rst b/Documentation/ch-mount-options.rst
index b3997edda7ff..174cb0c87ce7 100644
--- a/Documentation/ch-mount-options.rst
+++ b/Documentation/ch-mount-options.rst
@@ -343,6 +343,22 @@ rescue
 	  Try to use backup root slots inside super block.
 	  Replaces standalone option *usebackuproot*
 
+	  Before 7.4 kernel, this option will automatically load the newest
+	  slot that can load correct root nodes.
+	  Since 7.4 kernel, this option will always load the second newest
+	  slot.
+
+        * *usebackuproot_0* (since 7.4)
+        * *usebackuproot_1* (since 7.4)
+        * *usebackuproot_2* (since 7.4)
+        * *usebackuproot_3* (since 7.4)
+
+	  Load the exact backup slot 0/1/2/3.
+
+	  For slot 0, it means the newest slot, and should match the current
+	  tree roots recorded in the superblock.
+	  For slot 1/2/3, it means the second/third/fourth(oldest) newest slot.
+
         * *nologreplay* (since 5.9)
 
 	  Do not replay any dirty logs.
-- 
2.55.0

