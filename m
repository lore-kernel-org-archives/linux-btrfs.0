Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:50583 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbdIOC0j (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 22:26:39 -0400
Received: by mail-wm0-f45.google.com with SMTP id v142so4767038wmv.5
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 19:26:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <928da79f-4373-dd95-d458-1b136146b704@gmail.com>
References: <20170831070558.GB5783@rus.uni-stuttgart.de> <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de> <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de> <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <928da79f-4373-dd95-d458-1b136146b704@gmail.com>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 15 Sep 2017 03:26:37 +0100
Message-ID: <CABB28Cwd2efbDzF3uK01VQcWdMJ_ABf8z_Q4MfWz30=xuLLCHw@mail.gmail.com>
Subject: Re: defragmenting best practice?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14 September 2017 at 19:53, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
[..]
> While it's not for BTRFS< a tool called e4rat might be of interest to you
> regarding this.  It reorganizes files on an ext4 filesystem so that stuff
> used by the boot loader is right at the beginning of the device, and I've
> know people to get insane performance improvements (on the order of 20x in
> some pathologicallyb ad cases) in the time taken from the BIOS handing
> things off to GRUB to GRUB handing execution off to the kernel.

Do you know that what you've just wrote has nothing to do with fragmentation?
Intentionally or not you just trying to change the subject.

[..]
> This shouldn't need examples.  It's trivial math combined with basic
> knowledge of hardware behavior.  Every request to a device has a minimum
> amount of overhead.  On traditional hard drives, this is usually dominated
> by seek latency, but on SSD's, the request setup, dispatch, and completion
> are the dominant factor.  Assumign you have a 2 micro-second overhead
> per-request (not an exact number, just chosen for demonstration purposes
> because it makes the math easy), and a 1GB file, the time difference between
> reading ten 100MB extents and reading ten thousand 100kB extents is just
> short of 0.02 seconds, or a factor of about one thousand (which, no surprise
> here, is the factor of difference between the number of extents).

So to produce few seconds delay during boot you need to make few
hundreds thousands if not millions more IOs  and on reading everything
using ideal long sequential reads.
Almost every package upgrade on rewrite some files in 100% will
produce by using COW fully continuous areas per file.
You know .. there is no so many files in typical distribution
installation to produce such measurable impact.
On my current laptop I have a lot of devel and debug stuff installed
and still I have only

$ rpm -qal | wc -l
276489

files (from which only small fractions are ELF DSOs or executables)
installed by:

$ rpm -qa | wc -l
2314

packages.

I can bet that during even very complicated boot process it will be
touched (by read IOs) only few hundreds files. None of those files
will be read sequentially because this is not how executable content
is usually loaded into the buffer cache. Simple change block device
read ahead may improve boot time enough without putting all blocks in
perfect order. All what you need is start enough early "blockdev
--setra N" where N is greater than default 256 blocks. All this can be
done without thinking about fragmentation.
Seems you don't know that Linux by default is reading data from block
dev using at least 256 blocks (1KB each one) chunks because such IO
size is part of default RA settings, You can change those settings
just for boot time and you will have way lower number of IOs and sill
no significant improvement like few times shorter time. Fragmentation
will be in such case secondary factor.
All this could be done without bothering about fragmentation.

In other words still you are talking about some institutionally
possible results which will be falsified if you will try at least one
time do some real tests and measurements.
Last time when I've been doing some boot time measurements it was
about using sequential start of all services vs. maximum
palatalization. And yes by this it was possible to improve boot time
by few times. All without bothering about fragmentation.

Current fedora systemd base services definition can be improved in
many places by add more dependencies and execute many small services
in parallel. All those corrections can be done without even thinking
about fragmentation. Because these base sett of systemd services comes
with systemd source code those improvements can be done for almost all
Linux systemd based distros.

kloczek
