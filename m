Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48099 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750784AbaDOOqI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:46:08 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:50713 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wa4ch-001Vpm-SR
	for linux-btrfs@vger.kernel.org; Tue, 15 Apr 2014 08:46:07 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can I convert an existing directory into a subvolume?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <lijb4u$57s$1@ger.gmane.org>
Date: Tue, 15 Apr 2014 08:46:09 -0600
Message-Id: <5B149016-DFF5-4B88-B30C-B3B6C9AEDA73@colorremedies.com>
References: <lijb4u$57s$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 15, 2014, at 7:10 AM, Bob Williams <linux@barrowhillfarm.org.uk> wrote:

> Hi,
> 
> I'm new to btrfs, just dipping my toes in the water...
> 
> I've got two partitions, / on /dev/sda2 and /home on /dev/sda3, both
> formatted as btrfs in a new openSUSE 13.1 installation. I copied the
> whole of /home (4 users) into the btrfs formatted /home partition from
> an ext4 backup.
> 
> I would like to create snapshots of /home/user/Documents for example,
> but I understand these have to be subvolumes first. Googling tells me I
> can't convert a conventional subdirectory into a subvolume, so I'm
> guessing I'll have to create a new /home/user/Documents subvolume and
> then copy all the contents from the subdirectory. Correct? Then delete
> the subdirectory?

Create a new subvolume, move files into the new subvolume as if it were a directory, remove old directory, rename subvolume to the name of the deleted directory.

btrfs subvolume create /home/user1/Documentss
mv /home/user1/Documents/* /home/user1/Documentss/
rmdir /home/user1/Documents
mv /home/user1/Documentss  /home/user1/Documents

One possible gotcha is the ownership of the subvolume at creation time. If you do this as root then you need to chown after you're done; or you need to be logged in as the user who will own the Documents directory in each of the four cases. If you're using SELinux another gotcha is with copying files, which causes them to inherit the security context of the directory copied into, whereas mv preserves existing context. You can just restorecon -Rv /home/user once you're done to make sure the subvolume and its contents have the right labeling.


Chris Murphy

