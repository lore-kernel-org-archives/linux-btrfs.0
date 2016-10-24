Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52263 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932339AbcJXCn7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 23 Oct 2016 22:43:59 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 3/4] btrfs-progs: utils: Fix NULL pointer derefernces in string_is_numerical
Date: Mon, 24 Oct 2016 10:43:34 +0800
Message-Id: <20161024024335.6770-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
References: <20161024024335.6770-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In get_running_kernel_version() function, we directly pass return
pointer from strtok_r() to string_is_numberical().

Return pointer from strok_r() can be NULL, but string_is_numberical()
can't handle it and will cause NULL pointer derefernces.

Fix it by check if it's a NULL pointer first.

Reported-by: David Sterba <dsterba@suse.cz>
Resolves-Coverity-CID: 1374097
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/utils.c b/utils.c
index 3f54245..c135ac9 100644
--- a/utils.c
+++ b/utils.c
@@ -4015,6 +4015,8 @@ unsigned int get_unit_mode_from_arg(int *argc, char *argv[], int df_mode)
 
 int string_is_numerical(const char *str)
 {
+	if (!str)
+		return 0;
 	if (!(*str >= '0' && *str <= '9'))
 		return 0;
 	while (*str >= '0' && *str <= '9')
-- 
2.10.1



