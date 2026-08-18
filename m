Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD7D4483A4
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045409; cv=none; b=H/5/SPE6ejkTGo+1qKdOgVmLc5H5G2auA14n5Ru57tt1nM20YNd3iskJVLcbo3PWlUJ7o9nIbrELh8JkoqOjc3+6HrysJ1GBTKTbs3gRVxQNaw/+dRreGTYdmXBPPc9ouwr1iZTakaSGIZ9UxaYrQYUCgvR+kC+3eP37Ro3p6Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045409; c=relaxed/simple;
	bh=atGxHi+Y0b9z6XqZxJ6Qau3NQr4hJjN1WenJvX/1p6k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTPTsGuDg49iVnuuzSTVRJ3t1rfCx4hAc9Cma3hQRtOV1d2WkmIhKp2K8ObBk5lumTPgDsPC0Bxo/t1by3dxaC+hqcN6d+8v+7kLWfEkLVNcmuc7m860I0uM1rCmi8hhEIYcYttxLdOE0fsJSXegu1PRGqvB4WabQVAN47CZvW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IZiNIY8Q; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UKW2u82e; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IZiNIY8Q";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UKW2u82e"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E829F3E9B
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4EcfCLewdGFEV7x47oOtW1maLbJRay5HqTnsL1CoEg4=;
	b=IZiNIY8QK3e/k2k1Z331P6FPWcKisy2ghDOmzG8XV4bJ4x/oxt2qf1hlBPQwvMCq14R9sK
	JoCg6qKOBbG5b/ehVmMQQWlpt8af29HQEkDv60N98ZTqxIsxZfULqFFqOHDt5PHsiocb4X
	ncd9B2GEZ8CSGYEc/WKqwwdlZLyWpJM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UKW2u82e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4EcfCLewdGFEV7x47oOtW1maLbJRay5HqTnsL1CoEg4=;
	b=UKW2u82eHAqRW85EqYj4r3kjOD/2YZfINbru0qnmvueJjBmE4sidfe3/i4CUg+KEU/Pzua
	IVXFu4D16dpMkN4ZOY2uboUYTl9DpsnPnGPZW9NfaHnuWqVNMXzj8X7fQfp1vj7KDOsW1H
	dK28eZ9DWrwmS0R0/RabY6q1DHEx3pc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC772362E
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sBotHBQmhGrKWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/5] btrfs-progs: corrupt-block: allow inode corruption to use --value option
Date: Tue, 18 Aug 2026 18:59:31 +0930
Message-ID: <c35a4025239ad19c0ac1004347dca0b906ab1e3b.1787045341.git.wqu@suse.com>
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
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E829F3E9B
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

This allows us to do more accurate inode item corruption, not only to
inject random number, but more targeted values.

This feature will be later utilized to change inode's mode from REG to
BLK.

