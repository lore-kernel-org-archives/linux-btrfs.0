Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55129 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2FPMic (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jun 2012 08:38:32 -0400
Received: by wibhn6 with SMTP id hn6so435356wib.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jun 2012 05:38:31 -0700 (PDT)
From: Andrei Popa <andrei.popa@i-neo.ro>
To: linux-btrfs@vger.kernel.org
Cc: Andrei Popa <andrei.popa@i-neo.ro>
Subject: [PATCH] Btrfs: Fix NOCOW file attribute
Date: Sat, 16 Jun 2012 15:37:11 +0300
Message-Id: <1339850232-25584-1-git-send-email-andrei.popa@i-neo.ro>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs doesn't honour correctly the NOCOW file attribute, this patch fixes this.
NOCOW per file support has been added in e2fsprogs-1.42.4

Andrei Popa (1):
  Btrfs: Fix NOCOW file attribute

 fs/btrfs/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.3.4

