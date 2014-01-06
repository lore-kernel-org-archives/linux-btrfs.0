Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55311 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754400AbaAFWFo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 17:05:44 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs raid1 and btrfs raid10 arrays NOT REDUNDANT
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52CB031C.7060403@jrs-s.net>
Date: Mon, 6 Jan 2014 15:05:45 -0700
Cc: Chris Samuel <chris@csamuel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <1FC5CA49-4BEE-49D5-B475-5E16DD76BF06@colorremedies.com>
References: <52C73987.7000106@jrs-s.net> <52C87A41.9030701@jrs-s.net> <05C97109-682D-4A62-B074-4EDCF8E9CE1E@colorremedies.com> <1416119.lWHlh5idGF@quad> <C7E0F781-5F46-4C76-BCC9-0DE416553046@colorremedies.com> <52CB031C.7060403@jrs-s.net>
To: Jim Salter <jim@jrs-s.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 6, 2014, at 12:25 PM, Jim Salter <jim@jrs-s.net> wrote:

> FWIW, Ubuntu (and I presume Debian) will work just fine with a single / on btrfs, single or multi disk.
> 
> I currently have two machines booting to a btrfs-raid10 / with no separate /boot, one booting to a btrfs single disk / with no /boot, and one booting to a btrfs-raid10 / with an ext4-on-mdraid1 /boot.

Did you create the multiple device layouts outside of the installer first?

What I'm seeing in the Ubuntu 12.03.04 installer is a choice of which disk to put the bootloader. If that's reliable UI, then it won't put it on both disks which means a single point of failure in which case -o degraded not being automatic with Btrfs is essentially pointless if we don't have a bootloader. I also see no way in the UI to even create Btrfs raid of any sort.

Chris Murphy