From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs-progs: btrfs file system size should be bigger
 then 256m
Date: Mon, 05 Jan 2009 11:39:36 -0500
Message-ID: <1231173576.4290.138.camel@think.oraclecorp.com>
References: <49621CBA.2080802@wpkg.org> <49622525.80001@schleiser.de>
	 <49622BFC.7040105@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Kaspar Schleiser <kaspar@schleiser.de>, linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49622BFC.7040105@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-05 at 16:49 +0100, Tomasz Chmielewski wrote:
> Kaspar Schleiser schrieb:
> > Hey,
> > 
> > Tomasz Chmielewski wrote:
> >>> This has been bothering me for some time. Why does btrfs need to have 
> >>> a disk greater then 256M? I could see a much smaller limit, say 16M 
> >>> but why so much? The file system itself does not need that much space 
> >>> for its own use.
> >>
> >> In other words, 256M limit rather disqualifies btrfs as a filesystem 
> >> i.e. for /boot, doesn't it?
> > When 1G is just 10c?
> 
> Maybe when talking about traditional HDDs.
> Anything flash-based is still $2-$5 per 1G.
> 
> I have some SAN devices booting off 512MB or 1G builtin flash. Having 
> 256M for /boot there would not leave much more space for the operating 
> system.
> 
> Why separate /boot? It's still needed for encrypted rootfs or more fancy 
> partitioning (like / on LVM, at least until GRUB2 is stable and is 
> shipped by major distros).
> 
> 
> Seriously, what are the technical reasons that btrfs needs so much space 
> for a minimal filesystem?

This is mostly to help prevent crashes on enospc.  As we fixup the
kernel code, the 256MB limit will go away.

-chris


