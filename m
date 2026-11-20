Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165744;
	b=fKaeMIkwlXjmCsgddVuxLMXmBmio7K1G8a/eMJtT7LfrY9oy0D2enrBWHkXaojdbywXb
	 5OP2b7etZBBBFBM8YqG83aTxpjAdG9cdvQH5m12KU9ta2hPscE8kk49FykJtQiwGoBdcC
	 2mkST5rPFElBwdq51oQSGIaxEmpnDVORIZz1kzkXDczTiKhH68QpPz7upNKXRjt9g6nOw
	 +IShad9Mjh7KEMWLFVtRpAvPaiDW8UScnkJlqz3OH0808MX9WMZvw2MeYaygrnftznpx3
	 kWKEwnN5UPJkgMWSu9GngelxkSeaoAVtkv7oxHYFbxGS6QrSlA1r+k28FdhSvucPX9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165744;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=v64P1EwATjdZXZqcfFNYNZXF6dOCiOp5hxTXPjyn+jQ=;
	b=2Ll1mXcOjb0LKhx9Qhf12QxvwDjD3GvReGoyRbbLslWcClwDXcMARjeFexoCLFpQXIXr
	 y0Rz5JCROglsrT82FD4ddk/pfvDXWjrt4WAlRVDDiPnP1HDKsMjDLnoegGDaKgnN1lSvJ
	 Obg7dvbiWQ0jFWNq4PjDY69oqiqcsqg5gXGl5N3u3fNx0zyeb2hYhoNYhrIrXBubX+W+6
	 fzATSCo/2SLnvDfgkpJKZMfdxOB3rt1xvU+wmK439Tao1XBHbaevCQfQuMorXbBoUmDte
	 D1fVdKJ+3xhxqH9sd4sbYhN1qZM4H7FLydDMVB+30/o7kqIcCZimZi61nI44IxyeypQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pApR7MQV;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lGN81QS9;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366C3606A325
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 366C3606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=pApR7MQV;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=lGN81QS9
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7809D22537
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v64P1EwATjdZXZqcfFNYNZXF6dOCiOp5hxTXPjyn+jQ=;
	b=pApR7MQVYjwVOZ5ENZuhSrIFeIehtRBx5a1YJcTaSp69f/ATxqUZdAGcKFjPqP0yBcUYb0
	7xPwZmuZH6day0S7ip307RZL4fqenMUyaYyaC706m5Fnv2L0L1PkxPT2syzeGN8gzt3ha/
	dIFbb6+fKA014v+CU65UGUKy9t6VGN4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v64P1EwATjdZXZqcfFNYNZXF6dOCiOp5hxTXPjyn+jQ=;
	b=lGN81QS9IMlfNHgIVAMwu8IKGAAUejJRNdq2kDCueQG0GxdlNAOwl36MEOwS+QZAlXB3/P
	JmVRNgCO+h3MimxZlUcEQYPKYWofb3d7QGYW2uUwYRI8/MQuS6fhYCXlXTFLln3bOARPkk
	ky2FS+6PJQbb4ztFCN5pG70xYtTD0Rw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5507F1342D
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7jwnOScOAGsJYwAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:58 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: qgroup: handle the transaction commit error during rescan
Date: Fri, 20 Nov 2026 19:38:35 +1030
Message-ID: <900cc1ec5feac55f401015f3fdadc242c0c6d275.1795165635.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1795165635.git.wqu@suse.com>
References: <cover.1795165635.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:helo,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

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

