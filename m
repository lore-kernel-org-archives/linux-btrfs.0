Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36962 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3CKURb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:17:31 -0400
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@gmail.com>,
        Harald Glatt <mail@hachre.de>, Roger Binns <rogerb@rogerbinns.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Diego Calleja <diegocg@gmail.com>, sam tygier <samtygier@yahoo.co.uk>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 0/5] RAID-level terminology change
Date: Mon, 11 Mar 2013 20:17:23 +0000
Message-Id: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

   Some time ago, and occasionally since, we've discussed altering the
"RAID-n" terminology to change it to an "NcMsPp" format, where N is the
number of copies, M is the number of (data) devices in a stripe per copy,
and P is the number of parity devices in a stripe.

   The current kernel implementation uses as many devices as it can in the
striped modes (RAID-0, -10, -5, -6), and in this implementation, that is
written as "Xs" (with a literal "X"). The Ms and Pp sections are omitted
if the value is 1s or 0p.

   The magic look-up table for old-style / new-style is:

single 		 1c (or omitted, in btrfs fi df output)
RAID-0		 1cXs
RAID-1		 2c
DUP			 2cd
RAID-10		 2cXs
RAID-5		 1cXs1p
RAID-6		 1cXs2p

   The following patch set modifies userspace tools to accept c/s/p formats
in input (mkfs and the restriper). The older formats are also accepted. It
also prints the newer formats by default in btrfs fi df, with an option to
show the older format for the traditionalists, and to expand the abbreviation
verbosely for those unfamiliar with it.

v1 -> v2: Changed to use lower-case letters for c/s/p, for readability
   	  	  Changed mS to Xs for readability
		  Added "explain" option to df
		  Switched option parsing for df to getopt_long

   Hugo.

Hugo Mills (5):
  Use NcMsPp format for mkfs
  Move parse_profile to utils.c
  Convert balance filter parser to use common NcMsPp replication-level
    parser
  Change output of btrfs fi df to report new (or old) RAID names
  Add man page description for NcMsPp replication levels

 cmds-balance.c      |   23 +++----
 cmds-filesystem.c   |  173 ++++++++++++++++++++++++++++++++++++++++++++-------
 man/btrfs.8.in      |   16 +++++
 man/mkfs.btrfs.8.in |   24 ++++++-
 mkfs.c              |   35 +++--------
 utils.c             |   94 ++++++++++++++++++++++++++++
 utils.h             |    1 +
 7 files changed, 303 insertions(+), 63 deletions(-)

-- 
1.7.10.4

