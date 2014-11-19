Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46469 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbaKTJRL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 04:17:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XrNrO-0004tN-50
	for linux-btrfs@vger.kernel.org; Thu, 20 Nov 2014 10:17:06 +0100
Received: from 213.47.207.20 ([213.47.207.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 10:17:06 +0100
Received: from wertstoffe by 213.47.207.20 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Nov 2014 10:17:06 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?SmFrb2IgU2Now7xyeg==?= <wertstoffe@nurfuerspam.de>
Subject: systemd.setenv and a mount.unit
Date: Wed, 19 Nov 2014 23:48:48 +0100
Message-ID: <gbjvjb-oqp.ln1@venus.xundeenergie.ssh22.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there!

Another challenge...
I'm using btrfs. So i make snapshots from my system. And in a script, I 
make a symlink (for example: @system.CURRENT and @system.LAST) for the 
current and the last snapshot.

So i want to add 2 entries in grub2 from which i can boot into the 
current and the last snapshot.

I tried to pass an environmental variable with 
systemd.setenv=BOOTSNAP=@system.CURRENT, and i have a mount-unit 
containing the option

Options=defaults,nofail,subvol=archive-local/@system.$BOOTSNAP

but it doesn't work. If i change $BOOTSNAP to CURRENT, the mount works.
So i made a test.service, containing only
StartExec=/bin/echo $BOOTSNAP
I get the value @system.CURRENT in the logs...

How can I do this mounts?

jakob
-- 
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/

