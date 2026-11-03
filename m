Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718352;
	b=148TxvSCakNUVgMNdgFj9B+vusgDwOH9JRN6XqdL15KT42YZl8EB2Gp0sn4ZOCvuhPDm
	 mbRfYUQs8FXakz2meQysavmARd7cDKd3MzX3pj7WMhU9wLHv7elFEQd/Y2hHE6BYtA29B
	 jqJ6F5dwA5eeItwM+yeNp/4Zyo8j7V6pMdGLlZt+wPuskXwjsSg80ZuYYz1Z1cysTAmz8
	 w8BV/iaChLBzgy5iK9VkOODBvHoCJ49diVpHEboAlO+WBRwB2GfP1BYThXmKozRKJR+Cv
	 uXzpA1MmhWiWcfHbEAZOhhzvaVpgYJB5sCW2kXxM+HPl3reysGtYzRkh46DelQjQxsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718352;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 References:In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key;
	bh=lAa/3aJjQPYp1qwn90DpoaP/PT6OS4IOMITQs9V5xd0=;
	b=ok4FOsxKoyl+dpYHIFSV0hSMX2DImnXM1KZGSi/fGn2CC16hTFeZNoSsuMRCre2eP014
	 E0lzQKOWnZf1rciG5t0WMD027xJgfllhooxFbw8EiRln/1vYbX8W8I99klTdWZt1HliYx
	 wiNRMISbf7r9AVEPybV8yNgd+8QcU+jB8TN5FFJM+4zeh/h9CrHi+0Vp0YBHG2UPDKYNQ
	 oDMPB8g/mG0XJ2wNZfo5/BerzzLwxPb3YyXyEJH3Bo/w0+QSaTBZXH8cCiEw8SldTBvEv
	 2dLlvasb7NnVkYeB4DVP6BazlddR3YVCA3hApXBLNLpfqybaqo/BEw/XGq6iZSWocdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=NBNXcPHR;
	arc=none smtp.remote-ip=209.85.221.176
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC903606D81C
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Nov 2026 15:05:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC903606D81C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=NBNXcPHR
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eaf169fe3dso1121456e0c.3
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2026 07:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793718351; x=1794323151; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lAa/3aJjQPYp1qwn90DpoaP/PT6OS4IOMITQs9V5xd0=;
        b=NBNXcPHRVhfotKqrLNY+IG8lG5uIbvofkj0aI9bAqJCBAHo/LGAftaMqZeCpS66ecz
         gcFdDkkekpZb0uHt5rVYeuZvVJnDh3LYzf/O9UZAe/VinE3LvbwTodsOQOgIp01ityQQ
         PyX/HAB+BH6NsqogkcGiT96k8BCovOJbsXCRovxXl5B1yLiZ/GlWzSaL15faBygv6sU+
         In4p9RwatKeYLmgPY+5BWeZ19dykPmN190m0xPgwlgisWD1v3Fh2D1xO7bR3mhU/TD73
         bKdkDrSL18p12J0TbUUuprXMRiJ3hn4mt7c/30eORkiCzgbdKdJN6wfpQidKLB5iYFgP
         6CTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718351; x=1794323151;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lAa/3aJjQPYp1qwn90DpoaP/PT6OS4IOMITQs9V5xd0=;
        b=UVwU3GMFD0FW8ucbnLtyndSJ64DAQCKWTTy2ZAX0FZBRTacDt0rGaCHPG/isBjfUNl
         FMDrhAHnCAsrNqV7mfQSXncA/dfomub6da7VX9RgRv7IXLuES1yhkDKASQHXHKENhIyR
         Zejv6S5b0Ko+fyj7/Wq/bUd2igc3z1UUJXyKPH4DL9gp2KMDw8EPbZZum1GY38rQmvAk
         xdibZqZ95rH/fgqNhdcTqw0hay0kKl0Ngyy0rMeZ+FVyFqoVlr/kBrh06pfH6297zxsw
         8YGg2JmNAz2sL80fGDzUnwSEieN8bpr6Xr9OQ7DfaLa2/EFGV7zcJcagRA8GjB34TAVS
         vKoQ==
X-Gm-Message-State: APuU4Z+SbpF/jn/4hAEGeSXoEqt5YMexDBk/nMNT4oyrlNCB3yhcsMvO
	tluoJgoagmC/tIEUkEFp24MOe/AAQux5Jl49SL5MX126IZG4pan4GwUqhRFt2BU1kAs=
