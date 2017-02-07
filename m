Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36795 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1754031AbdBGTri (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 14:47:38 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbBje-0007Az-En
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 20:47:30 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Very slow balance / btrfs-transaction
Date: Tue, 7 Feb 2017 20:47:27 +0100
Message-ID: <20170207204727.1bcd9b45@jupiter.sol.kaishome.de>
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
        <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
        <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
        <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
        <1f5f66cfa8eca19b7e612e3b4745d788@85337f6d4fa4>
        <20170204221051.664ada65@jupiter.sol.kaishome.de>
        <403247fe-376f-27d7-bbd5-d8acd260a8ad@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mon, 6 Feb 2017 08:19:37 -0500
schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:

> > MDRAID uses stripe selection based on latency and other measurements
> > (like head position). It would be nice if btrfs implemented similar
> > functionality. This would also be helpful for selecting a disk if
> > there're more disks than stripesets (for example, I have 3 disks in
> > my btrfs array). This could write new blocks to the most idle disk
> > always. I think this wasn't covered by the above mentioned patch.
> > Currently, selection is based only on the disk with most free
> > space.  
> You're confusing read selection and write selection.  MDADM and
> DM-RAID both use a load-balancing read selection algorithm that takes
> latency and other factors into account.  However, they use a
> round-robin write selection algorithm that only cares about the
> position of the block in the virtual device modulo the number of
> physical devices.

Thanks for clearing that point.

> As an example, say you have a 3 disk RAID10 array set up using MDADM 
> (this is functionally the same as a 3-disk raid1 mode BTRFS
> filesystem). Every third block starting from block 0 will be on disks
> 1 and 2, every third block starting from block 1 will be on disks 3
> and 1, and every third block starting from block 2 will be on disks 2
> and 3.  No latency measurements are taken, literally nothing is
> factored in except the block's position in the virtual device.

I didn't know MDADM can use RAID10 on odd amounts of disks...
Nice. I'll keep that in mind. :-)


-- 
Regards,
Kai

Replies to list-only preferred.

