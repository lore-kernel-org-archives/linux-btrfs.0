Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw-01.dd24.net ([193.46.215.41]:48544 "EHLO
        mailgw-01.dd24.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932257AbeCMUKq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 16:10:46 -0400
Message-ID: <1520971842.4242.9.camel@scientia.net>
Subject: Re: Ongoing Btrfs stability issues
From: Christoph Anton Mitterer <calestyo@scientia.net>
To: kreijack@inwind.it
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Tue, 13 Mar 2018 21:10:42 +0100
In-Reply-To: <d6e007af-7980-3d9b-a497-acb3be90dac9@inwind.it>
References: <SN2PR03MB22697EDC5BC991C819353117A9F40@SN2PR03MB2269.namprd03.prod.outlook.com>
         <3b483ff8-cd89-d62a-67d8-d1da6a28ef64@gmail.com>
         <595ED26B-1FCD-4693-8E11-8F4CB267D1C7@oseberg.io>
         <0ca621b4-6307-1acf-65b7-4584dd678d80@suse.com>
         <20180302172951.GC30920@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
         <DBEFB1DF-D6A7-48D9-AF90-88759597A777@oseberg.io>
         <fc88341d-e440-3007-4b54-e21f74182036@suse.com>
         <D15AA258-5C89-433A-94E3-6C16A0DA4297@oseberg.io>
         <5a12a7b7-6cf3-82f8-d5fa-2915fc3d6680@suse.com>
         <1520692153.24363.15.camel@scientia.net>
         <01ddb562-f1e2-25cf-0a8a-ffaa43b867d3@libero.it>
         <1520807872.4281.11.camel@scientia.net>
         <3fd8f21b-2e4d-3696-8e92-a20e4dda13ec@inwind.it>
         <1520891338.4266.16.camel@scientia.net>
         <d6e007af-7980-3d9b-a497-acb3be90dac9@inwind.it>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2018-03-13 at 20:36 +0100, Goffredo Baroncelli wrote:
> A checksum mismatch, is returned as -EIO by a read() syscall. This is
> an event handled badly by most part of the programs.
Then these programs must simply be fixed... otherwise they'll also fail
under normal circumstances with btrfs, if there is any corruption.


> The problem is the following: there is a time window between the
> checksum computation and the writing the data on the disk (which is
> done at the lower level via a DMA channel), where if the data is
> update the checksum would mismatch. This happens if we have two
> threads, where the first commits the data on the disk, and the second
> one updates the data (I think that both VM and database could behave
> so).
Well that's clear... but isn't that time frame also there if the extent
is just written without CoW (regardless of checksumming)?
Obviously there would need to be some protection here anyway, so that
such data is taken e.g. from RAM, before the write has completed, so
that the read wouldn't take place while the write has only half
finished?!
So I'd naively assume one could just enlarge that protection to the
completion of checksum writing,...



> In btrfs, a checksum mismatch creates an -EIO error during the
> reading. In a conventional filesystem (or a btrfs filesystem w/o
> datasum) there is no checksum, so this problem doesn't exist.
If ext writes an extent (can't that be up to 128MiB there?), then I'm
sure it cannot write that atomically (in terms of hardware)... so there
is likely some protection around this operation, that there are no
concurrent reads of that particular extent from the disk, while the
write hasn't finished yet.



> > Even if not... I should be only a problem in case of a crash during
> > that,.. and than I'd still prefer to get the false positive than
> > bad
> > data.
> 
> How you can know if it is a "bad data" or a "bad checksum" ?
Well as I've said, in my naive thinking this should only be a problem
in case of a crash... and then, yes, one cannot say whether it's bad
data or checksum (that's exactly what I'm saying)... but I rather
prefer to know that something might be fishy, then not knowing anything
and perhaps even get good data "RAID-repaired" with bad one...


Cheers,
Chris.
