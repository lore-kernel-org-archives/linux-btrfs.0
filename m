Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:56862 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbdCBTxR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 14:53:17 -0500
Date: Thu, 2 Mar 2017 22:42:38 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add btrfs file entries
Message-ID: <20170302194237.GA6906@altlinux.org>
References: <20170215200259.GA1028@altlinux.org> <e5736c5a-1cef-58cb-a171-055e139e26e7@suse.com> <20170215225503.GA2947@altlinux.org> <20170228231250.GA10156@altlinux.org> <20170301145434.GD4662@twin.jikos.cz> <20170302114212.GK4662@suse.cz> <20170302130117.GA2208@altlinux.org> <20170302185946.GL4662@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170302185946.GL4662@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add file entries for btrfs header files.

Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
Acked-by: David Sterba <dsterba@suse.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0001835..04a758f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2904,6 +2904,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
 S:	Maintained
 F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
+F:	include/linux/btrfs*
+F:	include/uapi/linux/btrfs*
 
 BTTV VIDEO4LINUX DRIVER
 M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
-- 
ldv
