Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55275 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751316AbdIOSN4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 14:13:56 -0400
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Chris Murphy <lists@colorremedies.com>
CC: Adam Borowski <kilobyte@angband.pl>, "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
Date: Fri, 15 Sep 2017 18:13:42 +0000
Message-ID: <BD578B81-138D-4E7C-856A-D0D9B8BDB091@fb.com>
References: <20170724172939.24527-1-dsterba@suse.com>
 <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
 <20170805012745.g44pyqgb42z6jvro@angband.pl>
 <336A13CC-78FC-4CAC-9258-0336D7683AE3@fb.com>
 <20170818160838.GB2866@twin.jikos.cz>
 <CAJCQCtRsTSypEVx7iVG+TCojqL30Q15xZH2PYiZq3HdqLqwa9A@mail.gmail.com>
 <20170915145116.GZ29043@twin.jikos.cz>
In-Reply-To: <20170915145116.GZ29043@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/15/17, 7:53 AM, "David Sterba" <dsterba@suse.cz> wrote:
> On Sun, Aug 20, 2017 at 06:38:50PM -0600, Chris Murphy wrote:
> > On Fri, Aug 18, 2017 at 10:08 AM, David Sterba <dsterba@suse.cz> wrote:
> > 
> > > That's quite a lot, in kernel. IIRC zlib and lzo use less than 200kb,
> > > zstd wants 800kb for level 1. And this needs to be contiguous memory, so
> > > if we're lucky and get the memory at the mount time, fine. In general
> > > the memory can be fragmented (in the worst case, there are only 4k
> > > chunks available), so we'd have to vmalloc and consume the virtual,
> > > mappings in great numbers.
> > 
> > Any thoughts on bootloader support, both in general, and as it relates
> > to levels of compression and memory constraints? GRUB switches to
> > protected mode early on but other bootloaders might have more
> > limitations. I guess really it's just GRUB and extlinux right now,
> > there were patches some time ago for Das U-Boot but they still aren't
> > merged.
> 
> I'm not sure if the memory requirements are same for compression and
> decompression. The table is related to compression. I've looked around
> web to find what the decompression requirements are but havne't found
> anything.

In the BtrFS implementation, the same workspaces are used both for
compression and decompression, so they allocate enough memory for
compression. Decompression requires a constant 550 KB with a 128 KB window
size (which BtrFS has). You can find the numbers using the functions
ZSTD_estimateCStreamSize() and ZSTD_estimateDStreamSize().


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
