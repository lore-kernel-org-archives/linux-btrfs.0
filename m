Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45173 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbaACAzm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Jan 2014 19:55:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vyt36-0000Uw-TU
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 01:55:40 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:55:40 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 01:55:40 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Managing large volumes
Date: Fri, 03 Jan 2014 01:48:36 +0100
Message-ID: <40ehpa-sk6.ln1@hurikhan77.spdns.de>
References: <CAAKzf7kB90qOG8yNuLUyfd2w61kVeeo+d+vs=ecURYqm=rjxgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tim Cuthbertson <ratcheer@gmail.com> schrieb:

> I am a bit confused and I have probably managed to outsmart myself.
> For about 15 months, I have been running my system on a single, large
> btrfs volume. It is RAID-0 on two SATA-III HDD's for a total of 1.9
> TB. This is a home system running Siduction (Debian Sid) Linux. While
> I have root, home, and a special data directory each as separate
> subvolumes, I am beginning to wonder whether I should have made each
> of these on separate partitions and separate btrfs filesystems.
> 
> Am am at a point where I would like to do a fresh install of my OS
> without losing my home and data contents. And I do not think separate
> btrfs subvolumes will help me on that. Is that correct? Is there a way
> to prevent an OS installation from formatting the /home and /data
> subvolumes while completely replacing the root subvolume? Or do I need
> to completely repartition my drives so I don't get into this
> situation, again?

How about installing into a new root subvolume? I don't know if the Debian 
installer allows you to do that. But this way you could easily roll back 
later, or grab config files from there, or, or... And when you are done, 
simply remove the old root subvolume or deduplicate it using dedup and keep 
it around for archival purposes.

The one-partition layout is probably okay, tho many installers lack native 
support for it. But, at least this is how I think about it, take subvolumes 
as dynamically sized partitions from your storage pool.

Just keep in mind you don't want the installer to format your btrfs. You 
probably want to take a backup of your data first. It is probably possible 
to bootstrap your Debian installation by first creating your new subvolume, 
then mount it and use it as bootstrapped destination or chroot into it to 
run the installation. You could bind-mount your data and home there so it is 
visible to the installer for it to import your user id.

HTH
Kai

