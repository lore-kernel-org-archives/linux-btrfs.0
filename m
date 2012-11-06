Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:24120 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2KFUrK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Nov 2012 15:47:10 -0500
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: ablock84@googlemail.com, sensille@gmx.net
Subject: [PATCH v2 0/2] Btrfs-progs: urgent fixes for btrfs send
Date: Tue,  6 Nov 2012 21:47:06 +0100
Message-Id: <1352234828-9446-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After sending v1 some days ago, some onlist and offlist discussion has
brought us to the following conclusions:

	- we should fix it as soon as possible
	- we should stick to the -p option (parent)
	- we should rename the -i option (because it actually means
	  "clone source")

This is what v2 of this patch set is doing, besides fixing one and a
half bugs along the way: We turn -i into -c, emitting a fatal warning
should anybody use -i. As argued in the v1 cover letter, we should
really do this change now in order to avoid a lot of confused users that
"btrfs send -i" is doing things differently in a subtle way from what
"zfs send -i" is doing. We're better off coming up with our own
terminology, thus offering -p and -c options (both can be used to ask
for an incremental send stream, see the usage changes in patch 1),
without providing a "send -i" option at all.

Jan Schmidt (2):
  Btrfs-progs: correcting misnamed parameter options for btrfs send
  Btrfs-progs: bugfix for subvolume parent determination in btrfs send

 cmds-send.c  |   74 +++++++++++++++++++++++++++++++++-------------------------
 send-utils.c |    4 +-
 2 files changed, 44 insertions(+), 34 deletions(-)

