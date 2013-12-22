Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34183 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867Ab3LVBN4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Dec 2013 20:13:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VuXcA-0007IA-Mp
	for linux-btrfs@vger.kernel.org; Sun, 22 Dec 2013 02:13:54 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Dec 2013 02:13:54 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Dec 2013 02:13:54 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Btrfs RAID1 File System Grew Something Extra
Date: Sun, 22 Dec 2013 02:14:33 +0100
Message-ID: <p0rhoa-avs.ln1@hurikhan77.spdns.de>
References: <1617587.38j2eTuIdt@vfr> <52B10C85.90405@oracle.com> <17576852.FmZ5tQlVm8@vfr> <pan$2df35$e3cf512f$a0410338$348e2cbb@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> But the above documentation should also suggest trying this to see if it
> addresses that remaining single-mode system chunk stub:
> 
> btrfs balance start -fsconvert=raid1 /home

Cool man, that fixed it for me. :-)

Regards,
Kai

