Received: from mail.burntcomma.com (mail2.burntcomma.com [217.169.27.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E4C3AE1AA
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Mar 2026 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.169.27.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276592; cv=none; b=my3/QkpFdCLNON7KXjuo0h4r7jjuxS9vpsWMouZVKPpnKEP+LxLOAWu9aLG8GAeaRYtBbESRmmesI74TEdqFBb2Z1HOY5+7/0th09bPFbwFnJjNcHgwDCwTvRjaAFHbpZOqmiPgLYOfyGHoet7Q5tDltmYF1bH38eyPGgvFzAaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276592; c=relaxed/simple;
	bh=SitwpT8FHeK5PyWODzqz4c5S7UzkQCw7j0QMyWVJQ/M=;
	h=From:To:Cc:Subject:Date:Message-ID:Mime-Version; b=P7Gb2pVrtiZhSmh8GGiPloNOAvkbed4mhrrGoGiyoyeCQGY/LWAnyjHyXAr4DhP/DmkzwkCXRapKikmPPkempMUpvhzM7C3USYoRmbx5p6XOM1EOajcMi5L3MIh4bIQj7iTnjWyurXwXj1uyL2nTWh095Sc3ynErCl488PEHrAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com; spf=pass smtp.mailfrom=harmstone.com; dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b=3eziWyjt; arc=none smtp.client-ip=217.169.27.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=harmstone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=harmstone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=harmstone.com header.i=@harmstone.com header.b="3eziWyjt"
Received: from beren (beren.burntcomma.com [IPv6:2a02:8012:8cf0:0:ce28:aaff:fe0d:6db2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.burntcomma.com (Postfix) with ESMTPSA id 2C985313E64;
	Mon, 23 Mar 2026 14:36:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmstone.com;
	s=mail; t=1774276582;
	bh=G8XvvdzW2V073scCFv3rskad751z8XJYuGWwI8fpVm0=;
	h=From:To:Cc:Subject:Date;
	b=3eziWyjtqKNtyrEY0vSOtgbnAWseo4+WxCYs63UsLEpo0tVj1AXU/J7KMa9NLzmxk
	 Xt4PejZXLARLcUOJLfIRV1PHrjZZCFfSxMpKd+K3h8Zer9S7PI5y3QHUGJfgur71FG
	 IYHRQ30BqkA/Wmou+Up/IgCJeNoWuqbT4FPsMNWI=
From: Mark Harmstone <mark@harmstone.com>
To: linux-btrfs@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>
Subject: [PATCH] btrfs: fix bytes_may_use leak in move_existing_remap()
Date: Mon, 23 Mar 2026 14:36:14 +0000
Message-ID: <20260323143618.119698-1-mark@harmstone.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit

If the call to btrfs_reserve_extent() in move_existing_remap() returns a
smaller extent than we asked for, currently we're not undoing the
bytes_may_use change that we made. Fix this by calling
btrfs_space_info_update_bytes_may_use() again for the difference.

Signed-off-by: Mark Harmstone <mark@harmstone.com>
Fixes: bbea42dfb91f ("btrfs: move existing remaps before relocating block group")
---
 fs/btrfs/relocation.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1c42c5180bddd5..3d1756b6116246 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4174,6 +4174,12 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 		return ret;
 	}
 
+	if (ins.offset < length) {
+		spin_lock(&sinfo->lock);
+		btrfs_space_info_update_bytes_may_use(sinfo, ins.offset - length);
+		spin_unlock(&sinfo->lock);
+	}
+
 	dest_addr = ins.objectid;
 	dest_length = ins.offset;
 
-- 
2.52.0

