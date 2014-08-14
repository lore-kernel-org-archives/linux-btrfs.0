Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:35434 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbaHNVN6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 17:13:58 -0400
From: Nils Steinger <nst@voidptr.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <nst@voidptr.de>
Subject: [PATCH v2] Options to set fixed unit for `filesystem df`
Date: Thu, 14 Aug 2014 23:13:37 +0200
Message-Id: <1408050818-17184-1-git-send-email-nst@voidptr.de>
In-Reply-To: <1408044261-11234-1-git-send-email-nst@voidptr.de>
References: <1408044261-11234-1-git-send-email-nst@voidptr.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I forgot to add the new options to man page for btrfs-filesystem.
While adding them, I also noticed that the man page contained a "[<path>...]"
placeholder even though the code for df only accepts a single path, so I
removed the placeholder.

Nils Steinger (1):
  Add options to use a fixed unit for `filesystem df` instead of
    determining it automatically.

 Documentation/btrfs-filesystem.txt | 14 ++++++++-
 cmds-filesystem.c                  | 62 +++++++++++++++++++++++++++++++++-----
 utils.c                            | 30 ++++++++++++++++++
 utils.h                            |  8 +++++
 4 files changed, 106 insertions(+), 8 deletions(-)

-- 
1.9.1

