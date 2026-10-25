Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917735;
	b=DULopk4e5vGYSe+PEsuj2e07qNxMQQOoTp582Oel7KmxyqsvTh6OUQaAkjc8HdvLK0yK
	 SAQwFzH1EL/WVdFifm5UJ5p0dkg52Gp1SZu4v+FaLBChje8jmWoB/hvzyNm+lw0yU8UV3
	 VgsqAWSRDKkaUsBLe3vSKsYuE6g1c0bpOM2UwKCaZdyU2WwfF+5oV5FhGMjwB2wngeuHr
	 2a/aKG62vkATQZU1nih+zLNm5tLTSGiTwzNSorsA37OlDQwJxCwxNCn+EO9z5FWWb5n2O
	 2SgADTS43uGUVly/1w2QnSyVJ7r4YwX59PCCyDGMk6rdJpsFW3Ex2CHgarJX28fsBug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917735;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=pI/E9pUo9ATbimMB0N8vJvYPQbagArxGcqDTUrV94+k=;
	b=15mbAyCLWqtxugEFc2pk5YWXepn83NUNO8/TcUkF0tGa9fs6/Gd2FJYV6gikeeFGSRWy
	 6xxENMg3tEtDDTsCIUSkqO6dE+wDw8kMzsMGyrRrfszfJQZX7McjiM0IaMDCsxKaCySwM
	 YuivjRymoTlWZuCbL2ku2iQprdKE/HKZaPohXVje7pkYuzjendmw6rZhwRnu3ElD9rlnN
	 xAOKD8wap6h4yT7tKUSMVt41+aUNplJwBo/omhev0b76m4pmUK0VhbIyteUBVUVhaQhUD
	 Y4GP2aVyoSDMbsdrpIM9XDEht6WqcgG/0EK4/UP2tvAWgALUZMnKVbTcu6gyyZE5pZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UEIDOvcD;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UEIDOvcD;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9EB606A31A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A9EB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UEIDOvcD;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UEIDOvcD
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC03E1F38A
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pI/E9pUo9ATbimMB0N8vJvYPQbagArxGcqDTUrV94+k=;
	b=UEIDOvcDfW+lcwG6ZBqeup8MLGTBLXwMd5Ttr2ZWD6AI9UfuFST4T1jiW5Ekkq/gC/0v8+
	BJEVPhjvI5xxb3HhSPlRCwhsGFMW8edk7k+x98bABYhYOVbgzW0RAL8kyusTGtYMVUrdf1
	n70eHWM3ualHrpTl0y7LAAA1Hne1eBw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UEIDOvcD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pI/E9pUo9ATbimMB0N8vJvYPQbagArxGcqDTUrV94+k=;
	b=UEIDOvcDfW+lcwG6ZBqeup8MLGTBLXwMd5Ttr2ZWD6AI9UfuFST4T1jiW5Ekkq/gC/0v8+
	BJEVPhjvI5xxb3HhSPlRCwhsGFMW8edk7k+x98bABYhYOVbgzW0RAL8kyusTGtYMVUrdf1
	n70eHWM3ualHrpTl0y7LAAA1Hne1eBw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B447313314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/12] btrfs-progs: image: do not cleanup the thread that failed to be created
Date: Sun, 25 Oct 2026 19:11:38 +1030
Message-ID: <5adfe5a7bd9eff59bb380ab2ae5d9866ec764ec4.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: CC03E1F38A

Inside metadump_init(), we initialize every thread slot, but when one
failed, we need to cleanup the previously created one.

However the existing code tries to clean up the slot that failed the
pthread_create() call.
This means in metadump_destroy() we call pthread_join() on the slot where
it's still all zero.

Fix the error handling by only releasing the allocated slots.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-create.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/image/image-create.c b/image/image-create.c
index 1fd288d2b566..75f450520059 100644
--- a/image/image-create.c
+++ b/image/image-create.c
@@ -179,7 +179,7 @@ static int metadump_init(struct metadump_struct *md, struct btrfs_root *root,
 	}
 
 	if (ret)
-		metadump_destroy(md, i + 1);
+		metadump_destroy(md, i);
 
 	return ret;
 }
-- 
2.56.0

