Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51749 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbbFZQXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 12:23:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z8WPq-00064q-55
	for linux-btrfs@vger.kernel.org; Fri, 26 Jun 2015 18:23:46 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 18:23:46 +0200
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2015 18:23:46 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: fuser fails to list processes that have a directory on a btrfs filesystem
 as their current working directory
Date: Fri, 26 Jun 2015 18:23:37 +0200
Message-ID: <mmjua9$bjp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

JFYI: Not a btrfs bug, but a btrfs-specific misbehaviour of "fuser" that
might easily be misinterpreted as a btrfs bug:

http://bugzilla.centos.org/view.php?id=8966

> /usr/sbin/fuser (from psmisc-22.20-8.el7.x86_64) does not list any processes that have a directory on a btrfs file system as their current working directory.
>
> (For file systems other than btrfs, this works.)

> Steps To Reproduce:
> mkdir /some/btrfs/testdir
> cd /some/btrfs/testdir
> fuser -v -m /some/btrfs
>
> This should list your current shell as one of the processes using the /some/btrfs file system, but it doesn't
>
> The same on /some/xfs/testdir works fine.

> This bug is not present in upstream "psmisc" sources as of current master in
> git://git.code.sf.net/p/psmisc/code
>
> An fuser executable compiled from the current upstream sources works fine also for btrfs.

Regards,

Lutz Vieweg

