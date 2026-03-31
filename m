Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08C427F754
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 23:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774998203; cv=none; b=PMlxgUfULoZtuayDNiuTl1W6K5XC7dL4q+IFcy+ol/9NJVEpYPoQOfqLqbfrvDAHB8YzVVx8CV46OZ2j40mag1JhhSwUT0Y3o/Z4o3GtzjbNpRUntUUeMl5q3jVq4rXk/85hWT8ENddJ5CG/wQYucg/Rcg3gAp71w1T6zDaq+sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774998203; c=relaxed/simple;
	bh=PMjz66dHUlHWR3V2fyquEixVptiKGxvOm0Qikn/bxAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ihup07s3dCPDQyUHOMvPuibS9nSLP5h/VjNl5/CDmcvsbJv3A2QLKQ+Kaw84i4HF8bgtKJv7AeJezXN1hJ57hah23waE0A7GMkcjU7w4M1/MNR6gUViXoCW6B9nCqymWpsLp0mzH/omcDVFKTut/Vx87++2PESs1+c9SeaUAlqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qAJcrY7o; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qAJcrY7o; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qAJcrY7o";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qAJcrY7o"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 22DF85BCD2;
	Tue, 31 Mar 2026 23:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774998200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tvdrGyxhuw8DBVRLt3K+X5A5s/h4lgD3q7gfUGw2dmM=;
	b=qAJcrY7oB8mld7z547qfHzaLynkf0Y4T/Umc2SkQgDXtk1qzGQJHbvurD8N0ck1UPnxPK7
	0Moobk6Az88oNhGzMbHn68WXY6mn1sDjfbks048Y72lrWF2P++JhITK1ES88nKJbP8FcBC
	35YEaIe8PI9V4R4eNMefxy0eSMte35c=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774998200; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tvdrGyxhuw8DBVRLt3K+X5A5s/h4lgD3q7gfUGw2dmM=;
	b=qAJcrY7oB8mld7z547qfHzaLynkf0Y4T/Umc2SkQgDXtk1qzGQJHbvurD8N0ck1UPnxPK7
	0Moobk6Az88oNhGzMbHn68WXY6mn1sDjfbks048Y72lrWF2P++JhITK1ES88nKJbP8FcBC
	35YEaIe8PI9V4R4eNMefxy0eSMte35c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F5D64A0A2;
	Tue, 31 Mar 2026 23:03:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rOdqNLZSzGkyJgAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 31 Mar 2026 23:03:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: =?UTF-8?q?Jaron=20Vi=C3=ABtor?= <jaron@vietors.com>
Subject: [PATCH] btrfs: do not reject a valid running dev-replace
Date: Wed,  1 Apr 2026 09:32:57 +1030
Message-ID: <03c15f51597e61c4d669db55f5c627b3a3af9b20.1774998167.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

[BUG]
There is a bug report that a btrfs with running dev-replace got rejected
with the following messages:

 BTRFS error (device sdk1): devid 0 path /dev/sdk1 is registered but not found in chunk tree
 BTRFS error (device sdk1): remove the above devices or use 'btrfs device scan --forget <dev>' to unregister them before mount
 BTRFS error (device sdk1): open_ctree failed: -117

[CAUSE]
The tree and super block dumps show the fs is completely sane, except
one thing, there is no dev item for devid 0 in chunk tree.

However this is not a bug, as we do not insert dev item for devid 0 in
the first place.
Since the devid 0 is only there temporarily we do not really need to
insert a dev item for it and then later remove it again.

It is the commit 34308187395f ("btrfs: add extra device item checks at
mount") adding a overly strict check that triggers a false alert and
rejected the valid filesystem.

[FIX]
Add a special handling for devid 0, and doesn't require devid 0 to
have a device item in chunk tree.

Reported-by: Jaron Viëtor <jaron@vietors.com>
Link: https://lore.kernel.org/linux-btrfs/CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com/
Fixes: 34308187395f ("btrfs: add extra device item checks at mount")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 33fa73668534..d8f2722311c8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8667,7 +8667,12 @@ bool btrfs_verify_dev_items(const struct btrfs_fs_info *fs_info)
 
 	mutex_lock(&uuid_mutex);
 	list_for_each_entry(dev, &fs_info->fs_devices->devices, dev_list) {
-		if (!test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
+		/*
+		 * Replace target dev item (devid 0) is not inserted into chunk tree.
+		 * So skip the DEV_STATE_ITEM check.
+		 */
+		if (dev->devid != BTRFS_DEV_REPLACE_DEVID &&
+		    !test_bit(BTRFS_DEV_STATE_ITEM_FOUND, &dev->dev_state)) {
 			btrfs_err(fs_info,
 			"devid %llu path %s is registered but not found in chunk tree",
 				  dev->devid, btrfs_dev_name(dev));
-- 
2.53.0

