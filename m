Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16512 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3LBJVk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Dec 2013 04:21:40 -0500
Message-ID: <529C5111.4060406@cn.fujitsu.com>
Date: Mon, 02 Dec 2013 17:21:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
CC: Shilong Wang <wangshilong1991@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: 2 errors when scrubbing - but I don't know what they mean
References: <pan$e58f7$107ceb0e$e753a400$c76bf1d5@cox.net>	<5299CC95.6010704@informatik.uni-bonn.de> <CAP9B-Q=Y+uY2kErYb1ZKMsvFrbYidmGpPnUbHm8iApj7v6wK+w@mail.gmail.com> <529BA004.2000202@informatik.uni-bonn.de>
In-Reply-To: <529BA004.2000202@informatik.uni-bonn.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sebastian,

On 12/02/2013 04:45 AM, Sebastian Ochmann wrote:
> Hello,
>
> > However, if you find such superblocks checksum mismatch very often
> > during scrub, it maybe
> > there are something wrong with disk!
>
> I'm sorry, but I don't think there's a problem with my disks because I 
> was able to trigger the errors that increment the "gen" error counter 
> during scrub on a completely different machine and drive today. I 
> basically performed some I/O operations on a drive and scrubbed at the 
> same time over and over again until I actually saw "super" errors 
> during scrub. But the error is reeally hard to trigger. It seems to me 
> like a race condition somewhere.
I am sorry, i try to reproduce the problem as steps what you have said, 
it didn't come up yet(i have run it for more than 6 hours).:-(
I took a careful look at code.

Superblock generation mismatch can only happen in 
scrub_checksum_super(). The generation mismatch happens when:
superblocks' gen ! = last_trans_commited.

While we can only modify value 'last_trans_commited' in one 
place(commiting transaction), However, in commiting transaction before
changing last_trans_commited, we will call btrfs_scrub_pause() which 
make it impossible that srubbing and writting supers
happen at the same time. Otherwise, i must miss some important thing 
here:-)

Would you please have a try with btrfs-next and see if the problem still 
exist in that branch:
https://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/

Thanks,
Wang
>
> So I went a step further and tried to create a repro for this. It 
> seems like I can trigger the errors now once every few minutes with 
> the method described below, but sometimes it really takes a long time 
> until the error pops up, so be patient when trying this...
>
> For the repro:
>
> I'm using a btrfs image in RAM for this for two reasons: I can scrub 
> quickly over and over again and I can rule our hard drive errors. My 
> machine has 32 GB of RAM, so that comes in handy here - if you try 
> this on a physical drive, make sure to adjust some parameters, if 
> necessary.
>
> Create a tmpfs and a testing image, format as btrfs:
>
> $ mkdir btrfstest
> $ cd btrfstest/
> $ mkdir tmp
> $ mount -t tmpfs -o size=20G none tmp
> $ dd if=/dev/zero of=tmp/vol bs=1G count=19
> $ mkfs.btrfs tmp/vol
> $ mkdir mnt
> $ mount -o commit=1 tmp/vol mnt
>
> Note the "commit=1" mount option. It's not strictly necessary, but I 
> have the feeling it helps with triggering the problem...
>
> So now we have a 19 GB btrfs filesystem in RAM, mounted in "mnt". What 
> I did for performing some artificial I/O operations is to rm and cp a 
> linux source tree over and over again. Suppose you have an unpacked 
> linux source tree available in the "/somewhere/linux" directory (and 
> you're using bash). We'll spawn some loops that keep the filesystem busy:
>
> $ while true; do rm -fr mnt/a; sleep 1.0; cp -R /somewhere/linux 
> mnt/a; sleep 1.0; done
> $ while true; do rm -fr mnt/b; sleep 1.1; cp -R /somewhere/linux 
> mnt/b; sleep 1.1; done
> $ while true; do rm -fr mnt/c; sleep 1.2; cp -R /somewhere/linux 
> mnt/c; sleep 1.2; done
>
> Now that the filesystem is busy, we'll also scrub it repeatedly 
> (without backgrounding, -B):
>
> $ while true; do btrfs scrub start -B mnt; sleep 0.5; done
>
> On my machine and in RAM, each scrub takes 0-1 second and the "total 
> bytes scrubbed" should fluctuate (seems to be especially true with 
> commit=1, but not sure). Get a beverage of your choice and wait.
>
> (about 10 minutes later)
>
> When I was writing this repro it took about 10 minutes until scrub said:
>
>   total bytes scrubbed: 1.20GB with 2 errors
>   error details: super=2
>   corrected errors: 0, uncorrectable errors: 0, unverified errors: 0
>
> and in dmesg:
>
>   [15282.155170] btrfs: bdev /dev/loop0 errs: wr 0, rd 0, flush 0, 
> corrupt 0, gen 1
>   [15282.155176] btrfs: bdev /dev/loop0 errs: wr 0, rd 0, flush 0, 
> corrupt 0, gen 2
>
> After that, scrub is happy again and will continue normally until the 
> same errors happen again after a few hundred scrubs or so.
>
> So all in all, the error can be triggered using normal I/O operations 
> and scrubbing at the right moments, it seems. Even with a btrfs image 
> in RAM, so no hard drive error is possible.
>
> Hope anyone can reproduce this and maybe debug it.
>
> Best regards
> Sebastian
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

