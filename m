Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:35169 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbaHNTgw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:36:52 -0400
From: Nils Steinger <nst@voidptr.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <nst@voidptr.de>, David Sterba <dsterba@suse.cz>
Subject: [PATCH v3] btrfs-progs: Add uninstall targets to Makefiles.
Date: Thu, 14 Aug 2014 21:36:47 +0200
Message-Id: <1408045008-13399-1-git-send-email-nst@voidptr.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I finally got around to applying David Sterba's suggestions about a
month ago, but when I sent my updated patch to the mailing list,
vger.kernel.org accepted and then silently dropped my mail, so I shelved
the patch for a while.
My new `filesystem df` patch just got through, so here's another try for
the Makefile patch.

Nils Steinger (1):
  btrfs-progs: Add uninstall targets to Makefiles.

 Documentation/Makefile | 4 ++++
 Makefile               | 7 +++++++
 2 files changed, 11 insertions(+)

-- 
1.9.1

