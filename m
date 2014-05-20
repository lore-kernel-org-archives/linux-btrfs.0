Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43294 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbaETPbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 11:31:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wmm0W-000397-EX
	for linux-btrfs@vger.kernel.org; Tue, 20 May 2014 17:31:12 +0200
Received: from p5b007621.dip0.t-ipconnect.de ([91.0.118.33])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 17:31:12 +0200
Received: from holger.hoffstaette by p5b007621.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 17:31:12 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Better handling of stale scrub status
Date: Tue, 20 May 2014 15:30:48 +0000 (UTC)
Message-ID: <pan.2014.05.20.15.30.48@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


As Marc Merlin recently wrote in his blog [1] scrub can sometimes leave a 
stale state file behind, making cancel/resume complain. I took a peek at 
the code and found most of the scrub state file handling fairly 
straightforward, so before I go off and start hacking, what would a 
better behaviour look like?

- delete the stale file?
- fix the file by setting the "finished" flag?
- something else entirely?

I currently lean towards fixing (and not printing an error?), but maybe 
someone else has different ideas about how this should be handled.
Any suggestions welcome..

cheers
Holger

[1] http://marc.merlins.org/perso/btrfs/post_2014-04-26_Btrfs-Tips_-
Cancel-A-Btrfs-Scrub-That-Is-Already-Stopped.html

