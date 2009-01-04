From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: Btrfs for mainline
Date: Sun, 4 Jan 2009 22:52:44 +0100
Message-ID: <200901042252.45054.arnd@arndb.de>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20090103195034.GA27541@infradead.org> <1231013856.7538.89.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Christoph Hellwig <hch@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757408AbZADVxe@vger.kernel.org>
In-Reply-To: <1231013856.7538.89.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 03 January 2009, Chris Mason wrote:
>=20
> > Actually a lot of the ioctl API don't just need documentation but
> > a complete redo. =A0That's true at least for the physical device
> > management and subvolume / snaphot ones.
> >=20
>=20
> The ioctl interface is definitely not finalized. =A0Adding more vs
> replacing the existing ones is an open question.

As long as that's an open question, the ioctl interface shouldn't get
merged into the kernel, or should get in as btrfsdev, otherwise you
get stuck with the current ABI forever.

Is it possible to separate out the nonstandard ioctls into a patch
that can get merged when the interface is final, or will that make
btrfs unusable?

	Arnd <><
