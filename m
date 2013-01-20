Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:43646 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3ATVEh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:04:37 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120210436.OLPT7113.eastrmfepo102.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:04:36 -0500
From: Gene Czarcinski <gene@czarc.net>
To: linux-btrfs@vger.kernel.org
Cc: Gene Czarcinski <gene@czarc.net>
Subject: [PATCH 00/13] Btrfs-progs: more patches for integration
Date: Sun, 20 Jan 2013 16:04:05 -0500
Message-Id: <1358715858-4469-1-git-send-email-gene@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have done some additional scraping of the mailing list to
identify some "low hanging fruit" which I consider should
be merged into the btrfs-progs repository.

All of the patches below were applied on top of the 19 bugfix
patches pulled together by David Sterba and the 6 patches
now part of the Fedora 18 btrfs-progs package.  All of this
compiles but further testing is obviously needed.

For the most part, these patches are bugfixes and they all
appeared resonable but inspection by other eyes would
be appreciated.  There is also one "simple" function
addition in the form or the btrfs-show-super command.

Arvin Schnell (1):
  trivial patch for btrfs-progs

Chen Yang (1):
  Btrfs-progs: Fix a segmentation fault in btrfstune when <device> is
    invalid.

Gene Czarcinski (1):
  btrfs-show-super.c

Goffredo Baroncelli (1):
  Add btrfs-show-super

Jan Schmidt (2):
  Btrfs-progs: correcting misnamed parameter options for btrfs send
  Btrfs-progs: bugfix for subvolume parent determination in btrfs send

Nageswara R Sastry (1):
  btrfs-progs: btrfs-image.c: Added NULL pointer check.

Nirbheek Chauhan (1):
  Btrfs-progs: fix resolving of loop devices

Ulrik (1):
  Btrfs-progs: correct btrfs receive usage string

Wang Shilong (4):
  Btrfs-progs: fix arg parsing for btrfs qgroup limit commands
  Btrfs-progs: clean up reduplicate parse_qgroupid() and replace atoi
    with strtoull
  Btrfs-progs: check the relation of two group by real level numbers
  Btrfs-progs: disable qgroupid 0 for quota_tree

