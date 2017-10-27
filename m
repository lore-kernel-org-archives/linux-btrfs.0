Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-02.prod.phx3.secureserver.net ([184.168.200.140]:48204
        "EHLO p3nlsmtpcp01-02.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751068AbdJ0GBg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 02:01:36 -0400
Received: from [103.215.170.1] (port=1703 helo=giis.co.in)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.88)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1e7xh4-00031X-71
        for linux-btrfs@vger.kernel.org; Thu, 26 Oct 2017 23:00:34 -0700
Date: Fri, 27 Oct 2017 11:30:24 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/1] btrfs-progs: tests/common: Display warning only after
 searching for btrfs kernel module
Message-ID: <20171027060024.GA3847@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <lakshmipathi.g@giis.co.in>
---
 tests/common | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/common b/tests/common
index eb525a4..773b1e5 100644
--- a/tests/common
+++ b/tests/common
@@ -428,8 +428,12 @@ run_check_umount_test_dev()
 check_kernel_support()
 {
 	if ! grep -iq 'btrfs' /proc/filesystems; then
-		echo "WARNING: btrfs filesystem not listed in /proc/filesystems, some tests might fail"
-		return 1
+		run_check $SUDO_HELPER modprobe btrfs
+			if ! grep -iq 'btrfs' /proc/filesystems; then
+				echo "WARNING: btrfs filesystem not listed in \
+				 /proc/filesystems, some tests might fail"
+				return 1
+			fi
 	fi
 	return 0
 }
-- 
2.7.4

