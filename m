Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44342 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3CPSQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 14:16:58 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How to recover uncorrectable errors ?
Date: Sat, 16 Mar 2013 19:16:54 +0100
Cc: =?utf-8?q?Fr=C3=A9d=C3=A9ric_COIFFIER?= <frederic.coiffier@free.fr>
References: <6033676.gK0GbPgrpE@athlonxp> (sfid-20130308_132012_518626_1D5201B4)
In-Reply-To: <6033676.gK0GbPgrpE@athlonxp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201303161916.55185.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 8. März 2013 schrieb Frédéric COIFFIER:
> Hi,

Hi Frédéric,

> I'm using a Linux 3.7.6 (Gentoo Linux) with btrfs-progs-0.20_rc1_p56 and since few days, I have some uncorrectable errors :
> 
> # btrfs scrub status /
> scrub status for 6b6ea99b-edee-498d-bf07-f3a3f1cba2f3
>         scrub started at Thu Mar  7 20:12:31 2013 and finished after 515 seconds
>         total bytes scrubbed: 31.02GB with 6 errors
>         error details: csum=6
>         corrected errors: 0, uncorrectable errors: 6, unverified errors: 0
> 
> I don't know what has produced this error (maybe an hard reset or a power cut) but I use an old not-SSD hard-disk.

This disk is still fine? Is smartctl -a happy with it?

> I have discovered this problem thanks to several errors in dmesg when I try to access to a file :
> 
> [ 2985.163718] btrfs: sda2 checksum verify failed on 26326409216 wanted 59A31CB1 found DFB0FE7F level 0
> [ 2985.169191] btrfs: sda2 checksum verify failed on 26326409216 wanted 59A31CB1 found DFB0FE7F level 0
[…]
> If I restart a btrfs scrub, I get these messages :
> 
> [ 3047.835131] btrfs: checksum error at logical 272228352 on dev /dev/sda2, sector 548080: metadata leaf (level 0) in tree 5
> [ 3047.835134] btrfs: checksum error at logical 272228352 on dev /dev/sda2, sector 548080: metadata leaf (level 0) in tree 5
> [ 3047.835137] btrfs: bdev /dev/sda2 errs: wr 0, rd 0, flush 0, corrupt 20, gen 0
> [ 3047.953751] btrfs: unable to fixup (regular) error at logical 272228352 on dev /dev/sda2
[…]
> I tried a LiveCD to make a btrfsck [I have to check its version] but it segfaults during the test.
> 
> Today, I can't remove the file (and I can't delete its directory), updatedb runs during hours when it tries to read this file.
> So, what is the best way to recover these errors (as I think that some files are definitely lost) ?
> I would like to identify the corrupted files and to delete them.

I thought that with recent kernels BTRFS would report the file which is
affected, but here it doesn´t seem so.

I think its also possibe to find out the file from the block number. But I
do not remember the direct way to do it. I only know the other way around
with filefrag -v or hdparm --fibmap - well actually file thinking on it,
vice versa needs to have knowledge of filesystem structure… Maybe its
possible to map something in the output in btrfs-debug-tree to above output.

But I really think BTRFS displays the filename affected meanwhile. So
maybe if it does not, its some metadata being affected? So output of btrfsck
hints at that and that you can´t remove the file does as well. What happens
if you try to remove the file? Do you get an input/output error or
something like that?

Maybe someone else can help with that.

Aside from that: Thats uncorrectable errors for a reason :)

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
