Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795167721;
	b=LGF6ejE3sk5tX6GJW113ANVvcd9qMqpGjjIZAHHuaGx3+AB+hFRen8Ota5NjWR4q6JZU
	 6J72mD8KxgK/434jK+bDQ0S3zBixhCuD70sw3FdHuAJxjS+mAeaG2fxP3ZcdiW0WghuJM
	 VW3V5HU/m0yGANYczaN+O/oCPxlH28F6Xcs+yrND6lOxNY2fcHKXRo9o11xQIJ8DILYp4
	 QnC8cfZdfF76K+cFZatw/tL/GM3mxgmKpUyxAlfnz+8fbs12aaHAG05AV20NcBIv0BROa
	 ui+c1OAwQGNRn/2MOAUB7gyuCe258vWzJnNo9t2juPbHkgH7DasYe/DlK0kDTe0BU0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167721;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=v64P1EwATjdZXZqcfFNYNZXF6dOCiOp5hxTXPjyn+jQ=;
	b=SIDImBQrkHVAxUjNMykW/fw8kngpU3e7ttRHxGVjULbqehk9k0MOIqwcdz8a27qyq+ES
	 qyqQzZaw7i/wgub74RmHZAMuhcuGFHIpuFYyuCwEU5PEmaF15tQQXNLs3eS9GiAbTR0RW
	 LxUdr5aPDhYGOpeIVi+JG2jYrSx4YD6b/Xbgu0S8zNd3952iO4kH6/sMIhEpL6aiRSosU
	 mRGkjoh3+LgLS4WmrquIfJxD25P4XNw4/KFt5o39I0XgDBOSBnYwSInT/h+c+3m920o2y
	 n/pHHWHRZI91XSbR9l8J6kROieEhNeuI27dIQsykrMkW9bncSZVP8ovP0R5Y4YXRofA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LlL15+9O;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rp1n57BU;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD99606A325
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:42:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BD99606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=LlL15+9O;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=Rp1n57BU
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 46D0F22607
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v64P1EwATjdZXZqcfFNYNZXF6dOCiOp5hxTXPjyn+jQ=;
	b=LlL15+9OIBoUtXGQ2JfebegiPzDfDIVNJ5fkQ6FTpe5dwHhsmP7sSPMvWi5ZuXWFviP7K9
	uNLlXkp81Pq6m4tPelynz5l2I8A4moi56aIJC0++Q+Vm7O863rJDkLsvIObVfJKPfv8K+9
	sB5ppmfJnU2ih+BkbYg51WsHQDaT9yA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Rp1n57BU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795167717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v64P1EwATjdZXZqcfFNYNZXF6dOCiOp5hxTXPjyn+jQ=;
	b=Rp1n57BUSQJ8OUTsAaCD74tumTGYH0kdOBSMxmlnqXxVdtcMyKJcNOKyrlm9ow1+ChvRia
	i3EAjdNM8il7w+EbR99Q5IYX6QplJ0DnDYo+hAAzeGZThmjKU1i47ZhIonUoGmsBrdjhnQ
	NIR+qP6PruWFJ5eoRuivzQVTRrfOc+U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 296901348F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id maa+MOEVAGsBBgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:41:55 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: qgroup: handle the transaction commit error during rescan
Date: Fri, 20 Nov 2026 20:11:33 +1030
Message-ID: <900cc1ec5feac55f401015f3fdadc242c0c6d275.1795167390.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795167390.git.wqu@suse.com>
References: <cover.1795167390.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 46D0F22607
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,sashiko.dev:url,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

After qgroup_rescan_leaf() return 1, meaning it has done the scanning,
btrfs_qgroup_rescan_worker() will call btrfs_commit_transaction() to
update the qgroup infos.

But if that btrfs_commit_transaction() failed, @ret is still 1, which
will treat the rescan as ended successfully, clearing the INCONSISTENT
flag.

Fix the error handling by also check the return value of
btrfs_commit_transaction(). If that failed, update @ret to the error
code so we treat the rescan as failed.

Link: https://sashiko.dev/#/bug/linux-b578ca93-4f5a-4a46-9dfc-71c1ac9af095
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3127d3fcab31..9f3886d128d3 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3928,10 +3928,15 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 		ret = qgroup_rescan_leaf(trans, path);
 		did_leaf_rescans = true;
 
-		if (ret > 0)
-			btrfs_commit_transaction(trans);
-		else
+		if (ret > 0) {
+			int commit_ret;
+
+			commit_ret = btrfs_commit_transaction(trans);
+			if (commit_ret < 0)
+				ret = commit_ret;
+		} else {
 			btrfs_end_transaction(trans);
+		}
 	}
 
 out:
-- 
2.56.0

