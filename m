Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34693 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbcB1VMR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 16:12:17 -0500
Received: by mail-wm0-f47.google.com with SMTP id p65so45399569wmp.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 13:12:16 -0800 (PST)
From: Alexander Fougner <fougner89@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Fougner <fougner89@gmail.com>
Subject: [PATCH] btrfs-progs: docs: add note about resizing to max after device replace
Date: Sun, 28 Feb 2016 22:11:54 +0100
Message-Id: <1456693914-31899-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Alexander Fougner <fougner89@gmail.com>
---
 Documentation/btrfs-replace.asciidoc | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/btrfs-replace.asciidoc b/Documentation/btrfs-replace.asciidoc
index 5a14a40..61ab306 100644
--- a/Documentation/btrfs-replace.asciidoc
+++ b/Documentation/btrfs-replace.asciidoc
@@ -32,6 +32,9 @@ of the filesystem which is mounted at <path>, otherwise is is
 the path to the source device. If the source device is disconnected,
 from the system, you have to use the devid parameter format.
 The <targetdev> needs to be same size or larger than the <srcdev>.
+Note that the filesystem has to be resized to fully take advantage of a
+larger target device, this can be achieved with
+`btrfs filesystem resize <devid>:max /path`.
 +
 `Options`
 +
-- 
2.7.2

