Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:39483 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbaFTTzg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 15:55:36 -0400
From: Nils Steinger <git@n-st.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <git@n-st.de>
Subject: [PATCH] btrfs-progs: Add uninstall targets to Makefiles
Date: Fri, 20 Jun 2014 21:48:04 +0200
Message-Id: <1403293685-23536-1-git-send-email-git@n-st.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I compiled and installed the btrfs-progs from the git repo on several systems,
but later decided to switch back to the version from Debian's package
repository.
The Makefile did not contain an 'uninstall' target to complement 'install', so
I created one that reverses all changes made by 'install' (both in the main and
Documentation Makefiles).

Nils Steinger (1):
  btrfs-progs: Add uninstall targets to Makefiles.

 Documentation/Makefile | 4 ++++
 Makefile               | 9 +++++++++
 2 files changed, 13 insertions(+)

-- 
1.9.1

