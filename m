From: Dave Chinner <david@fromorbit.com>
Subject: Re: Warning and BUG with btrfs and corrupted image
Date: Thu, 5 Feb 2009 19:59:16 +1100
Message-ID: <20090205085916.GP24173@disturbed>
References: <20090120063150.GC5854@alice> <20090120101119.GB10158@disturbed> <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed> <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz> <20090121040042.GI10158@disturbed> <20090126162711.GA2083@elf.ucw.cz> <20090201014050.GD24173@disturbed> <20090204182951.GC4797@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Christoph Hellwig <hch@infradead.org>,
	Eric Sesterhenn <snakebyte@gmx.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090204182951.GC4797@elf.ucw.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 04, 2009 at 07:29:51PM +0100, Pavel Machek wrote:
> On Sun 2009-02-01 12:40:50, Dave Chinner wrote:
> > On Mon, Jan 26, 2009 at 05:27:11PM +0100, Pavel Machek wrote:
> > > On Wed 2009-01-21 15:00:42, Dave Chinner wrote:
> > > +	  Turning this option on will result in kernel panicking any ti=
me
> > > +	  it detects on-disk corruption.
> >=20
> > Thin end of a wedge. There's a couple of thousand conditions that
> > CONFIG_XFS_DEBUG introduces kernel panics on:
> >=20
> > $ grep -r ASSERT fs/xfs |wc -l
> > 2095
> >=20
> >=20
> > CONFIG_*_DEBUG means include *debug* code there to help developers,
> > including adding additional failure tests into the kernel. Besides,
> > which bit of "don't turn it on unless you are an XFS developer"
> > don't you understand?
>=20
> Yes, but DEBUG code is normally to help debugging, not to crash
> kernels.

Crashing the kernel at exactly the point a problem is detected
is often the simplest way of debugging the problem.

e.g. CONFIG_VM_DEBUG=3Dy turns on VM_BUG_ON() which crashes the kernel
whenever it detects something wrong. Do I turn it on? Yes. Do i
complain about it when I hit a VM_BUG_ON()? No, I report the
bug and move on. If you turn on a DEBUG option, then you are
asking the system to behave in a way useful to a developer,
not an end user. That includes panicing when something wrong
is detected.

> IMO xfs should use errors=3Dpanic mount option as ext3 does,
> but...

We already have an equivalent:

/proc/sys/fs/xfs/panic_mask

The mask is empty on production kernels and can be selectively
turned on (depending on what error type you want to panic on).
CONFIG_XFS_DEBUG turns them all on by default so we can, we=C4=BCl, pan=
ic
the system and debug any problem that occurs....

Cheers,

Dave,
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
