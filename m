Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39640 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3KJQHG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 11:07:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VfXXU-0000xV-F0
	for linux-btrfs@vger.kernel.org; Sun, 10 Nov 2013 17:07:04 +0100
Received: from dyndsl-178-142-089-109.ewe-ip-backbone.de ([178.142.89.109])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 17:07:04 +0100
Received: from hurikhan77+btrfs by dyndsl-178-142-089-109.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 17:07:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Btrfs might be gradually slowing the boot process
Date: Sun, 10 Nov 2013 17:07:23 +0100
Message-ID: <rin4la-odl.ln1@hurikhan77.spdns.de>
References: <527d2ee689e077.81319728@wp.pl> <72h1la-adf.ln1@hurikhan77.spdns.de> <04B39B7F-24A2-42E0-8C4A-31D710A844E6@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

> What's leafsize was used when making the file system? The default is now
> (as of yesterday) 16KB to avoid metadata fragmentation.

Since my btrfs is about 2 years old I suppose I'm still using 4kB leafsize. 
Is there a way to change it without recreating the whole filesystem from 
scratch?

Regards,
Kai

