Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:57728 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab3LROyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 09:54:50 -0500
Date: Wed, 18 Dec 2013 23:54:39 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: no space left, metadata usage almost full?
Message-ID: <20131218235439.480170e0@virtall.com>
In-Reply-To: <20131218124652.GL11281@carfax.org.uk>
References: <20131218213728.07d47dd5@virtall.com>
	<20131218124652.GL11281@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 18 Dec 2013 12:46:52 +0000
Hugo Mills <hugo@carfax.org.uk> wrote:

> > # btrfs fi df /home
> > Data, RAID1: total=2.51TiB, used=1.58TiB
> > System, RAID1: total=32.00MiB, used=372.00KiB
> > Metadata, RAID1: total=48.00GiB, used=47.23GiB
> > # btrfs fi balance start -dusage=5 /home

>    Currently, yes, it is the only approach.
>    Hope the above helps,

So the balance finished, and metadata is still almost full:

# btrfs fi df /home
Data, RAID1: total=1.60TiB, used=1.58TiB
System, RAID1: total=32.00MiB, used=248.00KiB
Metadata, RAID1: total=49.00GiB, used=47.24GiB

Confused about the output - does it actually look any better?


# btrfs fi show /home
Label: crawler-btrfs  uuid: 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
        Total devices 2 FS bytes used 1.63TiB
        devid    3 size 2.56TiB used 1.66TiB path /dev/sdb4
        devid    4 size 2.56TiB used 1.66TiB path /dev/sda4

Btrfs v3.12


Does it mean that data/system/metadata will be able to grow now,
until their size in total in 2.56TiB?

-- 
Tomasz Chmielewski
http://wpkg.org
