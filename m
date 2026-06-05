Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F744C0406
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650089; cv=none; b=On4ewmCnaTWcv9il/hxW/k5kZZdz4G/F2y0qCzjFnAC9AtHOCcR+2inLMNk2TMrcW8pTHna95t3j0load/Uob02rjQmEgMVCRHtijfysnakczBZ/puvloAguOMNvDw1yz6Vk6c32OokK9NChoo0YoX0oA62YcSUVU09uGWa8BRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650089; c=relaxed/simple;
	bh=rK/7anUTUOCS3LDmsh2zqSr9rqsp8oFqZA5tjDFVuIg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=o2Fj7QGuv2p8NFBesWVM2MNpH+mHsOxXy6bxhlM2/kzcdQCP06RwWfEDGcZrdab6XNTgcWMuBshZ+7DBVO9nNQ3CSeVLupjZsWDLe7QUGnXL5B/iYjAnRIwTE5fRIKVpMvXIdBqKaLRXNXnv1NqDddCylPRlhGG77/A7Iy3+/VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oaspvJjn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oaspvJjn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oaspvJjn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oaspvJjn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2FD3975896
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gIPhD/0Uw7x9ODS+zZj2EGUyCfbM64yrkVbwhJf9Iy4=;
	b=oaspvJjnozMjRnTgPQkpBGcIBiiHR+LdWDqWluoFKnZ9JoeW8AUAuU/jWKGbnFlcKbCn4D
	rMIJT8s1nYSXquWRkUTKo+HxSd0YAaDihJUtyFEozkXwg/rZeQbuarV4lGTKPzamKQ4ZnL
	blA7tBT/gorP/f2RSEZSWjbqTQlH0cQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780650086; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gIPhD/0Uw7x9ODS+zZj2EGUyCfbM64yrkVbwhJf9Iy4=;
	b=oaspvJjnozMjRnTgPQkpBGcIBiiHR+LdWDqWluoFKnZ9JoeW8AUAuU/jWKGbnFlcKbCn4D
	rMIJT8s1nYSXquWRkUTKo+HxSd0YAaDihJUtyFEozkXwg/rZeQbuarV4lGTKPzamKQ4ZnL
	blA7tBT/gorP/f2RSEZSWjbqTQlH0cQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 319FF779A8
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 09:01:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yM9YNGSQImrFDAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 05 Jun 2026 09:01:24 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: minor fixes and cleanups on direct IO path
Date: Fri,  5 Jun 2026 18:31:02 +0930
Message-ID: <cover.1780645090.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

There are several small problems inside the direct IO code:

- btrfs_direct_write() ignores any submitted bytes
  Any error code will have a higher priority than the @written value.

  Fixed in the first patch.

- Possible direct and buffered OE conflicts if falling back to buffered
  If btrfs_dio_iomap_begin() is called and created an OE, but later
  nothing is submitted and needs to fallback to buffered, then the OE
  is only finished but not yet removed.

  The removal of an OE is always delayed, thus there is a window that
  the buffered write can create an OE, causing conflicts.

  Fixed in the second patch.

- Duplicated btrfs_dio_data::submitted
  The iomap_end() callback has @written parameter which provides the
  same value.

  Fixed in the third patch.

- Badly structured btrfs_dio_iomap_end()
  Refactored in the last patch.

Qu Wenruo (4):
  btrfs: return the written number if there is any progress for dio
  btrfs: wait for OE to be fully removed before falling back to buffered
  btrfs: remove btrfs_dio_data::submitted
  btrfs: refactor btrfs_dio_iomap_end()

 fs/btrfs/direct-io.c | 150 ++++++++++++++++++++++++-------------------
 1 file changed, 84 insertions(+), 66 deletions(-)

-- 
2.54.0

