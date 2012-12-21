Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31356 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2LUCEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 21:04:33 -0500
MIME-Version: 1.0
Message-ID: <0eda185f-0c8c-4928-baa9-9bb0cc43e43d@default>
Date: Thu, 20 Dec 2012 18:03:33 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: RE: [PATCH 0/3] Update LZO compression
References: <cover.1349621096.git.markus@oberhumer.com>
 <20121009122614.569b9535.akpm@linux-foundation.org>
 <50748113.80408@oberhumer.com> <201210111141.27270.arnd@arndb.de>
 <5076F3AC.8020304@oberhumer.com>
In-Reply-To: <5076F3AC.8020304@oberhumer.com>
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> From: Markus F.X.J. Oberhumer [mailto:markus@oberhumer.com]
> Subject: Re: [PATCH 0/3] Update LZO compression
> 
> Thanks Arnd,
> 
> On 2012-10-11 13:41, Arnd Bergmann wrote:
> > On Tuesday 09 October 2012, Markus F.X.J. Oberhumer wrote:
> >>>
> >>> : This commit updates the kernel LZO code to the current upsteam version
> >>> : which features a significant speed improvement - benchmarking the Calgary
> >>> : and Silesia test corpora typically shows a doubled performance in
> >>> : both compression and decompression on modern i386/x86_64/powerpc machines.
> >>>
> >>> There are significant clients of the LZO library - crypto, btrfs,
> >>> jffs2, ubifs, squashfs and zcache.  So let's give all those people a cc
> >>> and ask that they test the LZO changes once they land in linux-next.
> >>> For correctness and performance, please.
> >>
> >> The core compression and decompression code has been thoroughly tested, so I
> >> do not expect major problems.
> >>
> >> Good testing after the merge and feedback about build or performance issues
> >> (and improvements!) is highly appreciated.
> >
> > The addition of the lzo tree to linux-next caused this problem for ARM
> > imx_v6_v7_defconfig:
> >
> > In file included from /home/arnd/linux-arm/arch/arm/boot/compressed/decompress.c:40:0:
> > /home/arnd/linux-arm/arch/arm/boot/compressed/../../../../lib/decompress_unlzo.c:34:34: fatal error:
> lzo/lzo1x_decompress.c: No such file or directory
> >
> > Since the file was renamed, anything including it needs to be updated to the
> > new file name.
> 
> I will add that patch to my tree.
> 
> Cheers,
> Markus

Sorry if I missed it (bad connectivity this week), but is someone going
to send a pull request to get this LZO update from linux-next into
Linus's tree?  The window is closing soon isn't it?

Dan
