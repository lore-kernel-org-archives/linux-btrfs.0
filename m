From: Arvin Schnell <aschnell@suse.de>
Subject: Comparing snapshots?
Date: Fri, 25 Feb 2011 10:59:16 +0100
Message-ID: <20110225095916.GA7609@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

for a backup program I have to find all differing files
(including metadata) in two snapshots taken from the same
subvolume.

Having looked at the find-new command I thought about this
process:

1. Get the two transids when the two snapshots were created.

2. Query modifications to the original subvolume between the two
   transids.

Is the general process corrent or have I overseen something?

AFAIS the btrfs tool does not provide the required
information/commands. Would it be possible to add those?

Thanks in advance,
  Arvin

--=20
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
