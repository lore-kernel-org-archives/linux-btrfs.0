Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52358 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab3CIVHB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 16:07:01 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.72)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0007mp-Ks
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:13 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQB-0003Hi-Un
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Sat,  9 Mar 2013 20:31:06 +0000
Message-Id: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

   Some time ago, and occasionally since, we've discussed altering the
"RAID-n" terminology to change it to an "nCmSpP" format, where n is the
number of copies, m is the number of (data) devices in a stripe per copy,
and p is the number of parity devices in a stripe.

   The current kernel implementation uses as many devices as it can in the
striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
written as "mS" (with a literal "m"). The mS and pP sections are omitted
if the value is 1S or 0P.

   The magic look-up table for old-style / new-style is:

single 		 1C (or omitted, in btrfs fi df output)
RAID-0		 1CmS
RAID-1		 2C
DUP			 2CD
RAID-10		 2CmS
RAID-5		 1CmS1P
RAID-6		 1CmS2P

   The following patch set modifies userspace tools to accept C/S/P formats
in input (mkfs and the restriper). The older formats are also accepted. It
also prints the newer formats by default in btrfs fi df, with an option to
show the older format for the traditionalists.

   I'm not sure whether we should omit the 1C in btrfs fi df output, or
make it explicit even in the "single" case.

   Hugo.

Hugo Mills (5):
  Use nCmSpP format for mkfs
  Move parse_profile to utils.c
  Convert balance filter parser to use common nCmSpP replication-level
    parser
  Change output of btrfs fi df to report new (or old) RAID names
  Add man page description for nCmSpP replication levels

 cmds-balance.c      |   23 +++------
 cmds-filesystem.c   |  135 +++++++++++++++++++++++++++++++++++++++++++--------
 man/btrfs.8.in      |    9 ++++
 man/mkfs.btrfs.8.in |   24 ++++++++-
 mkfs.c              |   35 ++++---------
 utils.c             |   94 +++++++++++++++++++++++++++++++++++
 utils.h             |    1 +
 7 files changed, 258 insertions(+), 63 deletions(-)

-- 
1.7.10.4

