Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:58444
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751124AbdFVH67 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 03:58:59 -0400
Date: Thu, 22 Jun 2017 13:27:53 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH v2] btrfs-progs: Fix 'btrfs device stats --check' cli option
Message-ID: <20170622075753.GA27046@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bug 194961 - btrfs device stats --check <folder> does not work
https://bugzilla.kernel.org/show_bug.cgi?id=194961

Reported-by: Tomas Thiemel<thiemel@centrum.cz>
Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 cmds-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-device.c b/cmds-device.c
index 5e016a7..4337eb2 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -400,6 +400,7 @@ static int cmd_device_stats(int argc, char **argv)
 	while (1) {
 		int c;
 		static const struct option long_options[] = {
+			{"check", no_argument, NULL, 'c'},
 			{"reset", no_argument, NULL, 'z'},
 			{NULL, 0, NULL, 0}
 		};
-- 
2.7.4

