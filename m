Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502BF37C105
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 23:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777420089; cv=none; b=Gw/IhTRQ2CfwhOQ8ykiz6e0meNwsSasZl/8/zBCi6YLlDnWM9BQkvsd/SjrsAuu9YrynfSwkjWWbyRipBjhq+hZKl0Hyba7oBwj6xgFMr79nZY0RyhZiny1unn+9JwJYmaPkVJtLGOG3aNiza9kbpcgPoaOtHL4c6xoRILqKtuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777420089; c=relaxed/simple;
	bh=s+ahOLTlt4dK+FN7xNwSLgFYjFgmCq233RgthPp4DIg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GuIpOBqSbVYauRwpVnHxShsQ8okYDEeKNsj5LtDrFHpuKKCaJNvsya7UP3tUhnHDtJqYyUCFDAj+6KxaeN1/P/p9bQ4u281L54j362XAI0KfvpMRa1EtV3/YDprJN40V6crYAlY/SEkdt+c8ApyvR9lhl4p+CNWaJxXJQhB8kOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rpRCVJcD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rpRCVJcD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rpRCVJcD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rpRCVJcD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 94E365BD15
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 23:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777420086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JZHvS1QEG4MiePbZ96n9EiyNDn0A+6pezC37ETCMYi8=;
	b=rpRCVJcDTSnEMNYTbnhallQqxM5WosuHqRlkb82BIjshcm9KoONFfeh2DGRTw0fVMMizPa
	Lw7d2lT/b6T816C53jwBUhxxY7bHEXMBqv+yZOp0ihHUnNwW620Ud5hYHYptCvrVJ0x7Tq
	LBwADLXZCx9Xgn3phB8TVEqQZNoaPxA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777420086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JZHvS1QEG4MiePbZ96n9EiyNDn0A+6pezC37ETCMYi8=;
	b=rpRCVJcDTSnEMNYTbnhallQqxM5WosuHqRlkb82BIjshcm9KoONFfeh2DGRTw0fVMMizPa
	Lw7d2lT/b6T816C53jwBUhxxY7bHEXMBqv+yZOp0ihHUnNwW620Ud5hYHYptCvrVJ0x7Tq
	LBwADLXZCx9Xgn3phB8TVEqQZNoaPxA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8CDB7593B0
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 23:48:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ulumDTVH8WlgTwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 23:48:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs-progs: docs: update the operations affected by swapfiles
Date: Wed, 29 Apr 2026 09:17:38 +0930
Message-ID: <357262c371343c6d6919b7827803194cb46a5e40.1777420050.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
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
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.980];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Scrub and dev-replace share the same routine, thus they are both
affected by swapfiles.

If there is any extent of an active swapfile inside a block group, that
block group will be skipped by scrub/dev-replace.

Furthermore, since balance and scrub are both block-group-based, any
block group with extents of an active swapfile will be skipped, this
means even a small swapfile can have an amplified impact on the whole
filesystem.

So also add extra sentences to avoid swapfiles on the root filesystem.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Add extra sentences to avoid swapfiles on rootfs
  Since a block group with any extent of a swapfile will be skipped,
  even a small swapfile can have an amplified effect on the whole fs.

  Furthermore, unable to balance a block group can lead to unbalanced
  data/metadata usage, causing possible early ENOSPC.
---
 Documentation/ch-swapfile.rst | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/ch-swapfile.rst b/Documentation/ch-swapfile.rst
index 2c20104b8402..c74b5f5aadbb 100644
--- a/Documentation/ch-swapfile.rst
+++ b/Documentation/ch-swapfile.rst
@@ -23,10 +23,11 @@ are on one device but this cannot be affected by user and depends on free space
 fragmentation and available unused space for new chunks.

 With active swapfiles, the following whole-filesystem operations will skip
-swapfile extents or may fail:
+some block groups or may fail:

 * balance - block groups with extents of any active swapfiles are skipped and
-  reported, the rest will be processed normally
+  reported through dmesg, the rest will be processed normally
+* scrub - ditto
 * resize grow - unaffected
 * resize shrink - works as long as the extents of any active swapfiles are
   outside of the shrunk range
@@ -36,6 +37,22 @@ swapfile extents or may fail:
 * device delete - if the device has been added as above, it can be also deleted
 * device replace - ditto

+The above limitations will significantly affect btrfs maintenance routines, including
+balance and scrub.
+Balance and scrub will skip those block groups which have extents of an active swapfile
+on them, and those block groups may also contain extents belonging to other files.
+This means swapfiles will have an amplified impact, much larger than the size
+of the swapfile itself.
+
+For balance, it means data block groups may not be properly balanced, causing
+unbalanced data/metadata usage, which can lead to early ENOSPC errors.
+
+For scrub, it means data block groups may not be verified, degrading the
+integrity of data.
+
+Users should be aware of the impact when using swapfiles alongside other data.
+This is especially discouraged for rootfs.
+
 When there are no active swapfiles and a whole-filesystem exclusive operation
 is running (e.g. balance, device delete, shrink), the swapfiles cannot be
 temporarily activated. The operation must finish first.
--
2.53.0

