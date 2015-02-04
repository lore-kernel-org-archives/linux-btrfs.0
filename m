Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966247AbbBDP4u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Feb 2015 10:56:50 -0500
Date: Wed, 4 Feb 2015 16:56:48 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 3.19-rc1
Message-ID: <20150204155648.GG24227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is a heads-up pre-release that should let the distro people test
the reworked build system, switched to autoconf.

However there were some problems [1] found so we have to fix them first
and rc2 should be ready for wider testing in distros.  The other changes
are non-intrusive so it's basically 3.18.2 and should be safe as a
replacement for general use.

[1] http://news.gmane.org/gmane.comp.file-systems.btrfs

Changes:
* clean build in checkout requires
  ./autogen.sh
  ./configure
  make
* build from tarball may skip the autogen step
* missing build dependencies are caught by configure
* optional features during build:
  --disable-documentation -- ported existing makefile feature
  --disable-backtrace -- dtto
  --disable-convert -- optional build of convert due to external dependencies

Shortlog, as not all changes went through the mailinglist:

David Sterba (18):
      btrfs-progs: build, make build test work again
      btrfs-progs: build, clean all generated files
      btrfs-progs: build, use autoconf to detect RM
      btrfs-progs: build, make autogen.sh work on older systems
      btrfs-progs: build more utilities by default
      btrfs-progs: add bash completion script
      btrfs-progs: drop old fi balance syntax from help
      btrfs-progs: build, fix rules to clean temporary files in docs
      btrfs-progs: autoconf: generate documentation makefile as well
      btrfs-progs: autoconf: use variable substitutions in doc makefile
      btrfs-progs: build, fix version macro name
      btrfs-progs: autoconf: detect tools to build docs
      btrfs-progs: autoconf: make btrfs-convert build optional
      btrfs-progs: autoconf: print summary about features
      btrfs-progs: autoconf: check if backtrace is really supported
      btrfs-progs: autoconf: check btrfs-convert dependencies
      btrfs-progs: qgroups, adjust help text
      Btrfs progs v3.19-rc1

Karel Zak (10):
      btrfs-progs: autoconf: add ./configure script
      btrfs-progs: autoconf: use config.h
      btrfs-progs: autoconf: use standard PACKAGE_* macros
      btrfs-progs: autoconf: use ./configure to generate version.h
      btrfs-progs: autoconf: check for build programs in ./configure
      btrfs-progs: autoconf: use paths and $*_LIBS from ./configure
      btrfs-progs: autoconf: cleanup compilation flags usage
      btrfs-progs: autoconf: clean generated files, make version.h stuff more robust
      btrfs-progs: autoconf: add --disable-backtrace
      btrfs-progs: autoconf: add --disable-documentation

Qu Wenruo (6):
      btrfs-progs: Record orphan data extent ref to corresponding root.
      btrfs-progs: Add btrfs_get_extent() and btrfs_punch_hole().
      btrfs-progs: Record and report every file extent hole.
      btrfs-progs: Add repair and report function for orphan file extent.
      btrfs-progs: Add repair function for discount file extent hole.
      btrfs-progs: read_tree_block() and read_node_slot() cleanup.
