Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35844 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbbKWBoI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Nov 2015 20:44:08 -0500
Received: by igcph11 with SMTP id ph11so42732960igc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Nov 2015 17:44:08 -0800 (PST)
MIME-Version: 1.0
From: Mitch Fossen <msfossen@gmail.com>
Date: Sun, 22 Nov 2015 19:43:28 -0600
Message-ID: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
Subject: btrfs: poor performance on deleting many large files
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have a btrfs setup of 4x2TB HDDs for /home in btrfs RAID0 on Ubuntu
15.10 (kernel 4.2) and btrfs-progs 4.3.1. Root is on a separate SSD
also running btrfs.

About 6 people use it via ssh and run simulations. One of these
simulations generates a lot of intermediate data that can be discarded
after it is run, it usually ends up being around 100GB to 300GB spread
across dozens of files 500M to 5GB apiece.

The problem is that, when it comes time to do a "rm -rf
~/working_directory" the entire machine locks up and sporadically
allows other IO requests to go through, with a 5 to 10 minute delay
before other requests seem to be served. It can end up taking half an
hour or more to fully remove the offending directory, with the hangs
happening frequently enough to be frustrating. This didn't seem to
happen when the system was using ext4 on LVM.

Is there a way to fix this performance issue or at least mitigate it?
Would using ionice and the CFQ scheduler help? As far as I know Ubuntu
uses deadline by default which ignores ionice values.

Alternatively, would balancing and defragging data more often help?
The current mount options are compress=lzo and space_cache, and I will
try it with autodefrag enabled as well to see if that helps.

For now I think I'll recommend that everyone use subvolumes for these
runs and then enable user_subvol_rm_allowed.

Regards,

Mitch Fossen
