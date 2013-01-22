Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:58934 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3AVRWR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 12:22:17 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122172216.ODVC7113.eastrmfepo102.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 12:22:16 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 0/3] Btrfs-progs Add spec file template and script to create tarball
Date: Tue, 22 Jan 2013 12:22:03 -0500
Message-Id: <1358875326-28636-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series of patches adds an rpm spec file template for btrfs-progs and
a script to create an archive/tarball which includes an updated spec file.

The "optional" second patch adds make archive which executes do-archve.sh.

The "optional" third patch changes version.sh and btrfs-progs.spec.in
to handle future updates when the version changes.

Gene Czarcinski (3):
  Btrfs-progs Add rpm spec template and create tarball
  Btrfs-progs Add make archive
  Btrfs-progs Change rpm spec file to be handle version     This
    "optional" patch changes version.sh and the rpm spec file to    
    handle changes in the version and still work properly.  The
    "default"     version in version.sh is changed to VERSION and
    v="$VERSION".     The rpm spec file now update \$VERSION which will
    not change.     Signed-off-by: Gene Czarcinski <gene@czarc.net>

 Makefile            |  6 +++++-
 btrfs-progs.spec.in | 46 +++++++++++++++++++++++++++++++++++++++
 do-archive.sh       | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 version.sh          |  3 ++-
 4 files changed, 115 insertions(+), 2 deletions(-)
 create mode 100644 btrfs-progs.spec.in
 create mode 100644 do-archive.sh

-- 
1.8.1

