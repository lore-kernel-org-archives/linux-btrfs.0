From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:305
Date: Wed, 9 Nov 2011 10:17:45 -0500
Message-ID: <20111109151745.GA1810@localhost.localdomain>
References: <4EB1ED83.8010301@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@Oracle.COM>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB1ED83.8010301@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 03, 2011 at 10:25:23AM +0900, Tsutomu Itoh wrote:
> In integration-scrub branch, following warning messages were displayed by
> running xfstests.
> 
> # btrfs fi sh /dev/sdd4
> Label: none  uuid: 8f28d85c-e37c-4c1b-adef-2627ca59be78
>         Total devices 2 FS bytes used 31.49MB
>         devid    1 size 9.31GB used 9.31GB path /dev/sdd4
>         devid    2 size 15.01GB used 9.29GB path /dev/sdc1
> 
> Btrfs Btrfs v0.19
> # mount
> ...
> /dev/sdd4 on /test7 type btrfs (rw,compress=lzo)
> #
> 

Can you try this patch I just posted?

[PATCH] Btrfs: only map pages if we know we need them when reading the space
cache

Thanks,

Josef
