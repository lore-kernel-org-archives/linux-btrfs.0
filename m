Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522813;
	b=OY4kf2Alktr9RG3LRFGBqPn0DJdMC5FsE0i8yDm1A+ER3GKKV0xw6UU/dJj4q+Qo7v6c
	 o3gDZpbvoPql165gUC8RD/F4yExTVl03lsMWiuRmELj5te9qHVc12/ezj+qKX9ds9H1Qa
	 TJ5po+H9xcslfNvam9ju4+eA+HWjbNuallqVVPY5PJEXJuVACRXrtzeOa6MEP0UxCF3iO
	 +zJZXRu1VqlZ2/TLv46ikewfWT82I9i1g8DUjPBxgdboke/2sNSdSEixMZRYkofcnsNZt
	 TLxlbIueNBWhEvM2YMusyB0rAylO4jPXDRUeOBUCjHp4gJjFt7Bcb/Ww4fM1y5oKv/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522813;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=LEELu306Q2h7ZAApNcQ7qOEkmwN+zAlQIXhcc2dRmJc=;
	b=Q/vCdKJm/5zVokDAp5eNLgmSBVEXtroTSeQSlBeuv3VnPcDcNa7373JPXwqfvWMcD7wg
	 nTARmZMXFnFaNvZYUpON0+ZZzejJoHz8kTDGeP0otciyshA/JOnTqYhXipRFLQ7CcxWqK
	 wMv6mn5XKiJlWSa7U5a7M+sz+vwpYS9vp+964yb6LjMHoLAzZHnjvFjnxwyOQDXNJfMQN
	 NQIELRu5DKp7/qQGkt2n7zuusm8GeH6xV9pdBxi/zRobOZQIxKBSw26JU7+j++MhjXX+u
	 AB2Ra83B0DChG0S6k6E3YkRWUXmDXZGspuFUqneopdgfaf8bgcpaS4dz3/runusCOsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rqG7JwXM;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Eq2d9RCw;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C118F606A321
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 22:33:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C118F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=rqG7JwXM;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Eq2d9RCw
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D54E122229;
	Thu, 12 Nov 2026 22:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794522811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LEELu306Q2h7ZAApNcQ7qOEkmwN+zAlQIXhcc2dRmJc=;
	b=rqG7JwXMc08KJYaf0y+8Ds2yANcE0Zuw85LBmcRhhboWugoIOOSouqQY+wsxo9AkJ/TBLf
	I8NY0A683TPMvoYBZN8w3BSvEqvJBFMJxtkqrgttt1T8tkt2gGzYCpmWZMNu4KV1uxNNyI
	U0b1fh0jRUEOvW8G9kZmurhCv+4ZnW4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794522810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LEELu306Q2h7ZAApNcQ7qOEkmwN+zAlQIXhcc2dRmJc=;
	b=Eq2d9RCwbDJbwtTadHcjHbyR9wjis9w4A+uLDN5DG4sQhBkKSaHUXxRcC9mvvSTI+J6sLH
	hXdndhELvqHfHK5Ao4qPznnzFjSC+weLFlYu9f2/McO2QZXvKy20x/PWv2HEGWmyOQZP7u
	vv5O09dXxpik78GCI2K+u58rf6Szf94=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 528F713432;
	Thu, 12 Nov 2026 22:33:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GrVXJrg+9mqELwAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 12 Nov 2026 22:33:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] btrfs: props: validate property values loaded from disk
Date: Fri, 13 Nov 2026 09:03:10 +1030
Message-ID: <27eb729ab79e98927812e0e1df9e699716df6036.1794522787.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Sashiko reported an out-of-bounds read during prop_compression_apply().
It only checks the length for "no" and "none", but not for "lzo", "zlib"
and "zstd". A crafted or corrupted image with a short value such as "lz"
makes strncmp() read past the end of the buffer.

Normally a prop is validated before applying, but that only applies to
set and inherit paths, not the loading-from-disk path.

Hardening the behavior by calling handler->validate() for non-empty values
before applying them, the same as the set and inherit paths do. Invalid
values are skipped with a warning.

This may cause a behavior change: validate also rejects compression on
inodes that cannot be compressed (NODATACOW or NODATASUM). Such an inode
with an existing compression xattr, e.g. one set before "chattr +C" on
an empty file, used to get BTRFS_INODE_COMPRESS applied on load. Now the
property is skipped with a warning.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-c5d0a07b-d18d-495f-96b7-9dadef420b95
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/props.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index 7cc82366a1df..271f169aa5b0 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -273,6 +273,21 @@ static void inode_prop_iterator(void *ctx,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
+	/*
+	 * The value comes from disk and is not trustworthy, nor NUL terminated.
+	 * An empty value is valid and just resets the property to defaults.
+	 */
+	if (len > 0) {
+		ret = handler->validate(BTRFS_I(inode), value, len);
+		if (unlikely(ret)) {
+			btrfs_warn(root->fs_info,
+				   "invalid prop %s for ino %llu (root %llu): %d",
+				   handler->xattr_name, btrfs_ino(BTRFS_I(inode)),
+				   btrfs_root_id(root), ret);
+			return;
+		}
+	}
+
 	ret = handler->apply(BTRFS_I(inode), value, len);
 	if (unlikely(ret))
 		btrfs_warn(root->fs_info,
-- 
2.56.0

