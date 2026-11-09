Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794261851;
	b=tyBV+DkkDx3RWquabVLy4I6yZAmewnNm4QGSdtRKkRV0N/at1uKEgLVMbiISmsHjBiih
	 E+DkKYzWR/PBFpY6JY0RjGjtdzwyXKOsuCDtHRMrcZ87tgTWytuzntjTVKsp5QSgJ8Tsf
	 jfHJ/+I9yYdJzwfWIctQsfA7VvYcSQYIrQbMkJUMeYsbwpun958aYSHgASYIL8gVVjw4l
	 DafLBX9gSY0YRQa2zYAhnnSWfmNRFpFXrbWPbI9xvDhbl8tIf3ynoO+y+yy1GCCb3myYW
	 3gSEu4L564BF168wq3WaK6Zd9NO4qsg6sX4KbDiXKfQH2PIe9NK9XjrlGX0NoasXzfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794261851;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=uZp+eg1r7mroZ09bdZR6b0JCD60K/Ct4LbzWuQn3wrw=;
	b=aanokD23/Og3Sfeotdu9LIoPg6nXRRnlAzvjzxedgZYEelExqglRrk939hZKIF1ziL0E
	 ghjuwIJ8as/vD5dUoDO1IahDTFv1lBjZomj1XftcE5X7/0H0jXh01fmeyWBFknYrHRx/s
	 9R28PbMTgjQFpvzPJmXwrTDVFqXXaY6egLSWl2Px0X8JMiNYPJhFK7rs1prIBIrx9zmhV
	 UKtJdsPaTGp6aYI+zVKrmCG+hrkBZtyBQ2ZwLIGnGhQ4ToVzorsiZtZwfaT5CUUcSF06Z
	 wacibivJS/RtA6J94EnFEtqEXN/oNdqS7+3wwz52WTbeIP2jNDrix+8jpyxPAnhE+Cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="kH/nDZvG";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="kH/nDZvG";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9400E606A31C
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9400E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kH/nDZvG;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=kH/nDZvG
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4DC731F44E
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794261848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uZp+eg1r7mroZ09bdZR6b0JCD60K/Ct4LbzWuQn3wrw=;
	b=kH/nDZvGz1VIctkh398Hm4579bO/DpAFZ/ddkYImoAG9b15Dk0HW9PKfwvwpA8HTSSXXs9
	Bc21A0//IBr0QhIuntoqxdfYeopkP3y/aeM991QNNyjh5PCLYdUYjKkKYAYTEXKifI0Cm/
	5RSxOc7sMiAn2XUe9I4klTERaR6+t8c=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="kH/nDZvG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794261848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uZp+eg1r7mroZ09bdZR6b0JCD60K/Ct4LbzWuQn3wrw=;
	b=kH/nDZvGz1VIctkh398Hm4579bO/DpAFZ/ddkYImoAG9b15Dk0HW9PKfwvwpA8HTSSXXs9
	Bc21A0//IBr0QhIuntoqxdfYeopkP3y/aeM991QNNyjh5PCLYdUYjKkKYAYTEXKifI0Cm/
	5RSxOc7sMiAn2XUe9I4klTERaR6+t8c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 024AD13319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 22:04:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3OosElZD8moUPAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 22:04:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: prepare and move async csum generation out of experimental feautres
Date: Tue, 10 Nov 2026 08:33:38 +1030
Message-ID: <cover.1794261158.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 4DC731F44E

Sashiko exposed several problems related to previous default async csum
generation, one fix related to encoded writes is already merged.

The remaining problem is related to the endio_workers reuse, which can
lead to problems as there are two different workloads in one workqueue,
and one workload (btrfs_bio_csum()) can even queue a new work into the
same workqueue.

The remaining problem is fixed by the first patch, by changing
btrfs_fs_info::workers into a regular workqueue, and let the
experimental csum generation to reuse it.

Then we can finally enable async data csum generation by default to
improve the data write performance, and completely get rid of the old
csum offloading behavior.

Qu Wenruo (2):
  btrfs: make btrfs_fs_info::workers to be a regular workqueue
  btrfs: move async data csum generation out of experimental features

 fs/btrfs/Kconfig     |   2 -
 fs/btrfs/bio.c       | 139 +------------------------------------------
 fs/btrfs/disk-io.c   |  47 ++++++---------
 fs/btrfs/file-item.c |  12 ++--
 fs/btrfs/file-item.h |   2 +-
 fs/btrfs/fs.h        |  17 +-----
 fs/btrfs/super.c     |   2 +-
 7 files changed, 30 insertions(+), 191 deletions(-)

-- 
2.56.0

