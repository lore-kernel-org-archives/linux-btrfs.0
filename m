Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59871 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035Ab3EEB0Z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 May 2013 21:26:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UYnia-0007Na-G2
	for linux-btrfs@vger.kernel.org; Sun, 05 May 2013 03:26:24 +0200
Received: from dyndsl-080-228-187-077.ewe-ip-backbone.de ([80.228.187.77])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 03:26:24 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-187-077.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 03:26:24 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Scrub CPU usage ...
Date: Sun, 05 May 2013 03:21:22 +0200
Message-ID: <dpog5a-t12.ln1@hurikhan.ath.cx>
References: <518555FF.4020704@chinilu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Mitchell <george@chinilu.com> schrieb:

> 1)  The system fails to boot intermittently due to dracut/initrd issues
> (btrfs: open_ctree failed).  This is being worked on upstream and I am
> seeing a continual flow of patches addressing it, but so far no fix.
> This will take time to fix and it usually leaps to life in 3 attempts or
> less.

Try rootdelay=1 or a higher number. This solved exactly that problem for me. 
It will delay mounting the rootfs by the given number of seconds. You need 
to pass this on the kernel command line, probably using grub. This seems to 
only be needed with multi-device btrfs as rootfs.

Greetings,
Kai

