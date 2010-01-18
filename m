From: Ravi Pinjala <ravi@p-static.net>
Subject: Re: btrfs write behavior on idle system
Date: Mon, 18 Jan 2010 12:14:43 -0600
Message-ID: <4B54A513.7060902@p-static.net>
References: <20100118171756.GA4165@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100118171756.GA4165@Pilar.aei.mpg.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/18/10 11:17, Carlos R. Mafra wrote:
> Hi everyone,
>
> I am using btrfs for my /home partition since I upgraded my slow
> laptop hdd for an ssd 3 weeks ago. I am always in sync with Linus'
> tree of the day (plus a btrfs patch which is not in there yet) and
> so far I haven't lost any data, so all is good.
>
> I have a question about the write behavior of the various [btrfs- ]
> kernel threads, as I've been monitoring what is writing to the ssd
> just in case.
>
> So what I've been observing with 'iostat', 'iotop' and 'blktrace'
> is the following. If my laptop is almost absolutely idle (just
> a plain Window Maker and a few xterms and a couple dockapps open)
> there is nothing writing to the disk (which is OK).
>
> But as soon as I leave an open tab in chrome (or firefox) the various
> [btrfs- ] threads start writing in my /home, and I don't know what.
> For testing purposes, I mounted the config dir of chrome (~/.config/google-chrome)
> in my SD card (at /dev/mmcblk0p1) to exclude the possibility of maybe chrome
> trying to update its history or something, so that it does not write
> anything in my /home partition with btrfs.
>
> But I see this in the output of 'iotop' from a 60 sec interval, showing
> only the processes which wrote something:
>
> Total DISK READ: 0 B/s | Total DISK WRITE: 10.26 K/s
>    PID USER      DISK READ  DISK WRITE   SWAPIN    IO    COMMAND
>    485 root           0 B/s    5.19 K/s  0.00 %  0.02 % [btrfs-transacti]
>   3792 root           0 B/s       0 B/s  0.00 %  0.01 % [flush-btrfs-1]
>    476 root           0 B/s    0.13 K/s  0.00 %  0.00 % [btrfs-delalloc-]
>    481 root           0 B/s    4.93 K/s  0.00 %  0.00 % [btrfs-endio-wri]
>
> and there are more instances like this. Is there a way to avoid (or reduce)
> the writings of these threads?
>
> And when I start opening some pages in chrome and use it some more I
> get many many writes on my /home partition from these threads (and swapper,
> see below) even though I mounted the .config/google-chrome dir under
> /dev/mmcblk0p1 which uses ext4.
>
>> From another experiment where chrome was showing a blank tab a ~7 minutes
> run of 'blktrace -a write /dev/sda3' (sda3 is my /home) ends like this
> (from 'blkparse -s sda3.blktrace.0'):
>
- snip -

Don't forget cache - should be under ~/.cache/google-chrome. That would 
probably explain the disk activity you're seeing.

--Ravi Pinjala
