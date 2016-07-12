Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36001 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbcGLWrb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 18:47:31 -0400
Received: by mail-pa0-f50.google.com with SMTP id pp5so4152300pac.3
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 15:47:24 -0700 (PDT)
Date: Tue, 12 Jul 2016 15:47:12 -0700
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, Anatoly Pugachev <matorola@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, sparclinux@vger.kernel.org,
        debian-sparc <debian-sparc@lists.debian.org>
Subject: Re: btrfs module does not load on sparc64
Message-ID: <20160712224712.GA7880@vader.DHCP.thefacebook.com>
References: <CADxRZqwhBoc9sNxxZ4a9ZJ0JiYWiL9xtG8T_ws4i61YrtNHtHg@mail.gmail.com>
 <20160711100646.GS13336@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160711100646.GS13336@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 12:06:46PM +0200, David Sterba wrote:
> On Thu, Jul 07, 2016 at 05:29:35PM +0300, Anatoly Pugachev wrote:
> > Compiled linux kernel (git version 4.7.0-rc6+) using my own kernel
> > config file, enabling :
> > 
> > CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
> > CONFIG_BTRFS_DEBUG=y
> > CONFIG_BTRFS_ASSERT=y
> > 
> > and now I can't load btrfs module:
> > 
> > # modprobe btrfs
> > modprobe: ERROR: could not insert 'btrfs': Invalid argument
> > 
> > 
> > and in logs (and on console):
> > 
> > [1897399.942697] Btrfs loaded, crc32c=crc32c-generic, debug=on, assert=on
> > [1897400.024645] BTRFS: selftest: sectorsize: 8192  nodesize: 8192
> > [1897400.098089] BTRFS: selftest: Running btrfs free space cache tests
> > [1897400.175863] BTRFS: selftest: Running extent only tests
> > [1897400.241871] BTRFS: selftest: Running bitmap only tests
> > [1897400.307877] BTRFS: selftest: Running bitmap and extent tests
> > [1897400.380329] BTRFS: selftest: Running space stealing from bitmap to extent
> > [1897400.470517] BTRFS: selftest: Free space cache tests finished
> > [1897400.542875] BTRFS: selftest: Running extent buffer operation tests
> > [1897400.621710] BTRFS: selftest: Running btrfs_split_item tests
> > [1897400.692929] BTRFS: selftest: Running extent I/O tests
> > [1897400.757459] BTRFS: selftest: Running find delalloc tests
> > [1897401.082670] BTRFS: selftest: Running extent buffer bitmap tests
> > [1897401.161223] BTRFS: selftest: Setting straddling pages failed
> 
> The sanity tests fail at some point with EINVAL, so the module will fail
> to load in turn. Looking at the test itself (__test_eb_bitmaps), it does
> no make any assumptions about page size etc. so this "should work".
> Taking powerpc with 64k page size for another reference where the tests
> work, I'm not sure what exactly could be wrong here.

This is an endianness problem with the test. It's not showing up on
powerpc because ed9e4afdb055 ("Btrfs: self-tests: Execute page
straddling test only when nodesize < PAGE_SIZE") [1] disabled that chunk
of the test. It also fails on a big-endian MIPS QEMU system with 16K
pages. I'll send up a patch.

1: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ed9e4afdb0551e3ef4ee8433fe664433a20ef73a

-- 
Omar
