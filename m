Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1E31F192E
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775554464; cv=none; b=vEO9gp1Vb8NBxP1kNU3NlFfEJp5ek3Wb79NHQhlm2as8dmcdeHbj53bJTreSw04Xo5Ci4AE34kx01w+FqbzRh8VvssPB7RNan2v1Ueii9/xbIKRy5v4frNOLwR2SaWjkDdpojdLNTOY6w0MEtkIGIkYQ05iu2sq/kUjnPsUh0LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775554464; c=relaxed/simple;
	bh=12ceZagquTzmVRgqTbhq3JmAIs8kyLAqhUla8f4C7O8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=RTkKQFi7hAEj2GwRujZmJ3gIYUtFFV4QqTYJqlurwtJIiNJGM0bJ5lnPSn2JJY/z8VolE121S+dFzxrtpV19KLD88I7dJCyPJlnvutD/ZMII2vqHY23TRzbDFmotfJ+4oi+i4hLbT8dYw1ft7KP//iltqpgnBEeZjROkDjE++As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WP0YZ2DD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WP0YZ2DD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WP0YZ2DD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WP0YZ2DD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 748014E3A9
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nBwQTdGUC3sX3PVoo4HPVJ88jw1IjXIB3jcQwmwkonU=;
	b=WP0YZ2DDJ55NK1mYxHQE6p8ncuL3Ci9J0yuNr42XoZq39oVQChBl+q3xbI2GstMYqJNGZ2
	wkS8+TpI/GlN94TVlJQOsPteNKMG9kh2KuI2LKYcC8bjoOf8yQKYRB3+CJ/vHeddQ2Pht0
	bJVGiQRQW+0aqmd54j/uh/3X5jizPH8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=WP0YZ2DD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775554461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nBwQTdGUC3sX3PVoo4HPVJ88jw1IjXIB3jcQwmwkonU=;
	b=WP0YZ2DDJ55NK1mYxHQE6p8ncuL3Ci9J0yuNr42XoZq39oVQChBl+q3xbI2GstMYqJNGZ2
	wkS8+TpI/GlN94TVlJQOsPteNKMG9kh2KuI2LKYcC8bjoOf8yQKYRB3+CJ/vHeddQ2Pht0
	bJVGiQRQW+0aqmd54j/uh/3X5jizPH8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 749F64A0B0
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 09:34:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 11H+CJzP1GkOYAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2026 09:34:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: DEV_STATS item related minor fixes
Date: Tue,  7 Apr 2026 19:03:57 +0930
Message-ID: <cover.1775553952.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
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
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 748014E3A9
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[BACKGROUND]
DEV_STATS (objectid, not type) items are storing the error counts for
each device. It's updated every time an error is hit, including
the following types:

- READ errors
- WRITE errors
- FLUSH errors
  Above alls are all errors directly returned from the device.

- CORRUPTION errors
  Aka, checksum mismatch.

- GENERATION errors
  Metadata generation mismatch.

[MINOR BUGS]
Recently when debugging an error reported about rejected dev-replace,
the device tree dump includes a DEV_STATS item for devid 0.

I'm wondering if that DEV_STATS item will ever be deleted, but
unfortunately it will never be deleted.

Normally it's not a big deal, as the DEV_STATS are normally all zeros.

But if it's not, and a new dev-replace is started and interrupted, at
the next mount the replace target device will suddenly inherit all the
error records, giving end users false alerts about a completely good
device.

[FIX]
The first 2 are manually removing the DEV_STATS items when dev-replace
and dev-removal finishes.

The 3rd patch is a more generic fix by forcing btrfs to update/create
DEV_STATS item after a new device is added.
This means for patched kernels, even there is some old DEV_STATS left,
the kernel will never re-use them during device add or dev-replace.

The last one is to reduce unnecessary DEV_STATS updates.

Qu Wenruo (4):
  btrfs: remove the dev stats item for replace target device
  btrfs: remove the dev stats item when removing a device
  btrfs: always update/create the dev stats item when adding a new
    device
  btrfs: avoid unnecessary dev stats updates

 fs/btrfs/dev-replace.c | 11 +++++++++-
 fs/btrfs/volumes.c     | 48 ++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/volumes.h     |  1 +
 3 files changed, 57 insertions(+), 3 deletions(-)

-- 
2.53.0

