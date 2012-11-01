Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.140]:12511 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761706Ab2KAPBa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 11:01:30 -0400
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: ablock84@googlemail.com, sensille@gmx.net
Subject: [PATCH 0/2] Btrfs-progs: urgent fixes for btrfs send
Date: Thu,  1 Nov 2012 16:01:24 +0100
Message-Id: <1351782086-23435-1-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

We made a bad mistake with "btrfs send" command line arguments and we'd
better fix it before it's being widely used (read: *now*).

When using "btrfs send" as in the current master, the "-i" option does
*not* give you an incremental stream as you'd expect. There are two
problems in the back:

	- The "-i" option adds clone sources and btrfs determines itself
	  whether any of these should be used to generate an incremental
	  stream.

	- That determination is broken.

There is however a "-p" option to force generation of an incremental
stream. This is a must change in my opinion. We should be using "send
-i" in the same way "zfs send" is using it. I expect anything else to
cause wide confusion. Therefore, these 2 patches do the following:

	- Turn "-i" into "-r", which stands for "remote" or "receiving
	  side". The option is meant to tell btrfs which subvolumes
	  exist on the receiver.

	- Turn "-p" into "-i". Yes, this is a clash.

	- Fix the parent determination (required in combination with
	  the "-r" option) in a way, that we never overwrite a base for
	  an incremental snapshot given with "-i".

Outcome for people who are already used to the current way btrfs send
works:

	- "btrfs send -p [base] [subvol]"
	  This command now prints a fatal error message to use -i
	  instead.
	  NEW: "btrfs send -i [base] [subvol]"

	- "btrfs send -i [snap] [subvol]"
	  This command now does exactly what one would have expected
	  from the previous documentation: it should have automatically
	  determined [snap] as base for an incremental stream. Now it
	  really selects [snap] as base.

	- "btrfs send -p [base] -i [snap1] -i [snap2] [subvol]"
	  Prints the same error message as the first example.
	  NEW: "btrfs send -i [base] -r [snap1] -r [snap2] [subvol]"

	- "btrfs send -i [snap1] -i [snap2] [subvol]"
	  Previously, determination of the best base was likely to fail,
	  resulting in a full stream. Now you get a fatal error message
	  for specifying -i multiple times.
	  NEW: "btrfs send -r [snap1] -r [snap2] [subvol]"

Although this gives a change in command line options rather late in the
game, I'll emphasis again that I think it's a no-go to leave it as it
currently is. The outcome as outlined should be acceptable for anyone, I
don't see a case where this change does something completely different
after the change. Users will have to adapt to the corrected switches,
though.

For ease of management, you can fetch these patches from my git repo,
based on top of the current cmason/master:

	git://git.jan-o-sch.net/btrfs-progs for-chris

-Jan

Jan Schmidt (2):
  Btrfs-progs: correcting misnamed parameter options for btrfs send
  Btrfs-progs: bugfix for subvolume parent determination in btrfs send

 cmds-send.c  |   97 +++++++++++++++++++++++++++++++---------------------------
 send-utils.c |    4 +-
 2 files changed, 54 insertions(+), 47 deletions(-)

