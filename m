Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794461223;
	b=zQewrZvrLezWqOe02jLjuMr/2P93tJ8rZv3A5dt/WIv5n2nYIeCxbl+dCrR+rzOLHKK+
	 EglaQASFasjI2/kA2quRVh96WtxknsXKF3w2Kmxaa3XQsjwIEBe1Q9YKGONgvQPSSRSZH
	 gNholMn0VTPFYFP3Thbgv57RNu+ayOovwNKePz3W+bjaxr/mbZaG/jOQtCMTat8AR/Rxs
	 GG2Lbf2h4eYBStfj93s7dyeXWZGvdDaJ31hIU90Zq3wV+ai0UpcJ9SKqizpM8sAbo52V8
	 aBkOsh4pe4aHBnT/GoearEeeHgtQKRvnPQFvJVrfv4xq0bXO9fFMfwctBpo/Yhmg8yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794461223;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=s+MShrtrErGoKaeHvC/IuYopW2sb8Tl8pmrjpffJIPo=;
	b=UNcDVTlpCgnqmyzkY4/4e+DqjLHGBe1q6sni60n0RaSR436NA1AMQOvbMZ358FuLl20F
	 /MgxkA/FZHmOOXXP3iBuACllNGUPsado26vJv3xoz6BC/+Kuws9ftuOricwLRidlDWUaC
	 4/+P0AqyJGc9Ze6I3aEWI0EzVTjFYpDnrOi4g2yJce5OBYzawWQOahjZhvkJCoM6NQ9C0
	 TsbsLdSBuerWmGIKDZwRLMSp3F7lTp9QvwPAxaZs2TV2riiAOhAQ7KiyjZ3gE5RCKi+X9
	 WV0Oi/pp/qJrgBcAGwK5AY9Oj8wWP/lRJclMN8uW03UhWZPqIjikFJ3fHaeCKiT8B8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="YD1n4t/z";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="YD1n4t/z";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04AD606A89C
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F04AD606A89C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YD1n4t/z;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YD1n4t/z
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4AA8D1F388
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794461221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+MShrtrErGoKaeHvC/IuYopW2sb8Tl8pmrjpffJIPo=;
	b=YD1n4t/z7jbGhAbKynS9DPwCnCVemX+hq3KeX0cQE1hYMSGdIdzE2T2j4Nhoj7y716XxSi
	AXni+yBPy1FnX2HQhcbEe8b5IqAsCgQSdNkgBJVSLJ9DhLHX/1/1fPB9No8lTy0jXkCxcw
	icyDhCrbjxS2qkOoSgmsId5jznmxLgw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794461221; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+MShrtrErGoKaeHvC/IuYopW2sb8Tl8pmrjpffJIPo=;
	b=YD1n4t/z7jbGhAbKynS9DPwCnCVemX+hq3KeX0cQE1hYMSGdIdzE2T2j4Nhoj7y716XxSi
	AXni+yBPy1FnX2HQhcbEe8b5IqAsCgQSdNkgBJVSLJ9DhLHX/1/1fPB9No8lTy0jXkCxcw
	icyDhCrbjxS2qkOoSgmsId5jznmxLgw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CA68134A0
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id buNLCCBO9WrVDwAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Nov 2026 05:26:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix double free of anon_dev in btrfs_get_root_ref() on -EEXIST
Date: Thu, 12 Nov 2026 15:56:34 +1030
Message-ID: <de8e0a4389d2eb4b2c60717e2b3655247a3234dc.1794461116.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794461116.git.wqu@suse.com>
References: <cover.1794461116.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

[BUG]
If btrfs_get_root_ref() is given a preallocated anon_dev and loses the
race to insert the new root, the preallocated ID is freed twice.

[CAUSE]
The offending call trace looks like the following:

 btrfs_get_root_ref(*anon_dev = X)
 |- btrfs_init_fs_root()
 |  \- root->anon_dev = X
 |- btrfs_insert_fs_root() returns -EEXIST
 |- btrfs_put_root(root)
 |  \- free_anon_bdev(root->anon_dev)
 |     ^^^ ID X is freed here.
 |
 \- again:
    \- btrfs_lookup_fs_root() finds the existing root
       \- free_anon_bdev(*anon_dev)
          ^^^ ID X is freed again.

[FIX]
Clear root->anon_dev before putting the unpublished root, the same as
the fail: label does, so the ID stays owned by the caller.

The next retry either got the existing root and free the anon_dev, or
win the race (the root is removed by someone else) and reuse the
preallocated anon_dev.

Assisted-by: LLM (exposing the bug)
Fixes: 2dfb1e43f57d ("btrfs: preallocate anon block device at first phase of snapshot creation")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 50888d1e3e1e..7775fc768f7e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1387,6 +1387,12 @@ static struct btrfs_root *btrfs_get_root_ref(struct btrfs_fs_info *fs_info,
 	ret = btrfs_insert_fs_root(fs_info, root);
 	if (ret) {
 		if (ret == -EEXIST) {
+			/*
+			 * The preallocated anon_dev is still owned by the
+			 * caller, don't let btrfs_put_root() free it.
+			 */
+			if (anon_dev && *anon_dev)
+				root->anon_dev = 0;
 			btrfs_put_root(root);
 			goto again;
 		}
-- 
2.56.0

