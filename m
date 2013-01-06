Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:56846 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab3AFPcq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 10:32:46 -0500
Received: by mail-bk0-f45.google.com with SMTP id jk13so7872096bkc.4
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 07:32:45 -0800 (PST)
From: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Florian Albrechtskirchinger <falbrechtskirchinger@gmail.com>
Subject: [PATCH] Btrfs-progs: add UUID switches to mkfs and convert
Date: Sun,  6 Jan 2013 16:32:10 +0100
Message-Id: <1357486331-4615-1-git-send-email-falbrechtskirchinger@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this patch adds UUID switches to mkfs.btrfs and btrfs-convert to specify a UUID during filesystem creation or conversion.
The mkfs.btrfs ones are self-explanatory. btrfs-convert gets two additional convenience variants: -U new and -U copy. The former generates a random UUID which is the default behavior, the latter copies the UUID from the ext2fs to be converted.

Cheers,
Flo

Florian Albrechtskirchinger (1):
  Btrfs-progs: add UUID switches to mkfs and convert

 convert.c           | 48 ++++++++++++++++++++++++++++++++++++++++--------
 man/mkfs.btrfs.8.in |  4 ++++
 mkfs.c              | 20 ++++++++++++++++++--
 utils.c             |  6 +++---
 utils.h             |  4 ++--
 5 files changed, 67 insertions(+), 15 deletions(-)

-- 
1.8.0.3

