Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbaKGRGS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 12:06:18 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id D63BCAC89
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Nov 2014 17:06:16 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 0/5] Btrfs-progs updates to build
Date: Fri,  7 Nov 2014 18:06:16 +0100
Message-Id: <cover.1415379676.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've managed to break build of snapper two times now, a new make rule
'test-build' should help us to check the build. Static build is not required to
pass due to dependency on static libs that may not be widely available.

David Sterba (5):
  btrfs-progs: build, add basic build test for library
  btrfs-progs: build, add make target for a build test
  btrfs-progs: build, gather utilities that are not built by default
  btrfs-progs: build, update the clean rule
  btrfs-progs: update .gitignore

 .gitignore     |  4 ++++
 Makefile       | 28 ++++++++++++++++++++----
 library-test.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 97 insertions(+), 4 deletions(-)
 create mode 100644 library-test.c

-- 
1.8.4.5

