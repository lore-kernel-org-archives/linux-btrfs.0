Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B6718FC97
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2026 05:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790831819; cv=none; b=GIl1u9cxIaJYrxfdUx948CAaf6qBM4bP6WwRq0SjiQJpQCnj1Y9Ir8oTDrfD1R8oUszQf02XRe0jM5lksBVf/EI7BviWTKSETBrhajbxjpmio7EGeCdcbVHR2YP/e3s+bsqUyGvsIEzen63pHXauP6V9WoukcgssaXgJhkYY/4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790831819; c=relaxed/simple;
	bh=G+gxH7NOMa+T5jp2bmKtGT4qQjA6czUV4AZe91Apa1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4PTvHc1N/amHu3ENmEJsxaytqN1VzoXocDC4jtRRNa74dIDoeVf/dsVyfZokDvZs37oueTHXkFzSUspldVdsydE6vZUeqSA8kPzSFMvQ5EY2uQOBDNxRjIV5GulKWPhSJzBYWrtgBIzBf0YpRFRJgE81HS8WH7bxupmIPCkwcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ujQj8/R5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ekWJLqEZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ujQj8/R5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ekWJLqEZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1AEF621E5F;
	Thu,  1 Oct 2026 05:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2DbJWWVF7HFaj3gOxvztx1HWG9bs6B3oM+xpyn41RU=;
	b=ujQj8/R5C5nKJ1zo/TXKXdZOU7ybTUHnxUpAqsEDQ0LFWPQTzXeSfN6kd3PwIXJR49ZhZd
	jDd7zT7rkzREyrOrck6gMS+5vgmdmvkmYEpChbihORaTskW3iCAXP+aeSgbwj5wpuFGFuc
	mqBOvpOhOMJIcCgZXwZc18RKSK6a0Do=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790831807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J2DbJWWVF7HFaj3gOxvztx1HWG9bs6B3oM+xpyn41RU=;
	b=ekWJLqEZeNt4XtEbyEChWBgn3qztfB+4Vnlwl8cJs6bOPy4wc/rhD/BrMFp96w3nSCppDC
	x4xdwyZTayOlyNUs4RzxDYo2RQrmXgeZYdsP5FjHHL+NcSDzlRTtIAN4Ac5KVqzfh3DYss
	NEuT2ThwaQd7PHIIUEUUnK/zKw74YS0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B8BB136A5;
	Thu,  1 Oct 2026 05:16:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aRXOE7vsvWrVGwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Thu, 01 Oct 2026 05:16:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: c.f.a@posteo.de
Subject: [PATCH 1/3] btrfs: qgroup: do not treat "ret > 0" as error when deleting a qgroup
Date: Thu,  1 Oct 2026 14:46:15 +0930
Message-ID: <cd8565308fae8e7a57aabb17029b40045aea6872.1790831600.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790831600.git.wqu@suse.com>
References: <cover.1790831600.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

[BUG]
There is a bug report that when removing a child qgroup, if removing the
qgroup requires a rescan, it will delete the on-disk relation and qgroup
items but not the in-memory qgroup rb entry.

This makes all later qgroup rescan to fail.

[CAUSE]
The call chain looks like the following:

 btrfs_remove_qgroup()
 |- __del_qgroup_relation()
 |  |- quick_update_accounting()
 |     Which returns 1, showing this operation will require
 |     a qgroup rescan
 |- if (ret) goto out;
    Which skips the del_qgroup_rb() call, leaving the in-memory qgroup
    rb entry still intact.

Then later qgroup rescan/update will always fail and mark qgroup
inconsistent:

 btrfs_run_qgroups()
 |- update_qgroup_info_item()
 |  |- btrfs_search_slot()
 |     Which returns -ENOENT, as the qgroup info item is already
 |     deleted.
 |- qgroup_mark_inconsistent()
 |- return -ENOENT;

[FIX]
Do not treat "ret > 0" as an error.

Reported-by: c.f.a@posteo.de
Link: https://lore.kernel.org/linux-btrfs/14846642-85d3-4afb-ad99-1b74b22f5f90@posteo.de/
Fixes: 9c8b35b1ba21 ("btrfs: quota: Automatically update related qgroups or mark INCONSISTENT flags when assigning/deleting a qgroup relations.")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index bf06962d49f3..dfe3827ec369 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1853,7 +1853,7 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 					struct btrfs_qgroup_list, next_group);
 		ret = __del_qgroup_relation(trans, qgroupid,
 					    list->group->qgroupid);
-		if (ret)
+		if (ret < 0)
 			goto out;
 	}
 
-- 
2.55.0

