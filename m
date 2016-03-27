Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43702 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcC0MS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 08:18:29 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: csum errors in VirtualBox VDI files
Date: Sun, 27 Mar 2016 14:18:26 +0200
Message-ID: <12481278.TvmLfnWAX4@merkaba>
In-Reply-To: <20160322090342.595fefac@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Dienstag, 22. März 2016 09:03:42 CEST Kai Krakow wrote:
> Hello!
> 
> Since one of the last kernel updates (I don't know which exactly), I'm
> experiencing csum errors within VDI files when running VirtualBox. A
> side effect of this is, as soon as dmesg shows these errors, commands
> like "du" and "df" hang until reboot.
> 
> I've now restored the file from backup but it happens over and over
> again.

Just as another data point I am irregularily using a VM with Virtualbox in a 
VDI file on a BTRFS RAID 1 on two SSDs and had no such issues so far up to 
kernel 4.5.

Thanks,
-- 
Martin
