Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from port-83-236-132-110.static.qsc.de ([83.236.132.110]:43192 "EHLO
        mail.daemons-point.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdIIGNt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 02:13:49 -0400
Received: from [192.168.178.22] (HSI-KBW-085-216-006-144.hsi.kabelbw.de [85.216.6.144])
        by mail.daemons-point.com (Postfix) with ESMTPSA id 97B6F20803
        for <linux-btrfs@vger.kernel.org>; Sat,  9 Sep 2017 06:13:36 +0000 (UTC)
Subject: PATCH - btrfs-progs-4.13: cmds-inspect-tree-stats.h: No such file or
 directory
From: Uli Heller <uli.heller@daemons-point.com>
To: linux-btrfs@vger.kernel.org
References: <8fab0623-c8ad-ade0-fde7-382742c801bf@daemons-point.com>
Message-ID: <ac7654b1-68b6-8793-db22-18eb238d0ca8@daemons-point.com>
Date: Sat, 9 Sep 2017 08:13:51 +0200
MIME-Version: 1.0
In-Reply-To: <8fab0623-c8ad-ade0-fde7-382742c801bf@daemons-point.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 From edc11bf1463e41f5c503655f67c3036bd952eb72 Mon Sep 17 00:00:00 2001
From: Uli Heller <uli.heller@daemons-point.com>
Date: Sat, 9 Sep 2017 08:02:51 +0200
Subject: [PATCH] Removed missing header file, fixes compilation error

---
  btrfs-calc-size.c | 1 -
  1 file changed, 1 deletion(-)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 1c5c61df..1ac7c785 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -19,7 +19,6 @@
  #include "volumes.h"
  #include "utils.h"
  #include "commands.h"
-#include "cmds-inspect-tree-stats.h"

  int main(int argc, char **argv)
  {
-- 
2.14.1

-- 
Uli Heller

daemons point Gesellschaft für Datenverarbeitung mbH
Zahn-Nopper-Straße 1-3, 70435 Stuttgart
Internet: www.daemons-point.com
Mobil: +49 17273 05646, Tel: +49 711 806708 0, Fax: +49 711 806708 19
mailto:uli.heller@daemons-point.com

