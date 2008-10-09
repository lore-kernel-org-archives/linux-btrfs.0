From: Christian Parpart <trapni@gentoo.org>
Subject: [PATCH] btrfs-progs: autotoolized and splitup into {libbtrfs,tools,tests}
Date: Thu, 9 Oct 2008 04:20:49 +0200
Message-ID: <200810090420.49767.trapni@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this now makes use of autoconf/automake/libtool suite,
thus, enabling a wider range of platforms etc.
Although, I've split up the build into tools, lib, and tests,
making it possible for 3rd-parties to link against libbtrfs now.

Patch URL:
http://ninchens.net/~trapni/btrfs/btrfs-progs-autotooled-splitup.diff

Best regards,
Christian Parpart.
