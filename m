Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37631 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbbDRQXS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 12:23:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YjVWW-0004c0-MG
	for linux-btrfs@vger.kernel.org; Sat, 18 Apr 2015 18:23:16 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 18:23:16 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 18:23:16 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: how to clone a btrfs filesystem
Date: Sat, 18 Apr 2015 18:23:07 +0200
Message-ID: <c0da0c-43d.ln1@hurikhan77.spdns.de>
References: <1429312124.8371.62.camel@scientia.net> <u6ca0c-12c.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow <hurikhan77@gmail.com> schrieb:

> Christoph Anton Mitterer <calestyo@scientia.net> schrieb:
> 
>> Hey.
>> 
>> I've seen that this has been asked some times before, and there are
>> stackoverflow/etc. questions on that, but none with a really good
>> answer.
>> 
>> How can I best copy one btrfs filesystem (with snapshots and subvolumes)
>> into another, especially with keeping the CoW/reflink status of all
>> files?
>> And ideally incrementally upgrade it later (again with all
>> snapshots/subvols, and again not loosing the shared blocks between these
>> files).
>> 
>> send/receive apparently also works for just one subvolume,... and
>> documentation is quite sparse :-/
> 
> You could simply "btrfs device add" the new device, then "btrfs device
> del" the old device...
> 
> It won't create a 1:1 clone, if that is your intention. But it will
> migrate all your data over to the new device (even a bigger/smaller one),
> keeping shared extents (CoW/reflink status), generation numbers, file
> system uid, label, each subvolume, etc... And it can be done while the
> system is running.
> 
> It looks like this way fulfills all your requirements. That same way you
> can later incrementally update it again.

BTW: I've done that when migrating my 3-device btrfs pool to bcache. I 
simply removed one device, reformatted with bcache, then added it. I 
repeated those steps for each device. It took a while (like 24 hours) but it 
worked. In the end I just did a balance to rebalance all 3 devices. That 
last step is not needed if you are migrating only one device.

As a safety measurement I did a backup first, then ran "btrfs check" to 
ensure file system integrity, and did start into the rescue shell to have 
only a minimum set of processes running. Due to a bug in the Intel graphics 
stack the system froze sometimes, and I didn't want that to happen during 
data migration.

-- 
Replies to list only preferred.

