Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751115AbdIOOwt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 10:52:49 -0400
Date: Fri, 15 Sep 2017 16:51:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: David Sterba <dsterba@suse.cz>, Nick Terrell <terrelln@fb.com>,
        Adam Borowski <kilobyte@angband.pl>,
        "dsterba@suse.com" <dsterba@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH preview] btrfs: allow to set compression level for zlib
Message-ID: <20170915145116.GZ29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170724172939.24527-1-dsterba@suse.com>
 <689C76C1-60F4-4F1D-8AFF-C6250B788A49@fb.com>
 <20170805012745.g44pyqgb42z6jvro@angband.pl>
 <336A13CC-78FC-4CAC-9258-0336D7683AE3@fb.com>
 <20170818160838.GB2866@twin.jikos.cz>
 <CAJCQCtRsTSypEVx7iVG+TCojqL30Q15xZH2PYiZq3HdqLqwa9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRsTSypEVx7iVG+TCojqL30Q15xZH2PYiZq3HdqLqwa9A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 20, 2017 at 06:38:50PM -0600, Chris Murphy wrote:
> On Fri, Aug 18, 2017 at 10:08 AM, David Sterba <dsterba@suse.cz> wrote:
> 
> > That's quite a lot, in kernel. IIRC zlib and lzo use less than 200kb,
> > zstd wants 800kb for level 1. And this needs to be contiguous memory, so
> > if we're lucky and get the memory at the mount time, fine. In general
> > the memory can be fragmented (in the worst case, there are only 4k
> > chunks available), so we'd have to vmalloc and consume the virtual,
> > mappings in great numbers.
> 
> Any thoughts on bootloader support, both in general, and as it relates
> to levels of compression and memory constraints? GRUB switches to
> protected mode early on but other bootloaders might have more
> limitations. I guess really it's just GRUB and extlinux right now,
> there were patches some time ago for Das U-Boot but they still aren't
> merged.

I'm not sure if the memory requirements are same for compression and
decompression. The table is related to compression. I've looked around
web to find what the decompression requirements are but havne't found
anything.
