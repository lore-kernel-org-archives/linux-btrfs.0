Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3494034C123
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773425505; cv=none; b=q0srX9GtaaK1wOeLrdtrYAuHs/OO+8SKsOt5I2jl7Nq+1Pj/VV5ZbIQ3gTqV0g1wVEPLMzvWBuiY0RlBm3eI60whBymHZU8zSbkrHxgWm88p2q7PmwFp5G2GMSHkWBLXW4cko01/dkuaiYDUylv3364WuwEftXGgZjhTI7zubxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773425505; c=relaxed/simple;
	bh=v6560Uop0cSFQkgETM8HmEFZiqYjUdQmwmmyTzNz0AA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Uao25KZTIvyiJUD6QgFaC47IVqRZmxrAsUmhnk7ZdZc5xIJjnX7U39Xmk9Xq854rN41Fwf5DOCstPTlRSj6EZDpy1NmWTvsISR/b7FeLCtWQ2L1siBj+eGRunijQG5hLBhJUaFypZW1L4oW5xl0O5XUEMMTMi7ZRxYmjstuCF3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cyNIvhmf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/H/FRqtk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=y/dv713l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vA6Y+pja; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cyNIvhmf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/H/FRqtk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="y/dv713l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vA6Y+pja"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 41B5F5BEAA
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 18:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773425502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=iB3uuLAh5zRsDap6FArh4pJWUrfzmwyUGDsmpUSRqmo=;
	b=cyNIvhmfBu9V+fX+2o38sh6BuGjTjgaZAc/EZVGwTElYFlgtf5bQpkfb58xlo1Ht1Tc1w4
	0DVp5sIxtTWkG/HB2NmLPV9TVBol7jsqziGGiW+BKLDZHJ/WOhgkRA79x3jIOw+VSIUdc0
	cQYOf6wMS2ZsUB9xCTI9hgt8Fxm5imo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773425502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=iB3uuLAh5zRsDap6FArh4pJWUrfzmwyUGDsmpUSRqmo=;
	b=/H/FRqtk4iTxlCR5iYzUJm7iXdiItxEjw3nF0dMMBbR4cxPQ2LkcjjvxnVzYjTqqJAneaX
	s1a/W0NcnC7L64Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773425501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=iB3uuLAh5zRsDap6FArh4pJWUrfzmwyUGDsmpUSRqmo=;
	b=y/dv713l3lDlb6OvS6INLwNuJlFiZevi4MQTOPsl6ZkquNoxi0CvebuPixCmOoGGdHK33a
	9VI30cEmg/K6RLp/EUORX3nysyIZ1PyIwyQzJOcJN32i1/W9gs2usk/ZL28XICSMBLdt6d
	efm8rBp42Ze/L6szQAK8iwbQ/sIuMzU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773425501;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=iB3uuLAh5zRsDap6FArh4pJWUrfzmwyUGDsmpUSRqmo=;
	b=vA6Y+pjash1qdcT+knDAMpXwGetDY1XNo/A0kIEk0DXvdz63ec8dkJzn89/AbUUGXAQybp
	orHjBch34CvWuQAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 01F6D40665
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 18:11:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id knrKNVxTtGnfIgAAD6G6ig
	(envelope-from <rgoldwyn@suse.de>)
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 18:11:40 +0000
Date: Fri, 13 Mar 2026 14:11:39 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] btrfs: fix a crash in the trace event btrfs_sync_file()
Message-ID: <3srimnopvbtufn345f73ahr33w57vryl2fxxn2flp2gyc2lr3o@6glyzvqevghe>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Score: -3.80
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

If overlay is used on top of btrfs, dentry->d_sb translates to overlay's
super block and fsid assignment will lead to a crash.

Use file_inode(file)->i_sb to always get btrfs_sb.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
Changes since v2:
- Use of dget_parent() to get the parent of the inode
Changes since v1:
- Changed subject to include trace
- Use file_inode() to get inode pointer

 include/trace/events/btrfs.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 125bdc166bfe..0864700f76e0 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -769,12 +769,15 @@ TRACE_EVENT(btrfs_sync_file,
 	),
 
 	TP_fast_assign(
-		const struct dentry *dentry = file->f_path.dentry;
-		const struct inode *inode = d_inode(dentry);
+		struct dentry *dentry = file_dentry(file);
+		struct inode *inode = file_inode(file);
+		struct dentry *parent = dget_parent(dentry);
+		struct inode *parent_inode = d_inode(parent);
 
-		TP_fast_assign_fsid(btrfs_sb(file->f_path.dentry->d_sb));
+		dput(parent);
+		TP_fast_assign_fsid(btrfs_sb(inode->i_sb));
 		__entry->ino		= btrfs_ino(BTRFS_I(inode));
-		__entry->parent		= btrfs_ino(BTRFS_I(d_inode(dentry->d_parent)));
+		__entry->parent		= btrfs_ino(BTRFS_I(parent_inode));
 		__entry->datasync	= datasync;
 		__entry->root_objectid	= btrfs_root_id(BTRFS_I(inode)->root);
 	),
-- 
2.53.0
