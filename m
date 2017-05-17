Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:54327 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdEQKDN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 06:03:13 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dAvnO-0004Cz-1d
        for linux-btrfs@vger.kernel.org; Wed, 17 May 2017 12:03:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs hang with 4.11.1 kernel
Date: Wed, 17 May 2017 10:02:54 +0000 (UTC)
Message-ID: <pan$3a41f$57dd0028$589ab08b$36c731eb@cox.net>
References: <400eaec1e8e4ae2539d4dd8623d43edd@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Wed, 17 May 2017 17:44:02 +0900 as excerpted:

> After upgrading to 4.11.1 and running for ~12 hours, btrfs filesystem
> hanged - most processes on a server accessing the filesystem went into
> "D" state and blocked.
> 
> The server would not reboot and had to be power cycled.
> 
> 
> Previously, it was running 4.10.7 for around 1.5 month without any
> issues.
> 
> The server has ~10 subvolumes and 5-10 snapshots, >220 GB free (about
> 50% free), runs in RAID-1 mode on SSD disks.
> 
> 
> Is it anything known with 4.11.x?

I've not had any issues with 4.11 myself (in fact, unlike 4.10, 4.11 was 
a rather uneventful kernel development cycle here), and haven't seen any 
4.11-specific btrfs problems reported here either.

Tho Chris Murphy and Hugo may know more, as they do the IRC channel as 
well, which I don't.

So if it's a 4.11 issue, you're one of the first reports, if not /the/ 
first report, of it. =:^\

Which means it's /probably/ not 4.11 specific.  But as I said, I don't do 
IRC, so if there's anything reported only there, I'd not know of it.

(Not being a dev the trace doesn't mean that much to me.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

