Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058439;
	b=YZibZoxj9ew9rIlEdODK8BAJJQ5Yc0bU9BmLaoD7KUwS/94n9yd2DT5BtSGyxaUqzxop
	 /BX+idHswbxB/+QR7WYnfxjtRHs/7Y34w2SPsICLnDysG8gM3Q5D93yNW0KDypHLl+kcf
	 GMv5nmbYj2quxajVem/ejv59kSajnq2ZwdaLoZRaHmjFK+VlV6Tc6b/vLTGvVDbHqWcod
	 s4zHpEgoS5khxq1eFeIusTc4Lv6/ollrV1hbSnsHRslEv9KscPR0LBD+feZhcT2E9+k4+
	 OZ3ClSFNGlMMFwl05/8mV43pxEM4s1gb6Pz/s/UkfwOfjQaNixgxqN/CsUw9gF55mnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058439;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=OaUvmqENVNf5TgMQjpUMk1If41XSX2nhK+nIEpj4fmM=;
	b=AnYXAaas8U2ZHEkFQsSwJe7IF5kSHXLySjZj1RYaVoMuymUgGpHMGa1AjlkyLCI4Ugyy
	 D9DEw5NC2TNwF8jdxAgxFOZtckTxzOmOy2nH1jrhgWCRGpofnQ2Gm8p+VSwu/U7Fy2ixE
	 wlAsKI2QSRhI343QRQI9HjOp3bcKsud9pygW9w3kgKd36+5+3urLw8wzMK9UUXYpey50e
	 qQoEwqvO+YEuQWsfzFBN47wSSTt51jiM6XtOEeF4wGRkux16LuiLqGSRL+Vk3G0R7VXDh
	 fx9xzePJJgx77ldpxMoZB6AWlx+EmitYwMiw4p65IKFuqxxNM11c9wO9ouMAWm2BxEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="uLs/ke93";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="uLs/ke93";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E1F606A320
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6E1F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uLs/ke93;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uLs/ke93
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04F1B22170
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795058436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OaUvmqENVNf5TgMQjpUMk1If41XSX2nhK+nIEpj4fmM=;
	b=uLs/ke93+miMWWlinLCrI7it6Dlikr5okR9eXyOFp4zdvCMKzJr/gKKgtwerYBocJcx/ea
	JvYQHA7mTOTbOSRs+H9DGsthcxBVO9q05s62uj+N6R3H310T8S5OLhVzc4ikK9siCGCaXh
	Wie6kFWTHdLIGVDhDfziUIo4BYClfVI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="uLs/ke93"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795058436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OaUvmqENVNf5TgMQjpUMk1If41XSX2nhK+nIEpj4fmM=;
	b=uLs/ke93+miMWWlinLCrI7it6Dlikr5okR9eXyOFp4zdvCMKzJr/gKKgtwerYBocJcx/ea
	JvYQHA7mTOTbOSRs+H9DGsthcxBVO9q05s62uj+N6R3H310T8S5OLhVzc4ikK9siCGCaXh
	Wie6kFWTHdLIGVDhDfziUIo4BYClfVI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4ADB134F6
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sSvrFwBr/mq7WQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2026 03:20:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: always check if the fs has multiple profiles after balance
Date: Thu, 19 Nov 2026 13:50:13 +1030
Message-ID: <d679353ea7e321c95dd344bba75f1ffc1a24040f.1795057869.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795057869.git.wqu@suse.com>
References: <cover.1795057869.git.wqu@suse.com>
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
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 04F1B22170

Currently btrfs-progs will give an warning if the fs has multiple
different profiles for DATA/METADATA/SYSTEM chunks.

However this only covers canceled/paused balance, not a normally
finished balance.

But it's very simple to get mutliple profiles using filters.
E.g. limit= or usage= with convert= filters will only convert part of
the chunks.

So add such warning to cover the finished/error cases.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/balance.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds/balance.c b/cmds/balance.c
index 96ae04d6da7a..673cd6dd4632 100644
--- a/cmds/balance.c
+++ b/cmds/balance.c
@@ -365,6 +365,7 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 			   args->stat.completed, args->stat.considered);
 	}
 
+	btrfs_warn_multiple_profiles(fd);
 out:
 	close(fd);
 	return ret;
-- 
2.56.0

