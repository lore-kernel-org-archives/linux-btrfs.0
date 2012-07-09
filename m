Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62743 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab2GIRCn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Jul 2012 13:02:43 -0400
Received: by lbbgm6 with SMTP id gm6so20424208lbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Jul 2012 10:02:41 -0700 (PDT)
From: Pierre Carrier <pierre@spotify.com>
To: linux-btrfs@vger.kernel.org
Cc: Pierre Carrier <pierre@spotify.com>
Subject: [PATCH 0/2] Support for small units in display
Date: Mon,  9 Jul 2012 17:02:25 +0000
Message-Id: <1341853347-11788-1-git-send-email-pierre@spotify.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Allow better inspection of sizes using an environment variable.

Not pretty, but convenient to determine the exact size of a filesystem,
eg when resizing an underlying partition or LUN.

Pierre Carrier (2):
  utils.c: fix sizes in B & malloc in pretty_sizes
  utils.c: offer to limit divisions in pretty_sizes

 utils.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

-- 
1.7.11.1

