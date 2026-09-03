Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236BD3F660F
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418185; cv=none; b=tOm2ltJ6hMH0nTRNMKrnSTGrkpE7dkBiEAKQXEPSdyUvgwMM8hGpJS+HfkqRUVBNMEktxj2KTHpmswnAgFRBPaEOl1nRipIhpGn3wub9GuC+DiaQA+1ESL7szx/yARFWGr9G7IJKnmaKJiNmTPCsUr0fpPlPdzFBVD0ZWziEJXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418185; c=relaxed/simple;
	bh=9C7kKd/yGajsFKnwr+iRblnd8dr4oSJesqYO5JD9eeo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UDrGouBZvfs11wo1fZa1ZhofXBU37teoQmssI/J54b9lbVl6dLygB5FUou7koP3NhKms+Il5TpMbeGDoDU8D0gCGXr8gd+IcM2448cKjm5lpLM4TMK5bCR5ehDkW1ofsXl6ZDWZzE1Vrkj9R37rUurPA5rKcBY7fG1oY6O59lvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g7VezjFr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ByEBxTWC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g7VezjFr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ByEBxTWC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B78261FDA2
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788418176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HNeHPbMcIrxYgr896a1r3VbyMxC6ww/Jaad1eKLJ2KQ=;
	b=g7VezjFrNuwbMoca0iLJf9pZE6vwPQTTkdvTDeQxjZG9Y5w46x1XqGRJfxfsbszhV5lA+d
	bwiL8D/XmFdMk6Kb5JniPwT75PO+WqBThOoaYKdg2NR8EZCa+b96jiomngP2lTKwMQZNwz
	LghsBDvES3vLpc1dt1iVjo2qmQSb4Ys=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788418172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=HNeHPbMcIrxYgr896a1r3VbyMxC6ww/Jaad1eKLJ2KQ=;
	b=ByEBxTWCm6UqXs+K/BRhTGxRyVFF1/Nh+NQ5Jfu3TkKpzzWy3GSBrd33VMvEl54Rl6Ai2G
	NSH8Jon7LiOK46lJ+eCaKMSWBu3EpzRHRS2/5ZAi/Vhe8fBKynqWEmYNno1qF01v00Qx1p
	6JlxHp2zQaKJrpZrevTVJz76cVQvHhc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A924136E6
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XSW5EXsYmWosRAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 06:49:31 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: introduce a new experimental feature, RAID56_VSL
Date: Thu,  3 Sep 2026 16:19:02 +0930
Message-ID: <cover.1788417288.git.wqu@suse.com>
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
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]

The new feature stands for RAID56 Variable Stripe Length, however the
VSL part is not implemented yet, thus the whole feature is still hidden
behind experimental, and there are definitely works left to properly
split the 1st patch.

But for now, this series can pass most fstests cases.
The failing ones are all related to mixed block groups, which can not be
created nor mounted with this new feature.

The roadmap for the full RAID56 VSL implementation is split into two
parts:

- Introduce a new datasize member
  This series.

  An fs with data_size 8K and sectorsize 4K will act like a fs with
  sectorsize 8K.
  Meaning the minimal write size is 8K for data.

  However the checksum is still calculated based sectorsize, meanwhile
  we can still recover each corrupted 4K sector inside a 8K data block.

  The idea and implementation is not that complex, we're just reusing
  the existing bs > ps support to handle it (on 4K page sized systems).

  But the challenge is the details where some part of the code still
  requires sectorsize (checksum related), meanwhile every other location
  goes datasize for data.

- Introduce a new RAID56_VSL chunk type
  It will have the following requirements:

  * Can have up to (datasize / sectorsize) data stripes

  * The number of data stripes are always power of 2
    This is only for every RAID56_VSL chunk, users can still have
    whatever number of devices in the fs.

  * The full stripe length is always datasize

  This allows every data write to be full stripe aligned.
  And for read repair/scrub, we can still locate and recover a single
  sector inside a RAID56 stripe.

  This is less flex than the traditional RAID56, which has no limit on
  the number of data stripes, but has the write-hole problem.
  And will require users to determine the maximum device numbers at mkfs
  time, without any way to change to another datasize.

  But the second part is pretty easy to implement.

As the digest shows, the biggest problem is the first patch, which is
touching over 200 sectorsize users, and is definitely the source of all
bugs I hit and fixed so far.

If anyone has a better way to address the rename, I'm all ears.

Qu Wenruo (2):
  btrfs: split sectorsize into datasize and sectorsize
  btrfs: implement a new incompat feature, raid56_vsl

 fs/btrfs/accessors.h                   |   2 +
 fs/btrfs/bio.c                         |  16 +++-
 fs/btrfs/block-group.c                 |   2 +-
 fs/btrfs/btrfs_inode.h                 |  10 +++
 fs/btrfs/compression.c                 |  12 +--
 fs/btrfs/defrag.c                      |  14 +--
 fs/btrfs/delalloc-space.c              |  22 ++---
 fs/btrfs/direct-io.c                   |   6 +-
 fs/btrfs/disk-io.c                     |  43 +++++++---
 fs/btrfs/extent-io-tree.c              |   2 +-
 fs/btrfs/extent-tree.c                 |   4 +-
 fs/btrfs/extent_io.c                   |  62 +++++++-------
 fs/btrfs/extent_map.c                  |   2 +-
 fs/btrfs/fiemap.c                      |   2 +-
 fs/btrfs/file-item.c                   |  22 +++--
 fs/btrfs/file.c                        |  72 ++++++++--------
 fs/btrfs/fs.h                          |  27 ++++--
 fs/btrfs/inode-item.c                  |   6 +-
 fs/btrfs/inode.c                       | 113 +++++++++++++------------
 fs/btrfs/ioctl.c                       |  12 +--
 fs/btrfs/lzo.c                         |  14 +--
 fs/btrfs/reflink.c                     |  16 ++--
 fs/btrfs/relocation.c                  |  16 ++--
 fs/btrfs/send.c                        |   4 +-
 fs/btrfs/subpage.c                     |  96 +++++++++++++++------
 fs/btrfs/subpage.h                     |   2 +-
 fs/btrfs/super.c                       |   8 +-
 fs/btrfs/sysfs.c                       |   8 +-
 fs/btrfs/tests/btrfs-tests.c           |   6 +-
 fs/btrfs/tests/free-space-tree-tests.c |   2 +-
 fs/btrfs/tree-checker.c                |   2 +-
 fs/btrfs/tree-log.c                    |   6 +-
 fs/btrfs/volumes.c                     |   2 +-
 fs/btrfs/zlib.c                        |   6 +-
 fs/btrfs/zoned.c                       |   4 +-
 fs/btrfs/zstd.c                        |   8 +-
 include/uapi/linux/btrfs.h             |  22 +++++
 include/uapi/linux/btrfs_tree.h        |   3 +-
 38 files changed, 403 insertions(+), 273 deletions(-)

-- 
2.55.0

