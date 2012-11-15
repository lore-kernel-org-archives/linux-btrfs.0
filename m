Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46286 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767666Ab2KOMEt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 07:04:49 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so1032689pad.19
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 04:04:48 -0800 (PST)
Message-ID: <50A4DA55.4050105@gmail.com>
Date: Thu, 15 Nov 2012 20:04:37 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: remove unnecessary assignment in btrfs-map-logical.c
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The info_file is set to stdout by default, and we donot need to
reassign it to stdout if it's not changed to other values.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 btrfs-map-logical.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index fa4fb3f..2ecaabd 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -187,7 +187,6 @@ int main(int ac, char **av)
 				close(out_fd);
 				goto close;
 			}
-			info_file = stdout;
 		}
 	}

-- 
1.7.5.4