X-Gm-Gg: AYBFou1z0iQ1KGfDRApTr1Er8KCl7kAam+JLUI/PiBGWBx5qOW1eh0sEsIganjm+MBg
	Gi0/VoUVex9ELDX3aDZMqeQ6G/u6KxIjXqGrbkSZNT4GUtrQmE7qI6bORWmCuuNQ03UYfAqLYmK
	RDykNviSJ/yJ+9bxQMJ3HT4wjCqBYN4uf86v0cuUqz70Ixyr34zwnR+UHfT3ZvQGIdNOtvhW72a
	m2qvhLQuuTXGhv/dJSE2B2rYsOGQXdH553aHghKkgyK7s4KqG4JoMRUjGDyxxiuJigoGO+mhk94
	Y1kR+tBdA/w55QUFUfUkLMqy2VFX+6pMOdxzXjc2oT3IovQMf6wftVa53psL9rbIyQm4P5BljwC
	foEOChpuOldUCRxBlF9oNaaTJgHTEb0BHswLYbbtis+z1e0ZtHmreBLMisfTbLii4ErytaDFpNE
	p9tj7rJP5Apv6J+fmMMFznVQrTjCCUuGgX+7/oZ+NDpxk8nyLV1zZPovXRvpDAOjK9/L+iDKZZE
	nR8j/nI+fQ1LLAr8ryKYru0BA/ZhOUgBrOSzhM+9x2eML2Omq6k7VfWZLwhbjjWZRUHkyeHMF8n
	4K1TfMB8RZDmXY5XUDPRAnJQ3lvgUYV05pyD3w+IIKZ+
X-Received: by 2002:a05:6122:4b8d:b0:5ea:e905:2039 with SMTP id 71dfb90a1353d-5ec6894e113mr5697560e0c.13.1793718350840;
        Tue, 03 Nov 2026 07:05:50 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.255])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-992ee437d86sm15203204241.8.2026.11.03.07.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:05:49 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 03 Nov 2026 15:05:19 +0000
Subject: [PATCH v2 4/5] btrfs: don't report success for a skipped log sync
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-b4-btrfs-data-integrity-v2-4-577dc2690061@toxicpanda.com>
References: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
In-Reply-To: <20261103-b4-btrfs-data-integrity-v2-0-577dc2690061@toxicpanda.com>
To: David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, Qu Wenruo <wqu@suse.com>, 
 Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793718330; l=3593;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=pb3ZJaSZEuGE2EuaruC+9DgUr6NKGbLn9bdI+79i/3E=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNP/iVXQVI4rBjCBBM7l+LEfTdcSroeAQzE1wE6QOTOIxSy311mqKEM+XrtSpfK/0Fm3jHKzS1A
 M5tAKULnvzQY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

When a commit of the log root tree gives up, because the transaction
needs a full commit or writing the log failed, btrfs_sync_log() still
advances log_transid_committed and hands the result to the contexts on
the list. Unlike a successful commit it does not advance log_transid, so
the log transaction it just retired is still the one new syncs join.

A sync that gets to the log root tree after that adds its context to
the emptied list, sees log_transid_committed >= its log_transid and
returns its log_ret, which is still 0:

  fsync A (subvol 1)           rename       fsync B (subvol 2)

                                            btrfs_need_log_full_commit()
                                              -> false
                               btrfs_set_log_full_commit()
  btrfs_need_log_full_commit()
    -> true
  btrfs_remove_all_log_ctxs()
  log_transid_committed = N
  log_transid stays N
                                            log_transid = N, log_ret = 0
                                            log_transid_committed >= N
                                            return 0

btrfs_sync_file() then ends the transaction without committing it, and a
crash before A's transaction commit loses what B was told is durable.
This was reproduced with delays added to btrfs_sync_log().

Fix by advancing log_transid when a commit of the log root tree gives
up, so a later sync joins the next log transaction and either commits it
or gives up itself. The check for an already committed log transaction
can then no longer be true, so warn on debug builds if it is, and force
a full commit.

Fixes: d1433debe7f4 ("Btrfs: just wait or commit our own log sub-transaction")
CC: stable@vger.kernel.org
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/tree-log.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d9dfb63fc5a..3de7757d168d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3437,11 +3437,20 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	if (log_root_tree->log_transid_committed >= root_log_ctx.log_transid) {
+	/*
+	 * A commit of the log root tree moves log_transid on even when it
+	 * gives up, so the log transaction we just joined can't be done.
+	 */
+	if (unlikely(log_root_tree->log_transid_committed >=
+		     root_log_ctx.log_transid)) {
+		DEBUG_WARN("log_transid_committed=%d log_transid=%d",
+			   log_root_tree->log_transid_committed,
+			   root_log_ctx.log_transid);
 		blk_finish_plug(&plug);
 		list_del_init(&root_log_ctx.list);
+		btrfs_wait_tree_log_extents(log, mark);
 		mutex_unlock(&log_root_tree->log_mutex);
-		ret = root_log_ctx.log_ret;
+		ret = BTRFS_LOG_FORCE_COMMIT;
 		trace_btrfs_sync_log_exit(trans, root, ctx, ret);
 		goto out;
 	}
@@ -3575,6 +3584,13 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_lock(&log_root_tree->log_mutex);
 	btrfs_remove_all_log_ctxs(log_root_tree, index2, ret);
 
+	/*
+	 * If the commit gave up, log_transid still names the log transaction
+	 * we are retiring. Move it on, so that nobody joins a log transaction
+	 * whose result has already been handed out.
+	 */
+	if (log_root_tree->log_transid == root_log_ctx.log_transid)
+		log_root_tree->log_transid++;
 	log_root_tree->log_transid_committed++;
 	log_root_tree->log_commit[index2] = false;
 	mutex_unlock(&log_root_tree->log_mutex);

-- 
2.55.0

