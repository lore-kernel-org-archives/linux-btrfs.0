Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLQO3O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 09:29:14 -0500
Date: Wed, 17 Dec 2014 15:29:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC][BTRFS-PROGS] Improve output of mkfs.btrfs command
Message-ID: <20141217142912.GZ27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1418673780-22000-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 15, 2014 at 09:02:53PM +0100, Goffredo Baroncelli wrote:
> enclosed a patches set to improve the output of mkfs.btrfs command.
>
> Currently I find the output of mkfs.btrfs command quite confusing:

Thanks. I've marked the wiki://Project_ideas item as claimed.

> After my patches the output becomes:
> 
> # mkfs.btrfs -f -d raid5 -m raid5 /dev/vd[b-k] 
> BTRFS filesystem summary:
>   Label:		btrfs-test
>   UUID:			1073cb19-b675-423d-9aba-caad7f1508a8
> 
>   Node size:		16384
>   Leaf size:		16384
>   Sector size:		4096
>   Initial chunks:
>     Data:		9.01GiB
>     Metadata:		3.61GiB
>     System:		18.06MiB
>   Metadata profile:	RAID5
>   Data profile:		RAID5
>   Mixed mode:		NO
>   SSD detected:		NO
>   Features:		extref, raid56
>   Number of devices:	10
>     UUID                                  ID    SIZE    PATH
>     ------------------------------------  --  --------- -----------
>     62121322-5666-4ecf-bc8e-c9b3d9f60db9   1   50.00GiB /dev/vdb
>     6158cb13-3ae8-42b6-8603-660f1e5c8a7a   2   50.00GiB /dev/vdc
>     b49516db-ddf5-4f54-8831-a4babc79e901   3   50.00GiB /dev/vdd
>     00b03d81-7d29-4894-8050-9dd205f97c41   4   50.00GiB /dev/vde
>     f119a2ec-5ef0-436c-805e-c1b0612b05ca   5   50.00GiB /dev/vdf
>     adee4f58-e094-4bd4-8c56-941527524f8d   6   50.00GiB /dev/vdg
>     a8299171-2024-4057-ba56-1f83bf6d7e2e   7   50.00GiB /dev/vdh
>     b694e275-e454-4dbd-beb0-e33c388cffa2   8    2.00GiB /dev/vdi
>     7cbe04b5-36cd-4ea7-be82-206d5487914e   9    2.00GiB /dev/vdj
>     7c320654-675e-456b-ac23-cfb148b8ea57  10    2.00GiB /dev/vdk
> 
>   Total disks size:                           356.01GiB

The output looks good to me, I'll get back to this patchset after 3.18
is released, so there's enough time to gather feedback.
