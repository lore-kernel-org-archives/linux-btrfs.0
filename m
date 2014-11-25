Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43885 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKYQRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 11:17:16 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] New 'btrfs chunk list' command
Date: Tue, 25 Nov 2014 17:08:15 +0100
Message-ID: <1995604.saxct2VtQ4@merkaba>
In-Reply-To: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

Am Dienstag, 25. November 2014, 16:57:21 schrieb Goffredo Baroncelli:
> This is a revamp of a my previous patches set[1]. After more than
> year of attempts these patches were never merged, so I tried to
> simplify them and to change a bit the focus. The previous patches set
> had the focus to the disk usage.
> The aim of these patches now is to show the chunks distribution
> among the disks. So a new command 'btrfs chunk list' is added:
> 
> $ sudo ./btrfs chunk list /mnt/btrfs1/
> Data,RAID6: Size:3.00GiB, Used:1.02MiB
>    /dev/vdb	   1.00GiB
>    /dev/vdd	   1.00GiB
>    /dev/vde	   1.00GiB
>    /dev/vdf	   1.00GiB
>    /dev/vdg	   1.00GiB

I still like your previous patch set *a lot* and wonder why exactly is has 
never been merged. I know there has been quite some discussion about it, but 
in the end I lost track.

Can the chunk list also display the usage inside the chunks?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
