Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:42609 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3AVRWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 12:22:18 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122172217.MAID21186.eastrmfepo203.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 12:22:17 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 3/3] Btrfs-progs Change rpm spec file to be handle version This "optional" patch changes version.sh and the rpm spec file to handle changes in the version and still work properly.  The "default" version in version.sh is changed to VERSION and v="$VERSION". The rpm spec file now update \$VERSION which will not change. Signed-off-by: Gene Czarcinski <gene@czarc.net>
Date: Tue, 22 Jan 2013 12:22:06 -0500
Message-Id: <1358875326-28636-4-git-send-email-gene@czarc.net>
In-Reply-To: <1358875326-28636-1-git-send-email-gene@czarc.net>
References: <1358875326-28636-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 btrfs-progs.spec.in | 2 +-
 version.sh          | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/btrfs-progs.spec.in b/btrfs-progs.spec.in
index b64e404..882efc7 100644
--- a/btrfs-progs.spec.in
+++ b/btrfs-progs.spec.in
@@ -22,7 +22,7 @@ check, modify and correct any inconsistencies in the btrfs filesystem.
 
 %prep
 %setup -q -c
-sed -i s/v0.20-rc1/%{real_version}/g $RPM_BUILD_DIR/%{name}-%{version}/version.sh
+sed -i s/\$VERSION/%{real_version}/g $RPM_BUILD_DIR/%{name}-%{version}/version.sh
 
 %build
 make CFLAGS="$RPM_OPT_FLAGS" %{?_smp_mflags}
diff --git a/version.sh b/version.sh
index b81040e..84513a3 100644
--- a/version.sh
+++ b/version.sh
@@ -6,7 +6,8 @@
 # Copyright 2008, Oracle
 # Released under the GNU GPLv2
  
-v="v0.20-rc1"
+VERSION="v0.20-rc1"
+v="$VERSION"
 
 which git &> /dev/null
 if [ $? == 0 -a -d .git ]; then
-- 
1.8.1