Assisted-by: LLM (coding)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 btrfs-corrupt-block.c | 51 +++++++++++++++++++++----------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 69893f66a32a..9323643d2366 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -694,14 +694,13 @@ out:
 }
 
 static int corrupt_inode(struct btrfs_trans_handle *trans,
-			 struct btrfs_root *root, u64 inode, char *field)
+			 struct btrfs_root *root, u64 inode, char *field,
+			 u64 bogus)
 {
 	struct btrfs_inode_item *ei;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	enum btrfs_inode_field corrupt_field = convert_inode_field(field);
-	u64 bogus;
-	u64 orig;
 	int ret;
 
 	if (corrupt_field == BTRFS_INODE_FIELD_BAD) {
@@ -741,49 +740,49 @@ static int corrupt_inode(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item);
 	switch (corrupt_field) {
 	case BTRFS_INODE_FIELD_ISIZE:
-		orig = btrfs_inode_size(path->nodes[0], ei);
-		bogus = generate_u64(orig);
+		if (bogus == (u64)-1)
+			bogus = generate_u64(btrfs_inode_size(path->nodes[0], ei));
 		btrfs_set_inode_size(path->nodes[0], ei, bogus);
 		break;
 	case BTRFS_INODE_FIELD_NBYTES:
-		orig = btrfs_inode_nbytes(path->nodes[0], ei);
-		bogus = generate_u64(orig);
+		if (bogus == (u64)-1)
+			bogus = generate_u64(btrfs_inode_nbytes(path->nodes[0], ei));
 		btrfs_set_inode_nbytes(path->nodes[0], ei, bogus);
 		break;
 	case BTRFS_INODE_FIELD_NLINK:
-		orig = btrfs_inode_nlink(path->nodes[0], ei);
-		bogus = generate_u32(orig);
-		btrfs_set_inode_nlink(path->nodes[0], ei, bogus);
+		if (bogus == (u64)-1)
+			bogus = generate_u32(btrfs_inode_nlink(path->nodes[0], ei));
+		btrfs_set_inode_nlink(path->nodes[0], ei, (u32)bogus);
 		break;
 	case BTRFS_INODE_FIELD_GENERATION:
-		orig = btrfs_inode_generation(path->nodes[0], ei);
-		bogus = generate_u64(orig);
+		if (bogus == (u64)-1)
+			bogus = generate_u64(btrfs_inode_generation(path->nodes[0], ei));
 		btrfs_set_inode_generation(path->nodes[0], ei, bogus);
 		break;
 	case BTRFS_INODE_FIELD_TRANSID:
-		orig = btrfs_inode_transid(path->nodes[0], ei);
-		bogus = generate_u64(orig);
+		if (bogus == (u64)-1)
+			bogus = generate_u64(btrfs_inode_transid(path->nodes[0], ei));
 		btrfs_set_inode_transid(path->nodes[0], ei, bogus);
 		break;
 	case BTRFS_INODE_FIELD_BLOCK_GROUP:
-		orig = btrfs_inode_block_group(path->nodes[0], ei);
-		bogus = generate_u64(orig);
+		if (bogus == (u64)-1)
+			bogus = generate_u64(btrfs_inode_block_group(path->nodes[0], ei));
 		btrfs_set_inode_block_group(path->nodes[0], ei, bogus);
 		break;
 	case BTRFS_INODE_FIELD_MODE:
-		orig = btrfs_inode_mode(path->nodes[0], ei);
-		bogus = generate_u32(orig);
-		btrfs_set_inode_mode(path->nodes[0], ei, bogus);
+		if (bogus == (u64)-1)
+			bogus = generate_u32(btrfs_inode_mode(path->nodes[0], ei));
+		btrfs_set_inode_mode(path->nodes[0], ei, (u32)bogus);
 		break;
 	case BTRFS_INODE_FIELD_UID:
-		orig = btrfs_inode_uid(path->nodes[0], ei);
-		bogus = generate_u32(orig);
-		btrfs_set_inode_uid(path->nodes[0], ei, bogus);
+		if (bogus == (u64)-1)
+			bogus = generate_u32(btrfs_inode_uid(path->nodes[0], ei));
+		btrfs_set_inode_uid(path->nodes[0], ei, (u32)bogus);
 		break;
 	case BTRFS_INODE_FIELD_GID:
-		orig = btrfs_inode_gid(path->nodes[0], ei);
-		bogus = generate_u32(orig);
-		btrfs_set_inode_gid(path->nodes[0], ei, bogus);
+		if (bogus == (u64)-1)
+			bogus = generate_u32(btrfs_inode_gid(path->nodes[0], ei));
+		btrfs_set_inode_gid(path->nodes[0], ei, (u32)bogus);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1542,7 +1541,7 @@ int main(int argc, char **argv)
 		BUG_ON(IS_ERR(trans));
 		if (file_extent == (u64)-1) {
 			printf("corrupting inode\n");
-			ret = corrupt_inode(trans, root, inode, field);
+			ret = corrupt_inode(trans, root, inode, field, bogus_value);
 		} else {
 			ret = corrupt_file_extent(trans, root, inode,
 						  file_extent, field, bogus_value);
-- 
2.54.0

