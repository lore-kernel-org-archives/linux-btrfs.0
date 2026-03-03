Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CC6385527
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2026 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772525744; cv=none; b=YnI+IZlGul30h2NQQjnT/C6Psxczo/gE4vO3/XB434cBlqyFbk8PSnV1p+FuhRDt5aVRDUlb/PcsqUOQP3fV6jd3EfRpDpY0f2vHPg6jiw7jpCKeg2ZP+7wJuUY+E9O9Rv8+LwRP6vowquyTdJDsER4XJJIAmMV3bSZF+lJ+P5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772525744; c=relaxed/simple;
	bh=X6VpWpAjMZwjR+CwZ09/D5tuTMpyQ0p9ijJiUDa8kjw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nOMEllbHWg9SHgGS5pB0lGyXn05kvfbIZQTKLvKhAt9y8Xo336bcZ3Z9GKq9BT/Blg8qSJ+gmg0XgD+rPPITym9GPDkmwwr7Djk7szcoZn+gchL4zFVSNsunXck7vaRhpb6CWPaRHM7iDz+C5yqihXAiQzhx9dlxwvYoLQngdME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XgKYuRD5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XgKYuRD5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XgKYuRD5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XgKYuRD5"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0528E5BDE8
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2026 08:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772525734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=x1iFIFttd/iYWvyOk3kHA0ezAKTQtl2RZaXBLxhy4Uk=;
	b=XgKYuRD5RdYv5EbMTy9u4VcfnxlL121jJKb3XTz/5oSn4ny3n9mMUvkn4iv4LjXo0ALfDH
	5pfbtx63s/kDApnmLUnpjbfVegUSkIxUi8iLJY4n5tWWsQk1VoTBp7Q+tWiVAKsmpQA6H8
	9AqS8iG4aAAyLiSWHc9BtNXV03Q4zPA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772525734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=x1iFIFttd/iYWvyOk3kHA0ezAKTQtl2RZaXBLxhy4Uk=;
	b=XgKYuRD5RdYv5EbMTy9u4VcfnxlL121jJKb3XTz/5oSn4ny3n9mMUvkn4iv4LjXo0ALfDH
	5pfbtx63s/kDApnmLUnpjbfVegUSkIxUi8iLJY4n5tWWsQk1VoTBp7Q+tWiVAKsmpQA6H8
	9AqS8iG4aAAyLiSWHc9BtNXV03Q4zPA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 363D03EA69
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Mar 2026 08:15:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pmMmOqSYpmmHeQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 03 Mar 2026 08:15:32 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: trivial cleanups in end_bbio_data_write()
Date: Tue,  3 Mar 2026 18:45:08 +1030
Message-ID: <cover.1772525669.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Please check the changelog of each patch. All of them are pretty
trivial.

Qu Wenruo (2):
  btrfs: remove the alignment check in end_bbio_data_write()
  btrfs: move the mapping_set_error() out of the loop in
    end_bbio_data_write()

 fs/btrfs/extent_io.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

-- 
2.53.0

