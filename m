Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14F63876DA
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 10:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777632238; cv=none; b=B0tELeNxbM7y9fDTn2TG5bdxshns+G/1HFwm7wJjGTNjXjPjZVfdVmx26GjyOYFog8BYlu+ccAu4aENfEtT9IRvoSyKrPkgXdtJr5lBh2kDVzy85jJToPUVemoAQKmAjXZ761Ta8v+Jnk6OUaUAhu1lWsRkJROEv3QypNSJKiWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777632238; c=relaxed/simple;
	bh=QrYvbbotL+FlWB/gqqjTv+wxOz3W3MqLVz3dbO1PMYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NASZuiCXgYcCty20zSHkcN4caKofWPUhJa/MjP8bI+u7o0YZYRgajgOFCh54rm0R2WUsrnUwSOINA4mbbYsb5MjELV4mpIZUeDb5JoIgYx5PXa3FO+tfBmeuzx/fymon31B0QTL4ociNres2uz7AWrVB+TTUNsq09cblyB0eGkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FxPya7RB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FxPya7RB; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FxPya7RB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FxPya7RB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1ABE46A8AE;
	Fri,  1 May 2026 10:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777632229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PqDG1/QmBL80bFcb0YqmLV/9gbN4eFZ28u2h2eUOxZc=;
	b=FxPya7RBiPXuYo9tqQpBR+u07TqT8GHvt0cVzPI4u9C4og7wk3aSGsD13no8q/SDMX8bp1
	wwALHjVKeFOZHwRxOJlbxA0W2rP7ciLq6w/j54LoriT3x7YtmoxO7EncUhvQr6M1+kgcNf
	UAkva1ybCIize9+8UG8C4dzVfYaUIeA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777632229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PqDG1/QmBL80bFcb0YqmLV/9gbN4eFZ28u2h2eUOxZc=;
	b=FxPya7RBiPXuYo9tqQpBR+u07TqT8GHvt0cVzPI4u9C4og7wk3aSGsD13no8q/SDMX8bp1
	wwALHjVKeFOZHwRxOJlbxA0W2rP7ciLq6w/j54LoriT3x7YtmoxO7EncUhvQr6M1+kgcNf
	UAkva1ybCIize9+8UG8C4dzVfYaUIeA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 160A3593B1;
	Fri,  1 May 2026 10:43:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pSgvMuOD9GnydQAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 01 May 2026 10:43:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Max Chernoff <git@maxchernoff.ca>
Subject: [PATCH] btrfs-progs: docs: update the qgroup performance hit
Date: Fri,  1 May 2026 20:13:26 +0930
Message-ID: <313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.988];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Although we have mentioned the qgroup performance hit, we have never
explained how large the impact is.

Update the documentation to:

- Explain what affects qgroup performance
  Including snapshots and reflinks.

- Explain that the automatic rescan can cause performance problem

- Add extra warning to avoid qgroup
  If there are too many snapshots or reflinks.

Reported-by: Max Chernoff <git@maxchernoff.ca>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-quota.rst | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfs-quota.rst b/Documentation/btrfs-quota.rst
index 131f9506d281..921f37ca6c1f 100644
--- a/Documentation/btrfs-quota.rst
+++ b/Documentation/btrfs-quota.rst
@@ -26,7 +26,19 @@ The qgroup implementation is considered reasonably stable for daily use and has
 been enabled in various distributions.
 
 When quotas are activated, they affect all extent processing, which takes a
-performance hit. Activation of qgroups is not recommended unless the user
+performance hit.
+The performance hit depends on the number of back references for each extent.
+The number of back references for an extent further depends on the number of
+snapshots and reflinks.
+
+Furthermore, when qgroups are enabled, a qgroup rescan will be automatically queued.
+Normally it won't affect the system too much, but since it's going to scan the
+whole filesystem, if there are too many snapshots/reflinks, the system may be unresponsive.
+
+If there are many snapshots (over 20) or reflinks (e.g. deduplicated),
+it's strongly recommended not to enable qgroups.
+
+Activation of qgroups is not recommended unless the user
 intends to actually use them.
 
 .. _man-quota-hierarchical-quota-group-concepts:
-- 
2.54.0

