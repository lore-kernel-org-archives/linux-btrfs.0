Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48127 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbbK3Q2w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 11:28:52 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 32A86AAB6
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Nov 2015 16:28:51 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 0/2] Add more sys_array error handling
Date: Mon, 30 Nov 2015 17:27:02 +0100
Message-Id: <cover.1448900173.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fix for Vegard Nossum's report [1]. I found an older report in our bugzilla, so
there goes also Jiri's reported-by.

[1] http://article.gmane.org/gmane.comp.file-systems.btrfs/50230

David Sterba (2):
  btrfs: handle invalid num_stripes in sys_array
  btrfs: verbose error when we find an unexpected item in sys_array

 fs/btrfs/volumes.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
