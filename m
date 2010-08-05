From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Subject: Re: Poor read performance on high-end server
Date: 05 Aug 2010 18:21:30 +0200
Message-ID: <m339ut114l.fsf@mobydick.mine.nu>
References: <4C5AC52D.9030906@sara.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Freek.Dijkstra@sara.nl (Freek Dijkstra)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C5AC52D.9030906@sara.nl>
List-ID: <linux-btrfs.vger.kernel.org>

        Hello,

Freek.Dijkstra@sara.nl (Freek Dijkstra) writes:
> [...]
>
> Here are the exact settings:
> ~# mkfs.btrfs -d raid0 /dev/sdd /dev/sde /dev/sdf /dev/sdg \
>      /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm \
>      /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds
> nodesize 4096 leafsize 4096 sectorsize 4096 size 2.33TB
> Btrfs Btrfs v0.19

Don't you need to stripe metadata too (with -m raid0)?  Or you may
be limited by your metadata drive?

-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
