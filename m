Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:35434 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754234AbdENTNi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 15:13:38 -0400
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
Date: Sun, 14 May 2017 21:13:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/13/2017 10:54 PM, Marc MERLIN wrote:
> Kernel 4.11, btrfs-progs v4.7.3
> 
> I run scrub and balance every night, been doing this for 1.5 years on this
> filesystem.

What are the exact commands you run every day?

> But it has just started failing:
> [...]

> saruman:~# btrfs fi usage /mnt/btrfs_pool1/
> Overall:
>     Device size:		 228.67GiB
>     Device allocated:		 228.67GiB
>     Device unallocated:		   1.00MiB
>     Device missing:		     0.00B
>     Used:			 171.25GiB
>     Free (estimated):		  55.32GiB	(min: 55.32GiB)
>     Data ratio:			      1.00
>     Metadata ratio:		      1.00
>     Global reserve:		 512.00MiB	(used: 0.00B)
> 
> Data,single: Size:221.60GiB, Used:166.28GiB
>    /dev/mapper/pool1	 221.60GiB
> 
> Metadata,single: Size:7.03GiB, Used:4.96GiB
>    /dev/mapper/pool1	   7.03GiB
> 
> System,single: Size:32.00MiB, Used:48.00KiB
>    /dev/mapper/pool1	  32.00MiB
> 
> Unallocated:
>    /dev/mapper/pool1	   1.00MiB
> 
> How did I get into such a misbalanced state when I balance every night?

I don't know, since I don't know what you do exactly. :)

> My filesystem is not full, I can write just fine, but I sure cannot
> rebalance now.

Yes, because you have quite some allocated but unused space. If btrfs
cannot just allocate more chunks, it starts trying a bit harder to reuse
all the empty spots in the already existing chunks.

> Besides adding another device to add space, is there a way around this
> and more generally not getting into that state anymore considering that
> I already rebalance every night?

Add monitoring and alerting on the amount of unallocated space.

FWIW, this is what I use for that purpose:

https://packages.debian.org/sid/munin-plugins-btrfs
https://packages.debian.org/sid/monitoring-plugins-btrfs

And, of course the btrfs-heatmap program keeps being a fun tool to
create visual timelapses of your filesystem, so you can learn how your
usage pattern is resulting in allocation of space by btrfs, and so that
you can visually see what the effect of your btrfs balance attempts is:

https://github.com/knorrie/btrfs-heatmap/
https://packages.debian.org/sid/btrfs-heatmap
https://apps.fedoraproject.org/packages/btrfs-heatmap
https://aur.archlinux.org/packages/python-btrfs-heatmap/

-- 
Hans van Kranenburg
