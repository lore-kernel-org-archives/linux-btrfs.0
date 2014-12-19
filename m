Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaLSSVc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 13:21:32 -0500
Date: Fri, 19 Dec 2014 19:21:30 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs pre-release 3.18-rc2
Message-ID: <20141219182130.GL27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

another step towards 3.18, the changes are limited in scope and mostly
cleanups or docs. I'd like to see more test images for new fsck code,
there are 2 new that I missed earlier, so they don't count.

The timing with end of the year is not good so if I'm not confident
that the release is in a good shape I'm rather going to postpone it.
Alternatively, I can do a release on Monday and then use the following
weeks to prepare a .1 bugfix release.

Known problems: the image 013 fails
