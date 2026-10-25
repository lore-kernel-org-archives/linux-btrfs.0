Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917740;
	b=Qg3rpQ/kGbep/g+y3oNf4LneCmoDETplvWyu3ZVXz/OGzRCI4b/HD3Gp0jHtGE94LjW2
	 OGSHDC05XxQ4k3U+CV8GQXsJimb69VyAWh83dGg8hh8kfB2k1NAByFSIh/koqOZTCGkkw
	 XsAh5EecdcyG0PaiN/olWdWm4TVH1V3aJzg5DACUpdu8BbUcT0NEP2DDgXwzApbX2dlIu
	 we7iEiu1OXaWiok/GAV/9pEiaINoGzEpKOMhB/o/4KYc/+roOvr/dhrqY7zJLqwI0557I
	 I3IeVRyFaXKfhDUlVdSI00AeiyjGyJxuINiiFNlZFiEnD0alqdbpvEvJA3yANToFVsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917740;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=5otoID3GHjGjsiLi+aCmpwQzgJamuJSrNJQ5+JrxmBE=;
	b=Nx5eEtZOMal+PpJHlAVwrZx3zpjk5dYWdR/xO9uGJvJ64/y87tpDyo3ZdlPprwxz+9Rq
	 HUhH9WYdGx3qIVwznBfi2CCUO4teLHxPCF99yZAExSJFwTnWp6VaKSnNwCAooq0srhgdU
	 qrSE43h94+gQvruW20T3L4Sd9h6usSmeZ1rJsJRtKYGKDu4Br/KYAhi/CvaN0yEQNzsnb
	 Pcg1l6GV24IzKZ7gBNsm3n4EOufqqGxt9eethHkrPwlu63IcL3gAX1Z3Wl+8/nU7KXtnM
	 aJLBn5ZoF8OqZrrKncRwrDRTdHx8XlHK0VEZpRgeKQmVuWtmSVbJzfhWeY9utl/2pRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hpSYhkGX;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hpSYhkGX;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E3E606A324
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78E3E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hpSYhkGX;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hpSYhkGX
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B45B41F390
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5otoID3GHjGjsiLi+aCmpwQzgJamuJSrNJQ5+JrxmBE=;
	b=hpSYhkGXBey4feDbw9Y4TMEwnzkmD2cPYjX+7jKTXO034sIk+U6WJZhF3qqErGL6tQ5G7x
	iR5iPj4qIJ/CLTwNZJUoUeYV+rxVp+A8W+/q3+ybPke5gSLrj35Toh2I+yQ0obY9RaYE3w
	97U2e5l8abBBga0/tVIa7+anOYu6rQU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hpSYhkGX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5otoID3GHjGjsiLi+aCmpwQzgJamuJSrNJQ5+JrxmBE=;
	b=hpSYhkGXBey4feDbw9Y4TMEwnzkmD2cPYjX+7jKTXO034sIk+U6WJZhF3qqErGL6tQ5G7x
	iR5iPj4qIJ/CLTwNZJUoUeYV+rxVp+A8W+/q3+ybPke5gSLrj35Toh2I+yQ0obY9RaYE3w
	97U2e5l8abBBga0/tVIa7+anOYu6rQU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9C2EF13314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T8
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 07/12] btrfs-progs: image: fix the error handling of build_chunk_tree()
Date: Sun, 25 Oct 2026 19:11:41 +1030
Message-ID: <d5ba24e8e2f9e88e5ff1b90ec08e64737017808b.1792914402.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: B45B41F390
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email]
X-Spam-Score: -12.01

When btrfs_check_super() or add_sys_array() failed, the buffer is not
released and the pthread mutex is still locked.

Fix it by adding a new out label, to release the buffer, unlock the
mutex and return the error code.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-restore.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/image/image-restore.c b/image/image-restore.c
index 89ce2f3e79ed..2e4c19746cfb 100644
--- a/image/image-restore.c
+++ b/image/image-restore.c
@@ -1182,14 +1182,12 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 	ret = btrfs_check_super(super, 0);
 	if (ret < 0) {
 		error("invalid superblock");
-		return ret;
+		goto out;
 	}
 	ret = add_sys_array(mdres, super);
 	if (ret < 0) {
 		error("failed to read system chunk array");
-		free(buffer);
-		pthread_mutex_unlock(&mdres->mutex);
-		return ret;
+		goto out;
 	}
 	mdres->nodesize = btrfs_super_nodesize(super);
 	if (btrfs_super_incompat_flags(super) &
@@ -1200,9 +1198,12 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 
 	memcpy(mdres->uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
 	mdres->devid = get_unaligned_le64(&super->dev_item.devid);
+out:
 	free(buffer);
 	pthread_mutex_unlock(&mdres->mutex);
 
+	if (ret < 0)
+		return ret;
 	return search_for_chunk_blocks(mdres);
 }
 
-- 
2.56.0

