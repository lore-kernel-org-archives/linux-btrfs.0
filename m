Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35410 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaKDV7K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Nov 2014 16:59:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xlm82-00011Q-HX
	for linux-btrfs@vger.kernel.org; Tue, 04 Nov 2014 22:59:06 +0100
Received: from ip4d160011.dynamic.kabel-deutschland.de ([77.22.0.17])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 22:59:06 +0100
Received: from Ansgar.Hockmann-Stolle by ip4d160011.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Nov 2014 22:59:06 +0100
To: linux-btrfs@vger.kernel.org
From: Ansgar Hockmann-Stolle <Ansgar.Hockmann-Stolle@uni-osnabrueck.de>
Subject: Re: [PATCH 03/11] Btrfs-progs: allow fsck to take the tree bytenr
Date: Tue, 4 Nov 2014 21:58:56 +0000 (UTC)
Message-ID: <loom.20141104T122529-705@post.gmane.org>
References: <1414778489-4049-1-git-send-email-jbacik@fb.com> <1414778489-4049-4-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik <jbacik <at> fb.com> writes:
> Sometimes we have a pretty corrupted fs but have an old tree bytenr that we
> could use, add the ability to specify the tree root bytenr.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik <at> fb.com>
Tested-by: Ansgar Hockmann-Stolle <ansgar.hockmann-stolle <at>
uni-osnabrueck.de>

This patch fixed my case:
http://www.spinics.net/lists/linux-btrfs/msg38714.html
Thank you! And thank you, Qu Wenruo for the help!!

I tested all blocks that find-root gave - but only the one with generation =
want + 1 gave some possible root items. The btrfsck with --tree-root <that
block> finally fixed my file system. Hooray!

Ciao
    Ansgar

