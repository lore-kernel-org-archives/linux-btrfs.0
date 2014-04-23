Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40975 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbaDWTTM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 15:19:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wd2hL-0001Xi-2Z
	for linux-btrfs@vger.kernel.org; Wed, 23 Apr 2014 21:19:11 +0200
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 21:19:11 +0200
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 21:19:11 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Wed, 23 Apr 2014 21:06:39 +0200
Message-ID: <vifl2b-87g.ln1@hurikhan77.spdns.de>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Пламен Петров <plamen@petrovi.no-ip.info> schrieb:

I'm going with the module suggestion from Marc, too.

> /dev/sda2              /         btrfs     relatime,compress=zlib 0      0

This line looks kinda useless to me. The compress=zlib option won't be 
applied at boot and cannot be changed at runtime because AFAIR btrfs does 
not allow that yet.

This is because during initial mount by the kernel, /etc/fstab has not yet 
been read (and cannot for obvious reasons). The only way around it is to 
also append rootflags= to the kernel cmdline. This also explains why in a 
few other cases btrfs cannot be mounted, although it should make no 
difference in your case except the compress option won't be applied to the 
running file system.

Also, you may want to try rootdelay=2 or something similar, it sometimes 
help mounting btrfs at boot. But first try the suggestion abount baking the 
btrfs module right into the kernel.

-- 
Replies to list only preferred.

