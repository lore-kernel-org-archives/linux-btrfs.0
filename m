Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52662 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaKYCLX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 21:11:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xt5b7-0004OC-EN
	for linux-btrfs@vger.kernel.org; Tue, 25 Nov 2014 03:11:21 +0100
Received: from 78-32-127-104.static.enta.net ([78.32.127.104])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 03:11:21 +0100
Received: from 6401e46d by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 03:11:21 +0100
To: linux-btrfs@vger.kernel.org
From: boris <6401e46d@opayq.com>
Subject: File test operator for subvols; possible bug in 'btrfs show <directory>'
Date: Tue, 25 Nov 2014 02:11:11 +0000 (UTC)
Message-ID: <loom.20141125T024507-20@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I was looking for a quick method of testing whether a working directory is a 
subvolume.

Couldn't see an obvious one, so tried 'btrfs show <somesubvol≥'. It printed 
a fail message as expected but returned 0 exit status. Bug?

Can I put in a feature request for a shell file test operator for subvols, 
please (or something of the kind)? http://tldp.org/LDP/abs/html/fto.html . 
The letter v (for volume, both upper and lower case forms; one for subvol, 
other for snapshots) is unused afaict. 

Have I missed the obvious? Or scored a false positive?

TIA.

