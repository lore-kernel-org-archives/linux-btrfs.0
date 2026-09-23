Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C4C408017
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142314; cv=none; b=YgT/J7gqV9qJe93FaLqBOzYOL96S19uUScQTxkqRfuY+cJ41IBKl8zuUCSkbI0Klkk4JtKRRnhGIQA/kaHRNr6vz9WFEMiOb+vRoWnz2OHHYh1V79aNvdhd4BuTYhXav6zE0oFcp3gtlKaz2MADDVVvtacezjzMnc/rRyU3mxhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142314; c=relaxed/simple;
	bh=PhUnih4M8FFDSShBClD8bsVhHHpeOOJVRZgv4KXd/Ys=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2cmB0l2m6xtba21IDst4BMww22OjA9Cl91Jlg+YgnLnR+AvZRT8BttmmABWLJti4b9d0JAAkRd91yR19Kk2nlDNFHnMfspPLRufu15E2KcxP5KEgd4MtCPgnWQv5M5gFa+GAe2tkb79P0jr9Fk81fHav53YwA0/1+B6UzhiDss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VYpmhL1o; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mX6sJI5u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VYpmhL1o";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mX6sJI5u"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 580BA1F7A6
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGqXOsNEtpasGfRSHRJM7KRNM/UgfsucNO96y3cbPp0=;
	b=VYpmhL1oAuBFh4xxP8pMSKmcxHOhYfrB+1XtMSNglkeqwQxYpCvcRXS9HW6Zugrh3q5ZMH
	QsMgBq+YcB1ZDwpwZ8Zeh2/kBdLq4yS9pcHOouJgmveWB7IPQ/+ZjsaqOzfYcn5kDPuKHt
	fxbY8qfUMRdzvrsSunSjwb4MKK/Mx3U=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BGqXOsNEtpasGfRSHRJM7KRNM/UgfsucNO96y3cbPp0=;
	b=mX6sJI5ue4b86Cl3B1iaJAjRaTHZlDQhA7RRwJtU+BKuc7ZvmDPjGgNoFyWi9unCnKvv5q
	RtG8/Scl7nsgOto6Xwsf8U9GrpQq8bxF86QbSlJxWF7XyhhjpFGMPfu7ePkEt6aDe+FP6H
	2rAzNCbfzn34QHjxEub0hVtNCaQl+Fg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C276139E9
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 40aCMlVns2o/dgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: use kvmalloc() for btrfs_encoded_read_inline()
Date: Wed, 23 Sep 2026 15:14:25 +0930
Message-ID: <7cf8e8db02170e4d85d114382db1a4f04c905f62.1790142027.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790142027.git.wqu@suse.com>
References: <cover.1790142027.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Near the end of that function, we copy the inline extent data into a
buffer, then copy the buffer back to the iter.

However it is possible to have an inlined extent larger than a page.

For example, a btrfs filesystem is created on a 64K page sized system
with 64K sectorsize, mounted with max_inline=32K, and a 32K inline extent
is created.

Then the fs is mounted on x86_64 (4K page size) with the experimental
larger block size support.

In that case, kmalloc() is called to allocate a 32K buffer, which can
fail on systems with fragmented available memory.

Meanwhile there is no need to allocate physically contiguous memory,
so change it to kvmalloc() to reduce the chance of memory allocation
failure.

Assisted-by: LLM (finding callsites doing multi-page kmalloc)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 53f4532593b3..d04a7dce93ff 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9571,7 +9571,7 @@ static ssize_t btrfs_encoded_read_inline(
 		ptr += iocb->ki_pos - extent_start;
 	}
 
-	tmp = kmalloc(count, GFP_NOFS);
+	tmp = kvmalloc(count, GFP_NOFS);
 	if (!tmp)
 		return -ENOMEM;
 
@@ -9584,7 +9584,7 @@ static ssize_t btrfs_encoded_read_inline(
 	ret = copy_to_iter(tmp, count, iter);
 	if (ret != count)
 		ret = -EFAULT;
-	kfree(tmp);
+	kvfree(tmp);
 
 	return ret;
 }
-- 
2.55.0

