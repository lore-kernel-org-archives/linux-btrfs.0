Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DCF20ED
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789105133; cv=none; b=iZS6qTVlUvfAwbIRHB1LO2nimfsMOP0NWf5lbHLwW+AFG0QwW7LV5mp48rsLjzVhVrHmQ47EDwvnCpdLX6I4SYaskctvs/0PSspxgGViKAfOrcc3z73IOnT4sKdGPYMaB9McY2ZI4OsznBqcC0ZkymgvzNHdgHdFDSyL4glPK4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789105133; c=relaxed/simple;
	bh=XttbUjz0CQTUZFpjEMaqs6dUrqBa66maf771PsW7tVw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GAQbPbQlgzl2UolOmByArkoaj6L5zc5zF0ptcya37qveSTyMxygiDI+A3gbrCKhP72mI8ZnKbhGFbw6IwQ2Ie7V9yJmMx/1SFSgdg49K2jhIjWCSo+J2awkA+yOaMIOdhi8GtXEvOkoCNbrSs0HYyyvOFd3EFBHEaHY1Ob6CYb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H/mFdIrO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bFarce6R; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H/mFdIrO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bFarce6R"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EF39221D52
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789105126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=smSgjuw1fZS4XLANvA4LDOFFG2BJdB2+rKQbhOhxY9Q=;
	b=H/mFdIrOtF4vLpd3EIRBeVo9VZG2KLo3GhcdiA8YWRlztP0nMWbtamkhAGhUyK7R+cJFqu
	JgHt7fImc2bWmpiQ13Kd3kw9rlpvwRcxprPLDoDxcvofSe7u7SChR/lSfWfLynLDm3bWXT
	iAgZZm37/nBuuumDjvu2M0TO2H3ebvs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789105121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=smSgjuw1fZS4XLANvA4LDOFFG2BJdB2+rKQbhOhxY9Q=;
	b=bFarce6Rz2nxoxhxTXQlvgHEO9GbHB+FlbW2qTOhwlUpfWiCLuTXIn6DLDAsqb8D+9PdLC
	miIDB1Tn1HMM/bjZv38i9ozGOkxFlWxUF/TkBxmqvel1cw9fBKhFo3c48asyXsEefQJJp5
	O59qo7nGTRbrdo0a3Qun0E7SQxN4BTA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D355C136ED
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HVxzIOCTo2rPWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: introduce a new ioctl to force updating the device name
Date: Fri, 11 Sep 2026 15:08:15 +0930
Message-ID: <cover.1789104905.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

[CHANGELOG]
v2:
- Add a new patch to fix an existing bug in ioctl read/write direction

- Use the correct _IOW for the new ioctl
  Exposed by Sashiko, and the older wrong direction was copied from the
  only exception.

The first patch is to fix a btrfs_iocl_vol_args user which is using the
incorrect IO direction (the direction is based on if the user space is
doing the read or write).

The second patch add a new ioctl, so that we can push the responsibility
to maintain the btrfs device path to the user space, and blame end users
on the weird device path passed in.

Qu Wenruo (2):
  btrfs: fix the wrong direction for BTRFS_IOC_DEVICES_READY
  btrfs: introduce a new ioctl to force updating the device name

 fs/btrfs/super.c           | 16 +++++++++++-----
 fs/btrfs/volumes.c         | 24 +++++++++++++++++-------
 fs/btrfs/volumes.h         |  6 +++++-
 include/uapi/linux/btrfs.h |  4 +++-
 4 files changed, 36 insertions(+), 14 deletions(-)

-- 
2.55.0

