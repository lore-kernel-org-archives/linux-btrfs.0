From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: btrfs write behavior on idle system
Date: Mon, 18 Jan 2010 18:35:25 +0100
Message-ID: <20100118173525.GA4629@Pilar.aei.mpg.de>
References: <20100118171756.GA4165@Pilar.aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100118171756.GA4165@Pilar.aei.mpg.de>
List-ID: <linux-btrfs.vger.kernel.org>

PS:

On Mo 18.Jan'10 at 18:17:56 +0100, Carlos R. Mafra wrote:
> ...

> [ I get really worried when I 'blktrace -a write' my /home when actively
>   using chrome. Just a 2-minute experiment here while I was writing this
>   email ended up like this:
> 
...
> blktrace (4226)
>  Reads Queued:           0,        0KiB  Writes Queued:           0,        0KiB
>  Read Dispatches:        0,        0KiB  Write Dispatches:        0,        0KiB
>  Reads Requeued:         0               Writes Requeued:         0
>  Reads Completed:        0,        0KiB  Writes Completed:        8,      204KiB

This time I was inside /home taking the blktrace, but I usually do it from
inside /root which is in /dev/sda2 and uses ext4 to avoid disturbing
the result of measuring what is going on with btrfs in /dev/sda3.
