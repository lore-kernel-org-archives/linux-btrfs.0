Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50927 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751353AbaDWWfD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:35:03 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:62524 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wd5kq-001f4V-AG
	for linux-btrfs@vger.kernel.org; Wed, 23 Apr 2014 16:35:01 -0600
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <vifl2b-87g.ln1@hurikhan77.spdns.de>
Date: Wed, 23 Apr 2014 16:34:58 -0600
Message-Id: <5142767A-C8DE-4F3B-8170-CACF2D5D823C@colorremedies.com>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <vifl2b-87g.ln1@hurikhan77.spdns.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 23, 2014, at 1:06 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:

> Пламен Петров <plamen@petrovi.no-ip.info> schrieb:
> 
> I'm going with the module suggestion from Marc, too.
> 
>> /dev/sda2              /         btrfs     relatime,compress=zlib 0      0
> 
> This line looks kinda useless to me. The compress=zlib option won't be 
> applied at boot and cannot be changed at runtime because AFAIR btrfs does 
> not allow that yet.

So long as no other part of the same volume (including a subvolume) has been mounted, an ro rootfs remounted upon consultation of fstab will result in the fstab mount options being applied to remount. There might be a handful of btrfs options that don't work with remount, but compress isn't one of them. At least on Fedora since the dawn of btrfs, it's been possible to specify compress in fstab and its honored when rootfs is remounted rw.

Also, relatime is default. So the cleaned up mount option for fstab for the above would be merely compress (zlib is the default).



Chris Murphy

