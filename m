From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
	to a filesystem
Date: Thu, 30 Sep 2010 08:38:46 -0400
Message-ID: <20100930123846.GI32420@dhcp231-156.rdu.redhat.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com> <20100928232513.GA20629@infradead.org> <20100929000809.GC32420@dhcp231-156.rdu.redhat.com> <20100929001954.GA9182@tango.0pointer.de> <4CA2E9CD.5090700@redhat.com> <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com> <20100929234327.GA8401@infradead.org> <AANLkTi=tzfR2RQzXP6MbzzZmxdpqPO=WQPFs4QSGseHi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Lennart Poettering <lennart@poettering.net>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=tzfR2RQzXP6MbzzZmxdpqPO=WQPFs4QSGseHi@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 30, 2010 at 09:43:00AM +0200, Kay Sievers wrote:
> On Thu, Sep 30, 2010 at 01:43, Christoph Hellwig <hch@infradead.org> =
wrote:
> > On Wed, Sep 29, 2010 at 10:04:31AM +0200, Kay Sievers wrote:
> >> On Wed, Sep 29, 2010 at 09:25, Ric Wheeler <rwheeler@redhat.com> w=
rote:
> >>
> >> > Second question is why is checking in /sys a big deal, would ??y=
ou prefer an
> >> > interface like we did for alignment in libblkid?
> >>
> >> It's about knowing what's behind the 'nodev' major =3D=3D 0 of a b=
trfs
> >> mount. There is no way to get that from /sys or anywhere else at t=
he
> >> moment.
> >>
> >> Usually filesystems backed by a disk have the dev_t of the device,=
 or
> >> the fake block devices like md/dm/raid have their own major and th=
e
> >> slaves/ directory pointing to the devices.
> >>
> >> This is not only about readahead, it's every other tool, that need=
s to
> >> know what kind of disks are behind a btrfs 'nodev' major =3D=3D 0 =
mount.
> >
> > Thanks for explaining the problem. =A0It's one that affects everyth=
ing
> > with more than one underlying block device, so adding a
> > filesystem-specific ioctl hack is not a good idea. =A0As mentioned =
in this
> > mail we already have a solution for that - the block device slaves
> > links used for raid and volume managers. =A0The most logical fix is=
 to
> > re-use that for btrfs as well and stop it from abusing the anonymou=
s
> > block major that was never intended for block based filesystems (an=
d
> > already has caused trouble in other areas). =A0One way to to this m=
ight
> > be to allocate a block major for btrfs that only gets used for
> > representing these links.
>=20
> Yeah, we thought about that too, but a btrfs mount does not show up a=
s
> a block device, like md/dm, so there is no place for a slaves/
> directory in /sys with the individual disks listed. How could be solv=
e
> that? Create some fake blockdev for every btrfs mount,  but that can'=
t
> be used to read/write raw blocks?
>=20

That's what I was going to do.  We essentially do that anyway with the =
anonymous
superblock, so instead I'll just make /dev/btrfs-# whatever and do the
bd_claim_by_disk stuff to make all of our devices slaves of that parent=
 virtual
device.  Does this seem like a resonable solution?  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
