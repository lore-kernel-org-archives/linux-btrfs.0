Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59339 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaANVoL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 16:44:11 -0500
Received: by mail-pa0-f42.google.com with SMTP id kl14so210340pab.29
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 13:44:11 -0800 (PST)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Mitchel Humpherys <mitch.special@gmail.com>
Subject: [PATCH] Minor grammar nitpick
Date: Tue, 14 Jan 2014 13:44:02 -0800
Message-Id: <1389735843-11685-1-git-send-email-mitch.special@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes the word `to' from the `Can't access to X' error
messages.

Mitchel Humpherys (1):
  btrfs-progs: fix minor grammar issues

 cmds-balance.c    | 10 +++++-----
 cmds-device.c     |  4 ++--
 cmds-filesystem.c |  6 +++---
 cmds-scrub.c      |  2 +-
 cmds-subvolume.c  | 10 +++++-----
 5 files changed, 16 insertions(+), 16 deletions(-)

-- 
Mitch
