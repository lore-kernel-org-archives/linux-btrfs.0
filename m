Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47678 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab3EOHlG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:41:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UcWKe-0002ll-MZ
	for linux-btrfs@vger.kernel.org; Wed, 15 May 2013 09:41:04 +0200
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 09:41:04 +0200
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 May 2013 09:41:04 +0200
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Re: subvol copying
Date: Wed, 15 May 2013 07:40:49 +0000 (UTC)
Message-ID: <kmve61$cqe$1@ger.gmane.org>
References: <201305151525.27913.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> A user of a workstation has a home directory /home/john as a subvolume.  I 
> wrote a cron job to make read-only snapshots of it under /home/john/backup 
> which was fortunate as they just ran a script that did something like
> "rm -rf ~".
> 
> Apart from copying dozens of gigs of data back, is there a good way of 
> recovering it all?  Whatever you suggest isn't going to work for this time 
> (the copy is almost done) but will be useful for next time.
> 
> Should I have put the backups under /backup instead so that I could just 
> delete the corrupted subvol and make a read-write snapshot of the last good 
> one?

You can move subvolumes at any time, as if they were regular directories.

For example: move the backups to an external location, move what's left
of the home to another location out of the way, and make a snapshot to
restore.


