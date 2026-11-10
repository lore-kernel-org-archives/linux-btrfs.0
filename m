Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794291173;
	b=nvzWtPMp6HuOODoqslEf4haACP/KTSBNLAjz9pmxpEpfcNdeM81j4rrz7zPY2I1CpD3/
	 4ZJDdeoBbYklW3bacPQ00wRMs5JXQQ31+FLAO5/Os0wwHjZWnRUDM3lQyk5Yn+bXWm9J8
	 LvlsYtltC6R++412TK7uHq8PYjnSSAU/gTPWrTPb7nCFyaKk6vd41qycCctc3YRoFvaDt
	 +UuhUCdqJjGIcgAK8bK3OoxYaNmntGRqLY49qZJyxzvUqe3KDE7GHD6Z6wcilTOA2B3O2
	 aGPDxVgSlCJBISFJekuUjZvFF1dwXYdPjrVsTtz5lA9BHSkko5a34PLfhSJfgxkaHlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794291173;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=hzPWZJ3ETDJftyG/ZrYAmFE94b5Sr5sNOLpahj9TtUo=;
	b=0JMXuLjrtzdE93aAd3AIROEbifU98jQPqUVhLl3brjsvrkJGEDj/MKXU7WektRNw3QTi
	 XPic1+L3sDJibMtD/mWGnxc1ua4p1B1Yx3hQm+0dB2HAxbyzFt+cdm8MEOw29cWbCtM9C
	 PeTDOS19zuPkgBpT7S9BFVCj6kD/vtLVO7aC5GpkAWBo0KYHnVJz7FZpCLtb2OkKrt4qb
	 LtUEq7rmXH0eXsRc7ejBo01UrlGfzdJlx/pxyzsJJHHTHl8ONCswVYH91g/Wq7IFJNvAR
	 WJF1qLLEOutsv8olDJ4ME1yaf3z5aPcB+EVcdo/GIMCKGrXXWWK4eO3yvdCf1kNXtSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YUocOcPa;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YUocOcPa;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD92606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCD92606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YUocOcPa;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YUocOcPa
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 014021F441
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794291171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hzPWZJ3ETDJftyG/ZrYAmFE94b5Sr5sNOLpahj9TtUo=;
	b=YUocOcPa1fjI3CT4NDvq3+uQOOZnZh1qQulpzpncLDKM4gdvc5I70U6brOGfOfDeVu3lvH
	XaCV2CyzQeZtJGofQbitCRrOn8WK8WnO179izOpNkoj4x5ud3tefDFnQlWQGj1uDVkps5+
	LDVf8B1+yqObItmx5XCbZwT5BLsLCyQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794291171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hzPWZJ3ETDJftyG/ZrYAmFE94b5Sr5sNOLpahj9TtUo=;
	b=YUocOcPa1fjI3CT4NDvq3+uQOOZnZh1qQulpzpncLDKM4gdvc5I70U6brOGfOfDeVu3lvH
	XaCV2CyzQeZtJGofQbitCRrOn8WK8WnO179izOpNkoj4x5ud3tefDFnQlWQGj1uDVkps5+
	LDVf8B1+yqObItmx5XCbZwT5BLsLCyQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE3E513479
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id no3bCeG18mreJQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 06:12:49 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/4] btrfs: prepare and move async csum generation out of experimental feautres
Date: Tue, 10 Nov 2026 16:42:23 +1030
Message-ID: <cover.1794290876.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

[CHANGELOG]
v2:
- Introduce a patch to fix a potential data loss with async direct
  writes
  This is an existing bug, not only affecting the async data csum
  generation. Introduce a dedicated fix for it.

- Introduce a patch to fixx an ASSERT() false alert race
  Again an existing bug.

Sashiko exposed several problems related to previous default async csum
generation, one fix related to encoded writes is already merged.

The remaining problems are:

- Possible data loss due to fast fsync with async direct writes
  Fixed by the first patch, not only affecting async csum generation.
  Although async csum generation will make it more obvious.

- A possible ASSERT() race which can trigger false alert
  Fixed by the second patch, by moving the ASSERT() out of the workqueue
  workload.

- Potential workqueue flush problems related to endio_workers
  Fixed by the 3rd patch, also as a preparation for the incoming default
  async data csum generation.

Then we can finally enable async data csum generation by default to
improve the data write performance, and completely get rid of the old
csum offloading behavior.

Qu Wenruo (4):
  btrfs: do not allow fast fsync if there is any async dio write
  btrfs: fix an ASSERT() race with async csum generation
  btrfs: make btrfs_fs_info::workers to be a regular workqueue
  btrfs: move async data csum generation out of experimental features

 fs/btrfs/Kconfig     |   2 -
 fs/btrfs/bio.c       | 139 +------------------------------------------
 fs/btrfs/direct-io.c |  11 ++++
 fs/btrfs/disk-io.c   |  47 ++++++---------
 fs/btrfs/file-item.c |  15 ++---
 fs/btrfs/file-item.h |   2 +-
 fs/btrfs/fs.h        |  17 +-----
 fs/btrfs/super.c     |   2 +-
 8 files changed, 43 insertions(+), 192 deletions(-)

-- 
2.56.0

