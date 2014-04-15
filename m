Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54055 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaDOOFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 10:05:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wa3yy-00025D-BZ
	for linux-btrfs@vger.kernel.org; Tue, 15 Apr 2014 16:05:04 +0200
Received: from host31-49-81-191.range31-49.btcentralplus.com ([31.49.81.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 16:05:04 +0200
Received: from linux by host31-49-81-191.range31-49.btcentralplus.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 16:05:04 +0200
To: linux-btrfs@vger.kernel.org
From: Bob Williams <linux@barrowhillfarm.org.uk>
Subject: Can I convert an existing directory into a subvolume?
Date: Tue, 15 Apr 2014 14:10:54 +0100
Message-ID: <lijb4u$57s$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm new to btrfs, just dipping my toes in the water...

I've got two partitions, / on /dev/sda2 and /home on /dev/sda3, both
formatted as btrfs in a new openSUSE 13.1 installation. I copied the
whole of /home (4 users) into the btrfs formatted /home partition from
an ext4 backup.

I would like to create snapshots of /home/user/Documents for example,
but I understand these have to be subvolumes first. Googling tells me I
can't convert a conventional subdirectory into a subvolume, so I'm
guessing I'll have to create a new /home/user/Documents subvolume and
then copy all the contents from the subdirectory. Correct? Then delete
the subdirectory?

Can the subvolume have the same name as the subdirectory it is
replacing, or should it be called something like 'tempDocs', and then
renamed back to 'Documents' after the original has gone?

Bob

