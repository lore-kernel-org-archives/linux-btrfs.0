Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:32937 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcEPGHD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 02:07:03 -0400
Received: by mail-oi0-f65.google.com with SMTP id t140so14300468oie.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 23:07:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1463337834.4626.14.camel@clone1.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	<97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
	<1463075341.3636.56.camel@clone1.com>
	<CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
	<1463114957.3636.140.camel@clone1.com>
	<CAJCQCtSNwpaPs6jWFxzoHdUFJUyUZFjX6vocYf7RCWc=f_n5Hg@mail.gmail.com>
	<1463337834.4626.14.camel@clone1.com>
Date: Mon, 16 May 2016 00:07:01 -0600
Message-ID: <CAJCQCtSYgfhmNYFE4ffxFy20B=trkh+P=hhdbrq71ysZSm_FEA@mail.gmail.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: Chris Murphy <lists@colorremedies.com>
To: "Richard A. Lochner" <lochner@clone1.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current hypothesis
 "I suspected, and I still suspect that the error occurred upon a
metadata update that corrupted the checksum for the file, probably due
to silent memory corruption.  If the checksum was silently corrupted,
it would be simply written to both drives causing this type of error."

A metadata update alone will not change the data checksums.

But let's ignore that. If there's corrupt extent csum in a node that
itself has a valid csum, this is functionally identical to e.g.
nerfing 100 bytes of a file's extent data (both copies, identically).
The fs doesn't know the difference. All it knows is the node csum is
valid, therefore the data extent csum is valid, and that's why it
assumes the data is wrong and hence you get an I/O error. And I can
reproduce most of your results by nerfing file data.

The entire dmesg for scrub looks like this:


May 15 23:29:46 f23s.localdomain kernel: BTRFS warning (device dm-6):
checksum error at logical 5566889984 on dev /dev/dm-6, sector 8540160,
root 5, inode 258, offset 0, length 4096, links 1 (path:
openSUSE-Tumbleweed-NET-x86_64-Current.iso)
May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
bdev /dev/dm-6 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
unable to fixup (regular) error at logical 5566889984 on dev /dev/dm-6
May 15 23:29:46 f23s.localdomain kernel: BTRFS warning (device dm-6):
checksum error at logical 5566889984 on dev /dev/mapper/VG-b1, sector
8579072, root 5, inode 258, offset 0, length 4096, links 1 (path:
openSUSE-Tumbleweed-NET-x86_64-Current.iso)
May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
bdev /dev/mapper/VG-b1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
May 15 23:29:46 f23s.localdomain kernel: BTRFS error (device dm-6):
unable to fixup (regular) error at logical 5566889984 on dev
/dev/mapper/VG-b1

And the entire dmesg for running sha256sum on the file is

May 15 23:33:41 f23s.localdomain kernel: __readpage_endio_check: 22
callbacks suppressed
May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141
May 15 23:33:41 f23s.localdomain kernel: BTRFS warning (device dm-6):
csum failed ino 258 off 0 csum 3634944209 expected csum 1334657141


And I do get an i/o error for sha256sum and no hash is computed.

But there's two important differences:
1. I have two unable to fixup messages, one for each device, at the
exact same time.
2. I altered both copies of extent data.

It's a mystery to me how your file data has not changed, but somehow
the extent csum was changed but also the node csum was recomputed
correctly. That's a bit odd.




Chris Murphy
