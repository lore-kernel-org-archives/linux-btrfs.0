Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624AbbBEQi4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Feb 2015 11:38:56 -0500
Date: Thu, 5 Feb 2015 17:38:54 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 3.19-rc2
Message-ID: <20150205163854.GJ24227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this rc should play better with the build systems. Several small bugs
and bugfixes on top of rc1, and tested at least in the open buildservice
against a few SUSE-based distro versions.

Hints that could help you adapt your distro build system:

* new build prerequisities

autoconf, automake, pkg-config

* build phase

spec:

%build
./autogen.sh
%configure
make

if done manually:

./autogen.sh
export CFLAGS
CFLAGS="%optflags or similar"
./configure ...
make

the change -- do not pass CFLAGS as make arguments

* installation phase

make install DESTDIR=...

there should be no change: same paths, set of installed utilities etc


Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
