Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48690 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753747AbeCFTYS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 14:24:18 -0500
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v8 01/63] mac80211_hwsim: Use DEFINE_IDA
Date: Tue,  6 Mar 2018 11:23:11 -0800
Message-Id: <20180306192413.5499-2-willy@infradead.org>
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is preferred to opencoding an IDA_INIT.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7b6c3640a94f..8bffd6ebc03e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -253,7 +253,7 @@ static inline void hwsim_clear_chanctx_magic(struct ieee80211_chanctx_conf *c)
 
 static unsigned int hwsim_net_id;
 
-static struct ida hwsim_netgroup_ida = IDA_INIT;
+static DEFINE_IDA(hwsim_netgroup_ida);
 
 struct hwsim_net {
 	int netgroup;
-- 
2.16.1

