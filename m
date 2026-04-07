Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826433A3E63
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554475; cv=none; b=hs45Qd6320dS0Fi3WoJ2e4K5mOE5gMHYYD061IsdM3kyR4DyxQ3unx/5G1bpvXLUWhNNxGh33589FXeUIS2+RkVDLGayGlM5IWjQpeIi4ho1eCxJHc/iZfVeO5MtkpCPo7jn+L/jR03ErbbW/yQHZ8QemdYvMyvqyRUFeSCKu9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554475; c=relaxed/simple;
	bh=6tYZb9IELWjlxPcjyl4YQhoA/TMmZ3y9FA6voLO6pr8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nShynCCCRBkbONhZjbXUi0KvDhzFBpdHdrsQvEwmCkUPGvwXglqhGePcXbDfpgwcZaJHSFOroncz0n6eEzm4r0Dt8yT3cxRuOxP+n6iwf/kVBj1dONTSy3wxprR5drbefHC7777x0XtUDaz8XMmjvnxyzdnFby1KFZAqdwDCSn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LX5AbPZt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LX5AbPZt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LX5AbPZt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LX5AbPZt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9BB04E3A9
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmZqxTzpOZdjHc2UqHeL7+H+BrSouxD1Ap+1XgA4XPw=;
	b=LX5AbPZtEUiEEsgdrc6/Bh7FjeIhMSTEV1OnJ3CFDArI+slZMwL8gkfuOFhpsdeRYZJccq
	HcRnYkHtqNcJgNYHiRUArPXKFMUUHAaTkfcCamPERVAohQ44Cff7bHp8+dSnfrevLzGCdw
	u3jcMqGwKbp4qFdKButoXQW/bLVBWFg=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=LX5AbPZt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmZqxTzpOZdjHc2UqHeL7+H+BrSouxD1Ap+1XgA4XPw=;
	b=LX5AbPZtEUiEEsgdrc6/Bh7FjeIhMSTEV1OnJ3CFDArI+slZMwL8gkfuOFhpsdeRYZJccq
	HcRnYkHtqNcJgNYHiRUArPXKFMUUHAaTkfcCamPERVAohQ44Cff7bHp8+dSnfrevLzGCdw
	u3jcMqGwKbp4qFdKButoXQW/bLVBWFg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8B1A4A0B0
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8OKLGZ/P1GkOYAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 09:34:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs: remove the dev stats item when removing a device
Date: Tue,  7 Apr 2026 19:03:59 +0930
Message-ID: <e10aca921724a17c3875de92d633299107c854b3.1775553952.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775553952.git.wqu@suse.com>
References: <cover.1775553952.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: B9BB04E3A9
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[MINOR BUG]
The following script will cause DEV_STATS item to be left after the
corresponding device is removed:

 # mkfs.btrfs -f $dev1
 # mount $dev1 $mnt
 # btrfs dev add $dev2 $mnt
 # umount $mnt

 ## Without real errors, only at mount time btrfs will update
 ## dev->dev_stats_ccnt, thus we need a mount cycle to create the
 ## DEV_STATS item for the new device.

 # mount $dev1 $mnt
 # touch $mnt/foobar
 # sync
 # btrfs dev remove $dev2 $mnt
 # umount $mnt

This will result the DEV_STATS item for devid 2 still left in device
tree:

 device tree key (DEV_TREE ROOT_ITEM 0)
 leaf 31064064 items 7 free space 15788 generation 18 owner DEV_TREE
 leaf 31064064 flags 0x1(WRITTEN) backref revision 1
 fs uuid 4bd853ed-f6ef-45fd-bbf1-1c3a2d9987cb
 chunk uuid b496eab1-ec23-46b5-81c1-2f1b3503ca07
	item 0 key (DEV_STATS PERSISTENT_ITEM 1) itemoff 16243 itemsize 40
		persistent item objectid DEV_STATS offset 1
		device stats
		write_errs 0 read_errs 0 flush_errs 0 corruption_errs 0 generation 0
	item 1 key (DEV_STATS PERSISTENT_ITEM 2) itemoff 16203 itemsize 40
		persistent item objectid DEV_STATS offset 2
		device stats
		write_errs 0 read_errs 0 flush_errs 0 corruption_errs 0 generation 0

This is not a huge problem, but if the existing DEV_STATS contains
errors, and a new device is added into the fs taking the old devid, then
after a mount cycle, the new device will suddenly inherit old errors which can
give a false alerts.

[CAUSE]
Btrfs never has the ability to delete DEV_STATS items.

It either create a new one through update_dev_stat_item(), or read an
existing one through btrfs_device_init_dev_stats().

However update_dev_stat_item() is only called lazily, if a new device is
created and no new update to dev stats, then it will skip the update of
the on-disk item.

So if the old DEV_STATS item exists and a new device is added, and no
errors during the remaining operations, the old DEV_STATS will not be
updated.

Then at the next mount cycle, btrfs_device_init_dev_stats() is called at
mount time, which will read out the old records, causing false alerts to
the newly added device.

[FIX]
Manually remove the DEV_STATS item during btrfs_rm_device().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/volumes.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f709e2de11f4..5e47157fa86d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2397,6 +2397,12 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info,
 		return ret;
 	}
 
+	ret = btrfs_remove_dev_stat_item(trans, device->devid);
+	if (unlikely(ret)) {
+		btrfs_abort_transaction(trans, ret);
+		btrfs_end_transaction(trans);
+		return ret;
+	}
 	clear_bit(BTRFS_DEV_STATE_IN_FS_METADATA, &device->dev_state);
 	btrfs_scrub_cancel_dev(device);
 
-- 
2.53.0

