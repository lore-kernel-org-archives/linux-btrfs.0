Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:41355 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3LSTEZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 14:04:25 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so858778bkz.39
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Dec 2013 11:04:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
From: =?UTF-8?Q?F=C3=A1bio_Pfeifer?= <fmpfeifer@gmail.com>
Date: Thu, 19 Dec 2013 17:04:03 -0200
Message-ID: <CABtk0xQt7cJ8r+UicFjNgQ9nCKiw8-GYKAp46CYZFKnOVzOYSg@mail.gmail.com>
Subject: Re: btrfs on bcache
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any update on this?

I have here exactly the same issue. Kernel 3.12.5-1-ARCH, backing
device 500 GB IDE, cache 24 GB SSD => /dev/bcache0
On /dev/bcache I also have 2 subvolumes, / and /home. I get lots of
messages in dmesg:

(...)
[   22.282469] BTRFS info (device bcache0): csum failed ino 56193 off
212992 csum 519977505 expected csum 3166125439
[   22.282656] incomplete page read in btrfs with offset 1024 and length 3072
[   23.370872] incomplete page read in btrfs with offset 1024 and length 3072
[   23.370890] BTRFS info (device bcache0): csum failed ino 57765 off
106496 csum 3553846164 expected csum 1299185721
[   23.505238] incomplete page read in btrfs with offset 2560 and length 1536
[   23.505256] BTRFS info (device bcache0): csum failed ino 75922 off
172032 csum 1883678196 expected csum 1337496676
[   23.508535] incomplete page read in btrfs with offset 2560 and length 1536
[   23.508547] BTRFS info (device bcache0): csum failed ino 74368 off
237568 csum 2863587994 expected csum 2693116460
[   25.683059] incomplete page read in btrfs with offset 2560 and length 1536
[   25.683078] BTRFS info (device bcache0): csum failed ino 123709 off
57344 csum 1528117893 expected csum 2239543273
[   25.684339] incomplete page read in btrfs with offset 1024 and length 3072
[   26.622384] incomplete page read in btrfs with offset 1024 and length 3072
[   26.906718] incomplete page read in btrfs with offset 2560 and length 1536
[   27.823247] incomplete page read in btrfs with offset 1024 and length 3072
[   27.823265] btrfs_readpage_end_io_hook: 2 callbacks suppressed
[   27.823271] BTRFS info (device bcache0): csum failed ino 34587 off
16384 csum 1180114025 expected csum 474262911
[   28.490066] incomplete page read in btrfs with offset 2560 and length 1536
[   28.490085] BTRFS info (device bcache0): csum failed ino 65817 off
327680 csum 3065880108 expected csum 2663659117
[   29.413824] incomplete page read in btrfs with offset 1024 and length 3072
[   41.913857] incomplete page read in btrfs with offset 2560 and length 1536
[   55.761753] incomplete page read in btrfs with offset 1024 and length 3072
[   55.761771] BTRFS info (device bcache0): csum failed ino 72835 off
81920 csum 1511792656 expected csum 3733709121
[   69.636498] incomplete page read in btrfs with offset 2560 and length 1536
(...)

should I be worried?

thanks,

Fabio Pfeifer

2013/12/18 eb <eab@gmx.ch>:
> I've recently setup a system (Kernel 3.12.5-1-ARCH) which is layered as follows:
>
> /dev/sdb3 - cache0 (80 GB Intel SSD)
> /dev/sdc1 - backing device (2 TB WD HDD)
>
> sdb3+sdc1 => /dev/bcache0
>
> On /dev/bcache0, there's a btrfs filesystem with 2 subvolumes, mounted
> as / and /home. What's been bothering me are the following entries in
> my kernel log:
>
> [13811.845540] incomplete page write in btrfs with offset 1536 and length 2560
> [13870.326639] incomplete page write in btrfs with offset 3072 and length 1024
>
> The offset/length values are always either 1536/2560 or 3072/1024,
> they sum up nicely to 4K. There are 607 of those in there as I am
> writing this, the machine has been up 18 hours and been under no
> particular I/O strain (it's a desktop).
>
> Trying to fix this, I unattached the cache (still using /dev/bcache0,
> but without /dev/sdb3 attached), causing these errors to disappear. As
> soon as I re-attached /dev/sdb3 they started again, so I am fairly
> sure it's an unfavorable interaction between bcache and btrfs.
>
> Is this something I should be worried about (they're only emitted with
> KERN_INFO?) or just an alignment problem? The underlying HDD is using
> 4K-Sectors, while the block_size of bcache seems to be 512, could that
> be the issue here?
>
> I've also encountered incomplete reads and a few csum errors, but I
> have not been able to trigger these regularly. I have a feeling that
> the error is more likely  o be on the bcache end (I've mailed to that
> list as well), however any insight into the matter would be much
> appreciated.
>
> Thanks,
>
> - eb
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
