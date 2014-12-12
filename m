Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030330AbaLLNwN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 08:52:13 -0500
Date: Fri, 12 Dec 2014 14:52:11 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 3.18-rc1
Message-ID: <20141212135211.GQ27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the 3.18-rc1 has been tagged. There are changes that were pending for too long
(the 'fi usage' and 'dev usage' commands) and I've pulled a lot of changes to
fsck/recovery tools. There are missing pieces of documentation that will be
added in the next round, the point is to release the code first and make it
available for testing.

The ETA for release is ~1 week if everything goes fine. I'm accepting namely
bugfixes, tests and documentation updates, possibly small and unintrusive
patches if reasonable or reviewed.  New rcs will be tagged when enough changes
accumulate.

I can upload the pre-release tarballs if desired.
