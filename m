Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795576535;
	b=4EcxJexXlGMVidpl/+lbaJ5rFR/9hzqgzm+Nb9w2Zex55DOjbAP2c7fc61gDgQqIBnOz
	 3kcLSdBSl6pvtjedg7vki0lh7d/vhYIAEiu37SWRT0+AlbGNa3cWZOibEBZljOhRIVpuB
	 CzG1Bu9HB3zOh2mZphHtgUbkn7D57uPQ4TyBQmVTj2c5PzR2Q5x/7MSr5/3qxzK4iLcP+
	 ptNJrrQ18gOqZvU2DpDpkjcC/GB/IzfxwodlwJme7YMEKI8mFpjmfiyiK4vO/RUrZMENj
	 uhiIJMmn11wzNemJ9bMVdDuo35SHbitBrt2xTDYdNg3MQVLqzlOFHE/ReopglC5k+6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795576535;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=aX44jOjNax2NvPZreDY/BQxIDPTzrADmm5s9Hy9ZiDY=;
	b=hNuSGx+E6pB15KhXZd2xVUZ4dYgILugT023qUgZp/09LLNFT1uFYkNx/LsFtD5TzlpMZ
	 lvC4Fl+Gv+gmWoziy4h2p1LKhhRc1/L6ah6fI5dJLSWcfk11mCOMRz4gCSaSB5KASjB7d
	 zmHq67SoStTbH6O+At0GpyAzXMY46yJhzUbr+grxj2iPX426NEa6n4p1StkBPQCLUtk/Z
	 DxGCuGBpYejWIKnVxDLKjWG8NnxbOS80Ouq/woyt0k3404GFR1gV3Z3280sUISNYBPVTY
	 DXqcy6GeCroB2oIA52VDY3SEpIVwAJv4DB9xwAj3PQKtTF1x2V+akuQLX99Ymwpgtfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IbnvYtle;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IbnvYtle;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C50D606A31E
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C50D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IbnvYtle;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=IbnvYtle
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9DD052231B
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795576532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aX44jOjNax2NvPZreDY/BQxIDPTzrADmm5s9Hy9ZiDY=;
	b=IbnvYtle0Q7cD571hYvQWIdOsUzxeE55C/pf7hw4zVL1aSllMW6Tux7MQsOvHbJFEK7VaH
	+Z1ASiAgwGTt9EnjSloGYMD5hUMmE54cn28uMIasG2HX5nBTqksHYgbWDkZ9BbKK1Sz/Ol
	MeNT9rw8uWhxRoTAoC5ti9SbWC8h/KQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=IbnvYtle
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795576532; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=aX44jOjNax2NvPZreDY/BQxIDPTzrADmm5s9Hy9ZiDY=;
	b=IbnvYtle0Q7cD571hYvQWIdOsUzxeE55C/pf7hw4zVL1aSllMW6Tux7MQsOvHbJFEK7VaH
	+Z1ASiAgwGTt9EnjSloGYMD5hUMmE54cn28uMIasG2HX5nBTqksHYgbWDkZ9BbKK1Sz/Ol
	MeNT9rw8uWhxRoTAoC5ti9SbWC8h/KQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 709E11339F
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b3N0L9JSBmvBMgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2026 03:15:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: minor fixes for handle_direct_tree_backref()
Date: Wed, 25 Nov 2026 13:45:10 +1030
Message-ID: <cover.1795576387.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 9DD052231B

The first one is a tree-checker enhancement to catch a tree block whose
level is already maxed out, but still has a parent that is not itself.
This should help us to detect such rare corruption early.

The second is a similar hardening at runtime, for
handle_direct_tree_backref(), which is also reported by Sashiko.

Qu Wenruo (2):
  btrfs: tree-checker: reject parent backref that goes beyond MAX_LEVEL
  btrfs: backref: reject direct parent if the current level is maxed out

 fs/btrfs/backref.c      | 11 +++++++++++
 fs/btrfs/tree-checker.c | 24 +++++++++++++++++++++---
 2 files changed, 32 insertions(+), 3 deletions(-)

-- 
2.56.1

