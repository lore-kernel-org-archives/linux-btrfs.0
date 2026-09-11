Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCF537B3FE
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789105135; cv=none; b=s3Jq9WBsq3XLj/7vk9ZHlb6qGygsrl44qHMejmquGQmguciCidS36+whfouTwMF6m4X8qVPKL7gEUYMQ/ATSoQusE/SZS8BduY43w0q5zLqsPBSKoshv8h/YHx3v+7o1dJxVLXbHsdSp1CN2LwQiR/5mgMXLpexEEueLCpqAkjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789105135; c=relaxed/simple;
	bh=zna6j7CsRDirptVYAEYfeeddtudbe12LLS8XjP87u9g=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1sp5aAoYLXMPulqHW7AL3VPpmLelYTwntJ9yTHNAPvyzfsr8fnL3Thl2rF5kPLp9IqjLCj11RxazuZYTVECW//Y9+ZN61K/5amifwazQ4b39xh372VKQ8pX0nJWP+idTbyTiqxzGQP20+x+r/a1RUlap9STpm1V2+pWr61boZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XpKdf67Y; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NYK2JGdD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XpKdf67Y";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NYK2JGdD"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B39AF1FE05
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789105127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1CXYinG9k/GRUJM9yMCp6lGq7QKrQ8Em1NQiZ0BRkT0=;
	b=XpKdf67Y/VGvZiiVLheb7qC7Fn5TFcC3ThAV6ns+zpHIYztLDf4y9ECUILHpHlnmPw83yX
	YTViUIBp/fp7zzdKuhDktar4u6ZoNoDmhXP1G8J8kyOPtulOVr2HhXnwcqoYW2Drx3fZc0
	v4fcNDK4e5ZBEFkNH35Q0fYPcP9A41k=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789105123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1CXYinG9k/GRUJM9yMCp6lGq7QKrQ8Em1NQiZ0BRkT0=;
	b=NYK2JGdDvEEWsy18FSvuWQnFsrw3DEZKkZbMrEist61VS6Sga2KMHwFglZVfzEYrC3Lu+t
	yUk1xxSCIE9MIM1yM6ydxiPrn5SZKROkiHIrb8OzouPoJWoY5Yf+J3P2FGFalHZkmV0S0v
	0NH/lH/Wu6d79PDSRH40ZmDVx8b38hI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7378E13794
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yIIQCeKTo2rPWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2026 05:38:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix the wrong direction for BTRFS_IOC_DEVICES_READY
Date: Fri, 11 Sep 2026 15:08:16 +0930
Message-ID: <8c2bc99a8adc8aae5ca0e65bd003cfe29c9771b6.1789104905.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789104905.git.wqu@suse.com>
References: <cover.1789104905.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

For that ioctl, userspace is writing btrfs_ioctl_vol_args, so we should
use _IOW(), not _IOR().

All other callsites using btrfs_ioctl_vol_args structure are all using
_IOW() already.

Fixes: 02db0844beff ("Btrfs: add DEVICE_READY ioctl")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 include/uapi/linux/btrfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 0a13baf3d8d1..b5e488a5cf75 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -1211,7 +1211,7 @@ struct btrfs_ioctl_get_csums_args {
 #define BTRFS_IOC_SET_RECEIVED_SUBVOL _IOWR(BTRFS_IOCTL_MAGIC, 37, \
 				struct btrfs_ioctl_received_subvol_args)
 #define BTRFS_IOC_SEND _IOW(BTRFS_IOCTL_MAGIC, 38, struct btrfs_ioctl_send_args)
-#define BTRFS_IOC_DEVICES_READY _IOR(BTRFS_IOCTL_MAGIC, 39, \
+#define BTRFS_IOC_DEVICES_READY _IOW(BTRFS_IOCTL_MAGIC, 39, \
 				     struct btrfs_ioctl_vol_args)
 #define BTRFS_IOC_QUOTA_CTL _IOWR(BTRFS_IOCTL_MAGIC, 40, \
 			       struct btrfs_ioctl_quota_ctl_args)
-- 
2.55.0

