Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793525838;
	b=rSeIeQRqvjoKBJJ+B+xdFju81fbAAYvPxlf44qjsommw7vOEXYZIz4rEhuNWPw0bVXS4
	 MeDz3qfP8DuQhAmEc5pkQe9zi+VLtcQRe2NWrg8lVh0zBt12T/ui4Qtu06OHf/LbN58fq
	 nXcq25rVNpJW/bNqPO6/RjuoWTSGFslopSegnzS4l280ISeKbMNIM8lOVEY7h4IcsIXYn
	 ClK7MBDLVeaUXbvW9kWGiTwAb08NGvxybrYezZZ+fzWbJVUeMq0LDcuuf4JtIe37IdARN
	 GBy4rc+WHYUM5cCnkv4qaBL16kb+GKnCuv6T0GiZI7RWvS9XvpoLuMYRQki7dCxp0Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793525838;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=kz2RlI0ZRiKxufIxXYqDHU2rCBda8bclfN07N+lg2dw=;
	b=XL9BakfUD+XMB6OGWjm424J18s/CFag45I6jpOXJjJVAWVti9uf9zQ9eQkxJY931JPx2
	 MPv2mjq60Iq1DBs1+TC9nct9z0oLZTgusVajG04JufAIpp5OvC+t4AJAcdtbTYAUu2EzA
	 c7TPzbVX0kvO1L/ptOq93qc+OoB2O+dFKut1rTLJtx9R6J90oLvBDB7GhyFZlL9oQpDI5
	 hKi5GAdZyUwZ/T8T0OUovwroEgjEL8pRor0MTFVP3l/HV0hirjuUMBMP+EMSh/c/0+juA
	 Ylv3r1UfKC7pCyuSZcZpsN0EFz+XVENYZf7NT2epXMoRqjKv6srYt86ipvvKESmH4ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uSdzaEzb;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uSdzaEzb;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7959D606A32D
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7959D606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uSdzaEzb;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uSdzaEzb
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A3364220B1
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793525835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kz2RlI0ZRiKxufIxXYqDHU2rCBda8bclfN07N+lg2dw=;
	b=uSdzaEzbKAe9nFXaknKXJCg/e5Fvj/4YjNtsOccAzQzjEsZbbL27Gee6uy5DI0ck2cbBtD
	uaHtyGP6UMcpQItsbszRa4mvGFuNmFB6CC8D8wWjWyI7tDUI6dosCqlTJgqJc2fytYY41O
	TBMEQb2N3ZNzeU0+ziqKmmuc6uPKWWc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=uSdzaEzb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793525835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kz2RlI0ZRiKxufIxXYqDHU2rCBda8bclfN07N+lg2dw=;
	b=uSdzaEzbKAe9nFXaknKXJCg/e5Fvj/4YjNtsOccAzQzjEsZbbL27Gee6uy5DI0ck2cbBtD
	uaHtyGP6UMcpQItsbszRa4mvGFuNmFB6CC8D8wWjWyI7tDUI6dosCqlTJgqJc2fytYY41O
	TBMEQb2N3ZNzeU0+ziqKmmuc6uPKWWc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9047C13314
	for <linux-btrfs@vger.kernel.org>; Sun,  1 Nov 2026 09:37:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id odilLEYI52qESgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2026 09:37:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: trigger a sync before waiting for subvolumes to be dropped
Date: Sun,  1 Nov 2026 20:06:52 +1030
Message-ID: <eea6dfc96042467970a2ea554f73630bc57d784e.1793525519.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793525519.git.wqu@suse.com>
References: <cover.1793525519.git.wqu@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: A3364220B1

The command "btrfs subvolume sync" is utilized to wait for deleted
subvolume(s) to be completely dropped.

The subvolume dropping is done by the cleaner kthread, which is normally
woken up by the transaction kthread.

That cleaner auto-wake up will take up to 30s (the default commit
interval), and that's why a lot of fstests are using "commit=1" to speed
up such subvolume dropping.

Considering the default wait time is pretty long (30s), and the command
itself contains the "sync", it's better to call BTRFS_IOC_SYNC to sync
the fs and wake up the cleaner, to greately reduce the wait time.

Also update the docs to reflect the new change.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-subvolume.rst | 7 +++++++
 cmds/subvolume.c                  | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/btrfs-subvolume.rst b/Documentation/btrfs-subvolume.rst
index 77fe5d005c35..478caecde69c 100644
--- a/Documentation/btrfs-subvolume.rst
+++ b/Documentation/btrfs-subvolume.rst
@@ -276,6 +276,13 @@ sync <path> [subvolid...]
 
         If the filesystem status changes to read-only then the waiting is interrupted.
 
+	.. note ::
+		Before btrfs-progs v7.4, the wait can be very long, as the subvolume
+		cleanup is triggered by cleaner, which is only woken up every 30s by
+		default.
+		Since btrfs-progs v7.4, this command will manually sync the fs to
+		wake up the cleaner, to greatly reduce the wait time.
+
         ``Options``
 
         -s <N>
diff --git a/cmds/subvolume.c b/cmds/subvolume.c
index 1c53686596df..9db7e9ba0c23 100644
--- a/cmds/subvolume.c
+++ b/cmds/subvolume.c
@@ -82,6 +82,10 @@ static int wait_for_subvolume_cleaning(int fd, size_t count, uint64_t *ids,
 	size_t done = 0;
 	bool statvfs_warned = false;
 
+	pr_default("Syncing to wake up the cleaner\n");
+	err = btrfs_util_fs_sync_fd(fd);
+	if (err != BTRFS_UTIL_OK)
+		warning("Sync failed: %m, wait for cleaner auto wakeup");
 	pr_default("Waiting for %zu subvolume%s\n", count,
 			(count > 1 ? "s" : ""));
 	while (1) {
-- 
2.56.0

