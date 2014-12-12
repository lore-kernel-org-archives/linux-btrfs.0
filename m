Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966556AbaLLMfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:35:48 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCZlMh018278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:35:47 -0500
Received: from x2.net.home (ovpn-113-55.phx2.redhat.com [10.3.113.55])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCZk1k005917
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:35:47 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-prog: improve build-system by autoconf
Date: Fri, 12 Dec 2014 13:35:14 +0100
Message-Id: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is first step to make btrfs-progs build system more conventional
for userspace users and developers. All is implemented by small incremental
patches to keep things review-able.

The Makefile targets and rules are no changed, things like V=1 (verbose), C=1
(sparse) static builds, etc. still work as expected. All the changes are mostly
about $LIBS, $CFLAGS and proper libraries (uuid, blkid, lzo2, ..) detection.

Note that there is also strange unused btrfs_convert_libs, btrfs_image_libs and
btrfs_fragments_libs variables with things like "-lgd -lpng -ljpeg -lfreetype".
I guess it's some legacy, right? I didn't touch these variables as I have no
clue about sense of this stuff.


[PATCH 01/10] btrfs-progs: add ./configure script
[PATCH 02/10] btrfs-progs: use config.h
[PATCH 03/10] btrfs-progs: use standard PACKAGE_* macros
[PATCH 04/10] btrfs-progs: use ./configure to generate version.h
[PATCH 05/10] btrfs-progs: check for build programs in ./configure
[PATCH 06/10] btrfs-progs: use paths and $*_LIBS from ./configure
[PATCH 07/10] btrfs-progs: cleanup compilation flags usage
[PATCH 08/10] btrfs-progs: clean generated files, make version.h
[PATCH 09/10] btrfs-progs: add --disable-backtrace
[PATCH 10/10] btrfs-progs: add --disable-documentation

The next possible step is automake, but I'd like merge ./configure stuff first.

	Karel


