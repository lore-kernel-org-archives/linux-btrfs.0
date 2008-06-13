From: Jeff Mahoney <jeffm@jeffreymahoney.com>
Subject: [patch 4/5] btrfs-progs: Add RPM spec file support
Date: Fri, 13 Jun 2008 16:09:10 -0400
Message-ID: <20080613201008.019338857@suse.com>
References: <20080613200906.180149089@suse.com>
Cc: Btrfs Development List <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch contains a spec file for building btrfs-progs into an RPM
 package. It will be automatically regenerated at ./configure time to
 contain the latest version number.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 btrfs-progs.spec    |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 btrfs-progs.spec.in |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.ac        |    2 -
 3 files changed, 133 insertions(+), 1 deletion(-)

--- /dev/null
+++ b/btrfs-progs.spec
@@ -0,0 +1,66 @@
+Name:		btrfs-progs
+BuildRequires:	autoconf automake e2fsprogs-devel
+Url:		http://oss.oracle.com/mercurial/mason/btrfs-progs-unstable
+Supplements:	filesystem(btrfs)
+Version:	0.15
+Release:	0
+Summary:	Btrfs File System Utilities
+License:	GPL v2 or later
+Group:		System/Filesystems
+AutoReqProv:	on
+Source:		%{name}-%{version}.tar.bz2
+BuildRoot:	%{_tmppath}/%{name}-%{version}-build
+
+%description
+This package includes utilities for creating, repairing, and tuning
+btrfs filesystems.
+
+%package -n libbtrfs
+Summary:	Btrfs Core Library
+Group:		System/Filessystems
+AutoReqProv:	on
+
+%description -n libbtrfs
+The core library for btrfs.
+
+%package -n libbtrfs-devel
+Summary:	Development files for libbtrfs
+Group:		System/Filesystems
+AutoReqProv:	on
+Requires:	libbtrfs = %version
+
+%description -n libbtrfs-devel
+Development files for libbtrfs.
+
+%debug_package
+%prep
+%setup -q -n btrfs-progs-%{version}
+
+%build
+autoreconf
+%define _exec_prefix /
+%configure
+make %{?jobs:-j %jobs}
+
+%install
+make install DESTDIR=${RPM_BUILD_ROOT}
+
+%files
+%defattr(-,root,root)
+%{_sbindir}/*
+
+%files -n libbtrfs
+%{_libdir}/libbtrfs.so
+%{_libdir}/libbtrfs-*.so
+
+%files -n libbtrfs-devel
+%{_includedir}/*
+%{_libdir}/libbtrfs.a
+%{_libdir}/libbtrfs.la
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+%changelog
+* Thu Jun 12 2008 - jeffm@suse.com
+- Initial packaging.
--- /dev/null
+++ b/btrfs-progs.spec.in
@@ -0,0 +1,66 @@
+Name:		btrfs-progs
+BuildRequires:	autoconf automake e2fsprogs-devel
+Url:		http://oss.oracle.com/mercurial/mason/btrfs-progs-unstable
+Supplements:	filesystem(btrfs)
+Version:	@VERSION@
+Release:	0
+Summary:	Btrfs File System Utilities
+License:	GPL v2 or later
+Group:		System/Filesystems
+AutoReqProv:	on
+Source:		%{name}-%{version}.tar.bz2
+BuildRoot:	%{_tmppath}/%{name}-%{version}-build
+
+%description
+This package includes utilities for creating, repairing, and tuning
+btrfs filesystems.
+
+%package -n libbtrfs
+Summary:	Btrfs Core Library
+Group:		System/Filessystems
+AutoReqProv:	on
+
+%description -n libbtrfs
+The core library for btrfs.
+
+%package -n libbtrfs-devel
+Summary:	Development files for libbtrfs
+Group:		System/Filesystems
+AutoReqProv:	on
+Requires:	libbtrfs = %version
+
+%description -n libbtrfs-devel
+Development files for libbtrfs.
+
+%debug_package
+%prep
+%setup -q -n btrfs-progs-%{version}
+
+%build
+autoreconf
+%define _exec_prefix /
+%configure
+make %{?jobs:-j %jobs}
+
+%install
+make install DESTDIR=${RPM_BUILD_ROOT}
+
+%files
+%defattr(-,root,root)
+%{_sbindir}/*
+
+%files -n libbtrfs
+%{_libdir}/libbtrfs.so
+%{_libdir}/libbtrfs-*.so
+
+%files -n libbtrfs-devel
+%{_includedir}/*
+%{_libdir}/libbtrfs.a
+%{_libdir}/libbtrfs.la
+
+%clean
+rm -rf $RPM_BUILD_ROOT
+
+%changelog
+* Thu Jun 12 2008 - jeffm@suse.com
+- Initial packaging.
--- a/configure.ac
+++ b/configure.ac
@@ -50,4 +50,4 @@ AC_SUBST(SPARSE)
 AC_OUTPUT(Makefile lib/Makefile lib/predef.h \
 	  src/Makefile src/test/Makefile src/mkfs/Makefile \
 	  src/convert/Makefile src/debug/Makefile src/fsck/Makefile \
-	  src/util/Makefile)
+	  src/util/Makefile btrfs-progs.spec)


