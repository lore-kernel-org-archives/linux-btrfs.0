Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36730 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbcEPLdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 07:33:54 -0400
Received: by mail-ig0-f171.google.com with SMTP id qe5so47690253igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 04:33:54 -0700 (PDT)
Subject: Re: BTRFS Data at Rest File Corruption
To: Chris Murphy <lists@colorremedies.com>,
        "Richard A. Lochner" <lochner@clone1.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
 <1463075341.3636.56.camel@clone1.com>
 <CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
 <1463114957.3636.140.camel@clone1.com>
 <CAJCQCtSNwpaPs6jWFxzoHdUFJUyUZFjX6vocYf7RCWc=f_n5Hg@mail.gmail.com>
 <1463337834.4626.14.camel@clone1.com>
 <CAJCQCtSYgfhmNYFE4ffxFy20B=trkh+P=hhdbrq71ysZSm_FEA@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <41b097af-d565-6cd7-2ed8-cb66b9ae8ecc@gmail.com>
Date: Mon, 16 May 2016 07:33:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSYgfhmNYFE4ffxFy20B=trkh+P=hhdbrq71ysZSm_FEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-16 02:07, Chris Murphy wrote:
> Current hypothesis
>  "I suspected, and I still suspect that the error occurred upon a
> metadata update that corrupted the checksum for the file, probably due
> to silent memory corruption.  If the checksum was silently corrupted,
> it would be simply written to both drives causing this type of error."
>
> A metadata update alone will not change the data checksums.
>
> But let's ignore that. If there's corrupt extent csum in a node that
> itself has a valid csum, this is functionally identical to e.g.
> nerfing 100 bytes of a file's extent data (both copies, identically).
> The fs doesn't know the difference. All it knows is the node csum is
> valid, therefore the data extent csum is valid, and that's why it
> assumes the data is wrong and hence you get an I/O error. And I can
> reproduce most of your results by nerfing file data.
>
> The entire dmesg for scrub looks like this:
>
>
> May 15 23:29:46 f23s.localdomain kernel: BTRFS warning (device dm-6):
> checksum error at logical 5566889984 on dev /dev/dm-6, sector 8540160,
> root 5, inode 258, offset 0, length 4096, links 1 (path:
> openSUSE-Tumbleweed-NET-x86_64-Current.iso)
> May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
> bdev /dev/dm-6 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
> unable to fixup (regular) error at logical 5566889984 on dev /dev/dm-6
> May 15 23:29:46 f23s.localdomain kernel: BTRFS warning (device dm-6):
> checksum error at logical 5566889984 on dev /dev/mapper/VG-b1, sector
> 8579072, root 5, inode 258, offset 0, length 4096, links 1 (path:
> openSUSE-Tumbleweed-NET-x86_64-Current.iso)
> May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
> bdev /dev/mapper/VG-b1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
> unable to fixup (regular) error at logical 5566889984 on dev
> /dev/mapper/VG-b1
>
> And the entire dmesg for running sha256sum on the file is
>
> May 15 23:33:41 f23s.localdomain kernel: __readpage_endio_check: 22
> callbacks suppressed
> May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
> csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
> May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
> csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
> May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
> csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
> May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
> csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
> May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
> csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
>
>
> And I do get an i/o error for sha256sum and no hash is computed.
>
> But there's two important differences:
> 1. I have two unable to fixup messages, one for each device, at the
> exact same time.
> 2. I altered both copies of extent data.
>
> It's a mystery to me how your file data has not changed, but somehow
> the extent csum was changed but also the node csum was recomputed
> correctly. That's a bit odd.
I would think this would be perfectly possible if some other file that 
had a checksum in that node changed, thus forcing the node's checksum to 
be updated.  Theoretical sequence of events:
1. Some file which has a checksum in node A gets written to.
2. Node A is loaded into memory to update the checksum.
3. The new checksum for the changed extent in the file gets updated in 
the in-memory copy of node A.
4. Node A has it's own checksum recomputed based on the new data, and 
then gets saved to disk.
If something happened after 2 but before 4 that caused one of the other 
checksums to go bad, then the checksum computed in 4 will have been with 
the corrupted data.

