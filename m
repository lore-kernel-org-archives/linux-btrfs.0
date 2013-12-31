Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54431 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab3LaDZI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 22:25:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vxpx1-0007wG-Ht
	for linux-btrfs@vger.kernel.org; Tue, 31 Dec 2013 04:25:03 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:25:03 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 04:25:03 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: question regarding caching
Date: Tue, 31 Dec 2013 04:15:18 +0100
Message-ID: <6fp9pa-9un.ln1@hurikhan77.spdns.de>
References: <CAEx9m44ZiJLqTO1_G_rVfn+csD7_pOguEdiAjsvr3uPzna+mFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Aastha Mehta <aasthakm@gmail.com> schrieb:

> Rather than a local disk, I have a remote device to which my IO
> requests are sent and from which the data is fetched. I need certain
> data to be fetched from the remote device after a remount. But somehow
> I do not see any request appearing at the device. I even tried to do
> drop_caches after remounting the file system, but that does not seem
> to help.

Maybe you or your distribution deployed cachefilesd and uses it for the 
remote fs?

HTH
Kai

