Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ny.voidptr.de ([5.45.110.253]:35131 "EHLO ny.voidptr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbaHNTYn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 15:24:43 -0400
From: Nils Steinger <nst@voidptr.de>
To: linux-btrfs@vger.kernel.org
Cc: Nils Steinger <nst@voidptr.de>
Subject: [PATCH] Options to set fixed unit for `filesystem df`
Date: Thu, 14 Aug 2014 21:24:20 +0200
Message-Id: <1408044261-11234-1-git-send-email-nst@voidptr.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, `btrfs filesystem df` uses the pretty_size() function, which
automatically selects a unit to display a size in, e.g. 1024 bytes will be
displayed as "1.00KiB".
This makes parsing the output of `filesystem df` unnecessarily hard, so I've
added the options -b, -k, -m, and -g to get the output in bytes, kibi-, mebi-,
and gibibytes respectively.

Nils Steinger (1):
  Add options to use a fixed unit for `filesystem df` instead of
    determining it automatically.

 cmds-filesystem.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 utils.c           | 30 +++++++++++++++++++++++++++
 utils.h           |  8 +++++++
 3 files changed, 93 insertions(+), 7 deletions(-)

-- 
1.9.1

