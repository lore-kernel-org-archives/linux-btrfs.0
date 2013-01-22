Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo203.cox.net ([68.230.241.218]:37348 "EHLO
	eastrmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3AVRWS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 12:22:18 -0500
Received: from eastrmimpo210 ([68.230.241.225]) by eastrmfepo203.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130122172217.MAFY21186.eastrmfepo203.cox.net@eastrmimpo210>
          for <linux-btrfs@vger.kernel.org>;
          Tue, 22 Jan 2013 12:22:17 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 1/3] Btrfs-progs Add rpm spec template and create tarball
Date: Tue, 22 Jan 2013 12:22:04 -0500
Message-Id: <1358875326-28636-2-git-send-email-gene@czarc.net>
In-Reply-To: <1358875326-28636-1-git-send-email-gene@czarc.net>
References: <1358875326-28636-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds a rpm spec file template for btrfs-progs.

The do-archive.sh script creates/updates the rpm spec file
and creates an archive of the current branch if the btrfs-progs
git repository does not have uncommitted changes.  The created
archive/tarball is of the form:
      btrfs-progs-git20130122.tar.gz
where the "version" is "git" appended with the date.  The "version"
is also plugged into the rpm spec file.  Additionally, the result of
      git describe --tags
is plugged into the rpm spec file so that version.sh will be
updated with the "current" version just like it would be
if created in the git repository.  See the comments in the
do-archive.sh file for additional information.
Signed-off-by: Gene Czarcinski <gene@czarc.net>
---
 btrfs-progs.spec.in | 46 +++++++++++++++++++++++++++++++++++++++
 do-archive.sh       | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 btrfs-progs.spec.in
 create mode 100644 do-archive.sh

diff --git a/btrfs-progs.spec.in b/btrfs-progs.spec.in
new file mode 100644
index 0000000..b64e404
--- /dev/null
+++ b/btrfs-progs.spec.in
@@ -0,0 +1,46 @@
+Name:		btrfs-progs
+Version:	@VERSION@
+Release:	0
+Epoch:		1
+# Use epoch to override distribution packages
+%define	real_version @REALVERSION@
+URL:            http://btrfs.wiki.kernel.org/index.php/Main_Page
+Summary:	Btrfs File System Utilities: %{real_version}
+License:	GPL v2 or later
+Group:          System Environment/Base
+
+Source0:	%{name}-%{version}.tar.gz
+
+BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
+BuildRequires:  e2fsprogs-devel, libuuid-devel, zlib-devel, libacl-devel, libblkid-devel
+
+%define _root_sbindir /sbin
+
+%description
+The btrfs-progs package provides all the userpsace programs needed to create,
+check, modify and correct any inconsistencies in the btrfs filesystem.
+
+%prep
+%setup -q -c
+sed -i s/v0.20-rc1/%{real_version}/g $RPM_BUILD_DIR/%{name}-%{version}/version.sh
+
+%build
+make CFLAGS="$RPM_OPT_FLAGS" %{?_smp_mflags}
+
+%install
+rm -rf $RPM_BUILD_ROOT
+make mandir=%{_mandir} bindir=%{_sbindir} install DESTDIR=$RPM_BUILD_ROOT
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+%files
+%defattr(-,root,root)
+%doc COPYING INSTALL
+%{_sbindir}/*
+%{_mandir}/man8/*
+
+%changelog
+* Mon Jan 22 2013 Gene Czarcinski <gene@czarc.net>
+- Initial generic rpm spec file.
+- note that much of this is from the Fedora 18 spec file.
diff --git a/do-archive.sh b/do-archive.sh
new file mode 100644
index 0000000..640c824
--- /dev/null
+++ b/do-archive.sh
@@ -0,0 +1,62 @@
+#!/bin/bash
+#
+# update btrfs-progs.spec and create archive
+#
+# Released under the GNU GPLv2
+# Tue 22 Jan 2013 10:21:07 EST GC
+#
+# The purpose of the script is to update a btrfs rpm spec file
+# and create an archive (tarball) with the spec file included.
+#
+# This tarball can be used as any other btrfs-progs tarball
+# would be used as well as to be used to create a binary
+# rpm with the following with the following examples:
+#
+#    $ rpmbuild -ts btrfs-progs-git20130121.tar.gz
+#    $ rpm -ivh SRPMS/btrfs-progs-git20130121.src.rpm
+#    $ rpmbuild -ba --clean btrfs-progs-git20130121/btrfs-progs.spec
+# or
+#    $ rpmbuild -ts btrfs-progs-git20130121.tar.gz
+#    $ mock SRPMS/btrfs-progs-git20130121.src.rpm
+#
+# Portions of version.h are included (duplicated) here.
+# Spec file creation and archive creation are kept together
+# to ensure consistency as possible.
+
+VERSION=`date "+%Y%m%d"`
+VERSION="git$VERSION"
+
+which git &> /dev/null
+if [ $? == 0 -a -d .git ]; then
+	if ! tag=`git describe --tags 2>/dev/null`; then
+		echo "error getting tags, exiting do-archive-sh"
+		exit 1
+	fi
+
+        # Are there uncommitted changes?
+        unmerged=`git update-index --refresh --unmerged`
+	if [ -n "$unmerged" ]; then
+	    echo "$unmerged"
+            echo "uncommitted changes exist, exiting do-archive-sh"
+	    exit 1
+        fi
+else
+	echo "no git or not git repository, exiting do-archive-sh"
+	exit 1
+fi
+
+if [ -e "btrfs-progs.spec.in" ]; then
+	sed -e s/@VERSION@/$VERSION/g \
+		-e s/@REALVERSION@/$tag/g \
+		<btrfs-progs.spec.in >btrfs-progs.spec
+fi
+
+git archive --format=tar -o btrfs-progs-$VERSION.tar HEAD
+if [ -e "btrfs-progs.spec" ]; then
+	tar --owner=root --group=root -rf \
+		btrfs-progs-$VERSION.tar btrfs-progs.spec
+fi
+rm -f btrfs-progs-$VERSION.tar.gz
+gzip -9 btrfs-progs-$VERSION.tar
+echo "btrfs-progs-$VERSION.tar.gz created"
+exit 0
-- 
1.8.1

