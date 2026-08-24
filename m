Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6166826E71E
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546088; cv=none; b=UficJUnXOK52nJZDNCu3YewKyru9wGlcEuRrj8eGmxuX71+lxc9cvq6GmXh8g84DWC8gPxtecsfd42geEIYxnjmHlikeZmQi2Nqu3rhrfqOAJenp9F2BMhnQ4D3bhZi0RNw1JmUA8BiDokSaByYXlvjBNbcDAHBy7JIwa6tdniI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546088; c=relaxed/simple;
	bh=40yPAJS6UurZKks/HbCVTQ4F+Tbo4Y5yDYFwRnW5LYw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO9buUaUnfLCnGe4aglswShBymezsEp4aLGiGMaJTEWY5oHMt1KDRJ4Ot+qXN3yoDX+CnQUuyfMPNFZzkdWxukotE5568Cmj7LBR8aSIGabvWOfJMYohwhN2dcznGtFF7denSudkJEUYulZrolv5Np3QlojSD1wb5pZ3lcCzXsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GiFC5U+B; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jTs4yhjb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GiFC5U+B";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jTs4yhjb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9A6B3E4A
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mw3EzVMYAO4NirXhi9t4D83kzNlLiXOmFDGpvAVaDzM=;
	b=GiFC5U+BN0FhM2uz8O4s2HWeLLYoJOgzBMvO/dNL0XyWg0DjGbuffvMrvElwnLVPY+VZHN
	sTG+awB/V7ghdLsW98KvqHTnnohqFgiyhUWkBAEewijuPZXSSnntZKqc2/ZKyXDyMM1tkj
	Y/qoYIT+/0b+UVdtHdJSnUS5jfjh7oM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546071; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mw3EzVMYAO4NirXhi9t4D83kzNlLiXOmFDGpvAVaDzM=;
	b=jTs4yhjbIexdoQMChGF6eDsHzd9mInYLOxAAaHbe7yH3mxjfxroVdNgk9ThhaWNna0AmEq
	jeTXfN2HMoKpCJjWotm3SRC+PEHRejrjCv8nQgIo5ZILEs7qu3LS7QmUYDyJENIft0hnCU
	kltjfDK460z6jtkHAuwkpci6BC+Z4EA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A1181333B
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CxqEdbJi2p1SAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/4] btrfs: dev-replace: concentrate all messages into btrfs_dev_replace_finishing()
Date: Mon, 24 Aug 2026 14:04:06 +0930
Message-ID: <4f0eb6d4a30f62d76ffd08af6031a27c5c58f686.1787545216.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1787545216.git.wqu@suse.com>
References: <cover.1787545216.git.wqu@suse.com>
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
X-Spam-Score: -2.80
X-Spam-Level: 

Currently we have 4 different messages when a dev-replace finished:

- "dev_replace from %s (devid %llu) to %s finished"
- "dev_replace from %s (devid %llu) to %s failed"
  These messages are from btrfs_dev_replace_finishing().

- "dev_replace from %s (devid %llu) to %s canceled"
  This message is from btrfs_dev_replace_cancel().

  But btrfs_dev_replace_cancel() itself doesn't immediately finish the
  running replace, but only increases the cancel request, and wait for
  the running one to finish.

  Furthermore, to avoid double messages btrfs_dev_replace_finishing() is
  checking -ECANCELED, making the handling a little more complex.

- "suspended dev_replace from %s (devid %llu) to %s canceled"
  This is a special one, suspended replace means it's already not
  running, thus will not hit btrfs_dev_replace_finishing().
  For this call site, we have to manually output the message.

Concentrate the first 3 messages into btrfs_dev_replace_finishing(),
which makes the message output in btrfs_dev_replace_finishing() a little
simpler.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/dev-replace.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index a0bfc4e597a2..be4031a6ce1d 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -946,7 +946,12 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
 								src_device,
 								tgt_device);
 	} else {
-		if (scrub_ret != -ECANCELED)
+		if (scrub_ret == -ECANCELED)
+			btrfs_info(fs_info,
+				"dev_replace from %s (devid %llu) to %s canceled",
+				btrfs_dev_name(src_device), src_device->devid,
+				btrfs_dev_name(tgt_device));
+		else
 			btrfs_err(fs_info,
 				 "dev_replace from %s (devid %llu) to %s failed %d",
 				 btrfs_dev_name(src_device),
@@ -1112,19 +1117,10 @@ int btrfs_dev_replace_cancel(struct btrfs_fs_info *fs_info)
 		src_device = dev_replace->srcdev;
 		up_write(&dev_replace->rwsem);
 		ret = btrfs_scrub_cancel(fs_info);
-		if (ret < 0) {
+		if (ret < 0)
 			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NOT_STARTED;
-		} else {
+		else
 			result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_ERROR;
-			/*
-			 * btrfs_dev_replace_finishing() will handle the
-			 * cleanup part
-			 */
-			btrfs_info(fs_info,
-				"dev_replace from %s (devid %llu) to %s canceled",
-				btrfs_dev_name(src_device), src_device->devid,
-				btrfs_dev_name(tgt_device));
-		}
 		break;
 	case BTRFS_IOCTL_DEV_REPLACE_STATE_SUSPENDED:
 		/*
-- 
2.55.0

