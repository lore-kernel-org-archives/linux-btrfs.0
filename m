From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] improve space utilization on off-sized raid devices
Date: Thu, 17 Nov 2011 08:42:48 +0100
Message-ID: <4EC4BAF8.1000407@gmx.net>
References: <20111117002734.70530@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Thomas Schmidt <Schmidt-T@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111117002734.70530@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.11.2011 01:27, Thomas Schmidt wrote:
> I wrote a small patch to improve allocation on differently sized raid devices.
> 
> With 2.6.38 I frequently ran into a no space left error that I attribute to
> this. But I'm not entierly sure. The fs was an 8 device -d raid0 -m raid10.
> The used space was the same across all devices. 5 were full and 3 bigger ones still had plenty of space.
> I was unable to use the remaning space and a balance did not fix it for
> long.
> 

Did you also test with 3.0? In 3.0, the allocation strategy changed vastly.
In your setup, it should stripe to all 8 devices until the 5 smaller ones
are full, and from then on stripe to the 3 remaining devices.
See commit

commit 73c5de0051533cbdf2bb656586c3eb21a475aa7d
Author: Arne Jansen <sensille@gmx.net>
Date:   Tue Apr 12 12:07:57 2011 +0200

    btrfs: quasi-round-robin for chunk allocation

Also using raid1 instead of raid10 will yield a better space utilization.

-Arne

> Now I tried to avoid getting there again.
> 
> The basic idea to not allocate space on the devices with the least free
> space. The amount of devices to leave out is calculated on each allocation
> to ajust to changing circumstances. It leaves the minimum number that still
> can achieve full space usage.
> 


> Additionally I tought leaving at least one out might be of use in device removal.
> 
> Please take extra care with this. I'm new to btrfs, kernel and C in general.
> It was written and tested with 3.0.0.
> 
> 
> --- volumes.c.orig      2011-10-07 16:50:04.000000000 +0200
> +++ volumes.c   2011-11-16 23:49:08.097085568 +0100
> @@ -2329,6 +2329,8 @@ static int __btrfs_alloc_chunk(struct bt
>         u64 stripe_size;
>         u64 num_bytes;
>         int ndevs;
> +       u64 fs_total_avail;
> +       int opt_ndevs;
>         int i;
>         int j;
>  
> @@ -2404,6 +2406,7 @@ static int __btrfs_alloc_chunk(struct bt
>          * about the available holes on each device.
>          */
>         ndevs = 0;
> +       fs_total_avail = 0;
>         while (cur != &fs_devices->alloc_list) {
>                 struct btrfs_device *device;
>                 u64 max_avail;
> @@ -2448,6 +2451,7 @@ static int __btrfs_alloc_chunk(struct bt
>                 devices_info[ndevs].total_avail = total_avail;
>                 devices_info[ndevs].dev = device;
>                 ++ndevs;
> +               fs_total_avail += total_avail;
>         }
>  
>         /*
> @@ -2456,6 +2460,20 @@ static int __btrfs_alloc_chunk(struct bt
>         sort(devices_info, ndevs, sizeof(struct btrfs_device_info),
>              btrfs_cmp_device_info, NULL);
>  
> +       /*
> +        * do not allocate space on all devices
> +        * instead balance free space to maximise space utilization
> +        * (this needs tweaking if parity raid gets implemented
> +        * for n parity ignore the n first (after sort) devs in the sum and division)
> +        */
> +       opt_ndevs = fs_total_avail / devices_info[0].total_avail;
> +       if (opt_ndevs >= ndevs)
> +               opt_ndevs = ndevs - 1; //optional, might be used for faster dev remove?
> +       if (opt_ndevs < devs_min)
> +               opt_ndevs = devs_min;
> +       if (ndevs > opt_ndevs)
> +               ndevs = opt_ndevs;
> +
>         /* round down to number of usable stripes */
>         ndevs -= ndevs % devs_increment;
> 

