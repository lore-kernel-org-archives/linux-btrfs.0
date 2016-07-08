Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245AbcGHNuv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 09:50:51 -0400
Date: Fri, 8 Jul 2016 15:51:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Laszlo Fiat <laszlo.fiat@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: errors with linux-next-20160701
Message-ID: <20160708135108.GH13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+7w51htypyk_RAUmf0i_12JSawq0BvKckSUk=sqyLHVkwvJNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+7w51htypyk_RAUmf0i_12JSawq0BvKckSUk=sqyLHVkwvJNA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 07, 2016 at 08:15:18PM +0200, Laszlo Fiat wrote:
> I have a simple btrfs filesystem on a single device. It worked well so far.
> 
> Recently I compiled a new kernel linux-next-20160701, with this new
> kernel I get warnings and errors in the logs.

I hope you're aware that using linux-next can lead to all sorts of
problems.

> But btrfs scrub
> completes with 0 errors, and if I boot back to the older
> linux-next-20160527 kernel, there are no error messages in the logs
> when using it or running scrub.

There's other involved party, device mapper so this is another factor to
be taken into account when you compare the kernels.

> The filesystem is mountable
> read-write, but I am worried about the warnings and errors. The
> checksum warnings always come up with new numbers, never the same.

This looks likes random memory overwrites, but that's just a guess.

> $ uname -a
> Linux debian 4.7.0-rc5-next-20160701+ #46 SMP Sun Jul 3 15:29:10 CEST
> 2016 x86_64 GNU/Linux
> 
> $ btrfs --version
> btrfs-progs v4.5.2
> 
> # btrfs fi show
> Label: none  uuid: d6cab9ca-5e89-4d8c-b55b-c700a6096d37
>     Total devices 1 FS bytes used 55.31GiB
>     devid    1 size 119.23GiB used 62.07GiB path /dev/mapper/home
> 
> # btrfs fi df /home
> Data, single: total=59.01GiB, used=54.86GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=1.50GiB, used=462.56MiB
> GlobalReserve, single: total=88.42MiB, used=0.00B
> 
> # dmesg | grep Btrfs
> [    4.530960] Btrfs loaded, crc32c=crc32c-intel
> 
> # dmesg | grep BTRFS
> [    4.530968] BTRFS: selftest: sectorsize: 4096  nodesize: 4096
> [    4.530973] BTRFS: selftest: sectorsize: 4096  nodesize: 8192
> [    4.530978] BTRFS: selftest: sectorsize: 4096  nodesize: 16384
> [    4.530982] BTRFS: selftest: sectorsize: 4096  nodesize: 32768
> [    4.530986] BTRFS: selftest: sectorsize: 4096  nodesize: 65536
> [   52.114886] BTRFS: device fsid d6cab9ca-5e89-4d8c-b55b-c700a6096d37
> devid 1 transid 29825 /dev/dm-0
> [   60.598254] BTRFS info (device dm-0): use lzo compression
> [   60.598266] BTRFS info (device dm-0): disk space caching is enabled
> [   60.598273] BTRFS info (device dm-0): has skinny extents
> [   60.797475] BTRFS warning (device dm-0): dm-0 checksum verify
> failed on 343146496 wanted D962670F found 32292342 level 0
> [   60.850008] BTRFS info (device dm-0): detected SSD devices, enabling SSD mode
> [  165.491150] BTRFS error (device dm-0): bad tree block start
> 8242807833012638730 658522112

A quick sanity check of the values:

8242807833012638730 == 0x7264560d4686940a

which does not look like a valid block pointer (as it's supposed to be
aligned to 4k, ie. ending with 000). This looks like the block has been
overwritten externally.

> # grep "BTRFS error" /var/log/syslog.1
> Jul  6 19:35:23 debian kernel: [ 2712.823929] BTRFS error (device
> dm-0): bad tree block start 10283429131165574676 662503424
> Jul  6 19:35:23 debian kernel: [ 2712.850468] BTRFS error (device
> dm-0): bad tree block start 14801127411347629381 663502848
> Jul  6 19:35:23 debian kernel: [ 2712.888038] BTRFS error (device
> dm-0): bad tree block start 9855282569545798023 664141824
> Jul  6 19:35:23 debian kernel: [ 2712.888491] BTRFS error (device
> dm-0): bad tree block start 12220505751590977444 664207360
> Jul  6 19:35:59 debian kernel: [ 2748.728044] BTRFS error (device
> dm-0): bad tree block start 16324583772582058537 665927680
> Jul  6 19:37:31 debian kernel: [ 2840.465648] BTRFS error (device
> dm-0): bad tree block start 13618790082605902229 309936128
> Jul  6 19:37:31 debian kernel: [ 2840.465672] BTRFS error (device
> dm-0): bad tree block start 9260130888975445835 309870592
> Jul  6 19:37:31 debian kernel: [ 2840.466526] BTRFS error (device
> dm-0): bad tree block start 17351834078110360434 309968896
> Jul  6 19:37:31 debian kernel: [ 2840.466579] BTRFS error (device
> dm-0): bad tree block start 3476538019772833052 309985280
> Jul  6 19:37:31 debian kernel: [ 2840.509021] BTRFS error (device
> dm-0): bad tree block start 1881224518785478735 327696384
> Jul  6 19:37:31 debian kernel: [ 2840.509085] BTRFS error (device
> dm-0): bad tree block start 14212257183956925500 327712768
> Jul  6 19:37:31 debian kernel: [ 2840.533393] BTRFS error (device
> dm-0): bad tree block start 13574459615317154064 331268096
> Jul  6 19:37:53 debian kernel: [ 2862.852848] BTRFS error (device
> dm-0): bad tree block start 13618790082605902229 309936128
> Jul  7 19:52:05 debian kernel: [  165.491150] BTRFS error (device
> dm-0): bad tree block start 8242807833012638730 658522112

The other 'start' values are also bogus block pointers.

I don't see an apparent cause of the errors, but this kind of reports
usually points to external factors, so I don't think it's a btrfs bug.
