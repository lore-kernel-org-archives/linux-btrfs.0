Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57F37FF60
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205167; cv=none; b=XwO+YLE7L7FrGpozA8hjjZtdImh0Dra0tzs/8HAUJYBjCKneJScHdEXwdjA44q3oDfAj3xNzA2dAUn1NGf6WuF5gt6I0eHz2qa1lAJxhAfM3GNduACFKp7v6HrtcSzn9/ud0RyEc106OVxiaqjHt47rQ6oFALZtgL2jMPGVDOsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205167; c=relaxed/simple;
	bh=bc8pvL/mED16oGQnWENoxS9nAOOivgIz8vxG2+TFtpg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=oLm7vKsRGzG1Qt2so9AYL6+k6kBjDTNhiCWS+ujg34JG8ax5mxtV6BUbj4N3EWAjXAGmUmOj88f0ckcedVIU9Hjuo+mkFXrKXF7w3LPruZHl6CvrKdxleSSyeSXGJLrp2u6v12s9J0wc60kXlaA8GLHgBcrLxi6lvRMp3b3SmFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m7CWnmv0; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VROucEgc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m7CWnmv0";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VROucEgc"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A3D31FF10
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 09:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789205160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B+FMMtjFaY9ASALBE6zGToOWn7v46lxgiRlxTWrpdeA=;
	b=m7CWnmv0VjwZO4z7d5AkInvu49FTVVpic4lbHjijvz9whzbcMGZcmdsELHd9koSwCu5leW
	xVZXsRoOonApX9D3z6lkIBMhObSBjUNSUo/hmvg9wfXXYWT5aHqUZvQDmsLL2gXKiq2jJk
	pWkToNxXOfxvRBoLSYf18ordMdgJLs8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=VROucEgc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789205156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=B+FMMtjFaY9ASALBE6zGToOWn7v46lxgiRlxTWrpdeA=;
	b=VROucEgc8NjZ41stU9/9B1nF21cXPEi5dJlajdUlbaI9gENf1lAOXSHScu92VbsPbVXTpq
	9M2nIZYec/FBKDufA4AKnzw5LMDo5UXB9xuIABlVx+CrA+90XWff9dGsDPqWJZ1o56pOhr
	ukyHcayPUsfQ0vyVRFQsFt34e0s1fSE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D1B713331
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 09:25:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id a8RqL6IapWpSVwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2026 09:25:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: docs: discourage root btrfs usage without an initramfs
Date: Sat, 12 Sep 2026 18:55:32 +0930
Message-ID: <c0fbd931a33a130a51f215fc0712954edb18b654.1789205131.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
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
X-Rspamd-Queue-Id: 3A3D31FF10
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

For multi-device btrfs, device scanning is required before mounting, and
without an initramfs it's impossible to mount a multi-device btrfs.

Even if the rootfs is a single-device btrfs, there is nothing preventing
the end user to add a device to that btrfs, and fail the next boot.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/mkfs.btrfs.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/mkfs.btrfs.rst b/Documentation/mkfs.btrfs.rst
index 0d3d6051b0e7..0bc7b7ac3808 100644
--- a/Documentation/mkfs.btrfs.rst
+++ b/Documentation/mkfs.btrfs.rst
@@ -346,6 +346,10 @@ devices to scan at the time of mount.
         before all block devices are discovered. The waiting is usually done on the
         initramfs/initrd systems.
 
+        Thus using btrfs as a rootfs without an initramfs is not recommended.
+        Adding a new device to the rootfs can easily cause the next boot to fail, as
+        there is no way to register all devices prior to mounting.
+
 .. warning::
         RAID5/6 has known problems and should not be used in production.
 
-- 
2.55.0

