Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33143 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbcLGIPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 03:15:54 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cEXOA-0008PI-0l
        for linux-btrfs@vger.kernel.org; Wed, 07 Dec 2016 09:15:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: *** Some devices missing ***
Date: Wed, 7 Dec 2016 08:15:36 +0000 (UTC)
Message-ID: <pan$6949e$51eae740$77212edf$466e5cc6@cox.net>
References: <004e03916ff78571800ae947487813d3@tango.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Luescher Claude posted on Tue, 06 Dec 2016 14:00:28 +0100 as excerpted:

> The server was running 3.13 kernel and btrfs progs 4.0  until it
> crashed. After that mounting the file system hang forever so I decided
> to switch to Linux Kernel 4.8.11 and btrfs-progs v4.8.5.
> 
> There are of course no missing devices.  This is what I get in dmesg
> when I try to mount the array with or without the degraded option:

> [363.066379] BTRFS error (device sdf): super_num_devices 10 mismatch
> with num_devices 9 found here

> I only find an old 2014 list entry that it was some bug and fixed so it
> should be long time fixed in 4.8.5. I need to put the device back to
> operation as soon as possible. Anybody have any further ideas what can I
> do?

FWIW there's a very recent (within the last week) thread on this, with a 
patch.  I'm not a dev, just a btrfs user and list regular, so I didn't 
specifically track it, but someone else will likely post a more direct 
link or list the thread name anyway.

IIRC the problem is that under certain circumstances the number of 
devices as given in the superblock can be incorrect, so the patch lets 
btrfs ignore the given number if all chunks (both copies in raid1/10 
mode) appear to be accounted for on already available devices.

I believe the patch has been queued, but isn't in a release yet.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

