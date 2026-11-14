Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794697431;
	b=tRWMnDe6hrbH6muPzm3bcwUse1MCxFOrXUuaCgux45cQnDJ6KZeygtZx9Rl2Ben1L00d
	 hvK5OypiH2I54ybOD7m56vSsnk7IVP1zoB+kk5/CEYYLGnhQvBSIvAvmsAPpLrFGfWeQx
	 Zoy8pP6Bs8SHUmZd7G7PhItw7xF6aeLefTHRa/dAVVc7et8iGE6zGleXd2RSKTkJn/qdU
	 JG7EOIQ+V001L1Fh6WV4cqBM68IH669zWMK1HTTRnCmwWKFkZp09N8yTF+ViZDqHNouZT
	 0YDmVte2g5IRtNkiSa39cuefS0wMGFMlt74latEmh0Yt3V7cEZSNeCQl763gxI9iQAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794697431;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Spam-Flag:
	 X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=4Fq6t3F3VdMo5FucFYbgS+xquj4wmDaEIbmrHxE2PSI=;
	b=DP5mYFUmRxadRedR77ABXBfBJBf/I+dckVM3fcLYA8AJbHMDBz1We75ArIqjxIhh5efd
	 oti9X8X+LSAdTlxfAPZk0br8eRnr+xSloNWMqc/92rRJP1Ot/pP7semvRUdZ6IJxF0+If
	 2oUtDIFeUsoDGRXQubcaWcVEj6+EpPfnU6oTac2suiWwTjbtYczB8+FhkSAO6JbREx9z7
	 U8kQTUoad1AzBTYfPt2iTj8PtD6IIe+f6FS4Tlbt1qU5aOW+fy84gZOeDNFpwpCIungz4
	 IimW1dxyNk8HnOsc+lKWVtLnnIj4GAGkH+9RrIIqQfiY5gfIhx5dpU8jmNcn+JilMuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jvYIIy+V;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jvYIIy+V;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A501E606A329
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A501E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jvYIIy+V;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=jvYIIy+V
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C032D1F460
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794697422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Fq6t3F3VdMo5FucFYbgS+xquj4wmDaEIbmrHxE2PSI=;
	b=jvYIIy+VRtZHGEls6uaxqXEVxef0oaJuP+nGIlpqb0yMP3PlF47Vat1F35aCCACqGavnDb
	ZVCF3nYpu5rFgqBc2rccNWs3ZES01PFsB6JmxPJaiokhe1dtAbLrpbF+Cuf8CWsbdRTiV4
	fP52tbILDoHCNHR/bvb12m9dD/y4jas=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794697422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Fq6t3F3VdMo5FucFYbgS+xquj4wmDaEIbmrHxE2PSI=;
	b=jvYIIy+VRtZHGEls6uaxqXEVxef0oaJuP+nGIlpqb0yMP3PlF47Vat1F35aCCACqGavnDb
	ZVCF3nYpu5rFgqBc2rccNWs3ZES01PFsB6JmxPJaiokhe1dtAbLrpbF+Cuf8CWsbdRTiV4
	fP52tbILDoHCNHR/bvb12m9dD/y4jas=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9ED4E13408
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Sn6dDcvo+Go0GAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2026 23:03:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: tests: fix false alerts on convert/017
Date: Sun, 15 Nov 2026 09:33:20 +1030
Message-ID: <35a869ce29c01758e3fc4fcde48fbda7266429f3.1794697359.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1794697359.git.wqu@suse.com>
References: <cover.1794697359.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.80

On github CI workers, the test convert/017 fails as the following:

 ERROR: failed to reserve 33554432 bytes for metadata chunk, largest available: 33488896 bytes
 ERROR: unable to create initial ctree: No space left on device
 WARNING: error during conversion, the original filesystem is not modified

The test case is verifying the behavior of converting an almost full
ext4, unfortunately the chunk layout is dependent on the ext4 fs, so
we do not reliable have enough metadata space for such case.

Instead of using convert_test_do_convert() which expects the convert run
to success, open-code the helper, and use "run_mayfail" instead, and
only continue checking if the convert succeeded.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 tests/convert-tests/017-fs-near-full/test.sh | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tests/convert-tests/017-fs-near-full/test.sh b/tests/convert-tests/017-fs-near-full/test.sh
index 92048f08d376..fa5073b1830e 100755
--- a/tests/convert-tests/017-fs-near-full/test.sh
+++ b/tests/convert-tests/017-fs-near-full/test.sh
@@ -27,6 +27,12 @@ done
 
 run_check_umount_test_dev
 
-# convert_test_do_convert() will call btrfs check, which should expose any
-# invalid inline extent with too large size
-convert_test_do_convert
+export BTRFS_PROGS_DEBUG_STRICT_CHUNK_ALIGNMENT=y
+# The e2mkfs may use extra space due to their default feature changes.
+# So the convert itself may fail due to lack of space.
+run_mayfail "$TOP/btrfs-convert" "$TEST_DEV"
+if [ $? -ne 0 ]; then
+	_not_run "Not enough space left for btrfs-convert"
+fi
+run_check "$TOP/btrfs" check "$TEST_DEV"
+run_check "$TOP/btrfs" inspect-internal dump-super -Ffa "$TEST_DEV"
-- 
2.56.0

