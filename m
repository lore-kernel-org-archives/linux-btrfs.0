Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:37809 "EHLO
        smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756583AbdACL7C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 06:59:02 -0500
Received: from [212.54.42.115] (helo=lsmtp1.tb.mail.iss.as9143.net)
        by smtpq1.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cONk2-0003vg-Mc
        for linux-btrfs@vger.kernel.org; Tue, 03 Jan 2017 12:58:58 +0100
Received: from dhcp-077-251-197-105.chello.nl ([77.251.197.105] helo=webminal.org)
        by lsmtp1.tb.mail.iss.as9143.net with esmtp (Exim 4.86_2)
        (envelope-from <laks@webminal.org>)
        id 1cONjx-0006Ak-JU
        for linux-btrfs@vger.kernel.org; Tue, 03 Jan 2017 12:58:58 +0100
Received: from localhost.localdomain (fedori [127.0.0.1])
        by webminal.org (8.14.4/8.14.4) with ESMTP id v03BwOkT004407
        for <linux-btrfs@vger.kernel.org>; Tue, 3 Jan 2017 12:58:34 +0100
Received: (from laks@localhost)
        by localhost.localdomain (8.14.4/8.14.4/Submit) id v03BwDVR004161
        for linux-btrfs@vger.kernel.org; Tue, 3 Jan 2017 12:58:13 +0100
Date: Tue, 3 Jan 2017 12:58:13 +0100
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: btrfs-debugfs: Display usage hint with no
 arguments
Message-ID: <20170103115813.GA3228@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
---
 btrfs-debugfs | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/btrfs-debugfs b/btrfs-debugfs
index dfb8853..70419fa 100755
--- a/btrfs-debugfs
+++ b/btrfs-debugfs
@@ -392,7 +392,9 @@ parser.add_argument('-f', '--file', action='store_const', const=1, help='get fil
 
 args = parser.parse_args()
 
-if args.block_group:
+if not (args.block_group or args.file):
+    print "No arguments passed. Type 'btrfs-debugfs -h' for usage."
+elif args.block_group:
     for i in args.path[0:]:
         print_block_groups(i)
 elif args.file:
-- 
2.7.4

