From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached to
 a filesystem
Date: Thu, 30 Sep 2010 09:43:00 +0200
Message-ID: <AANLkTi=tzfR2RQzXP6MbzzZmxdpqPO=WQPFs4QSGseHi@mail.gmail.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
 <20100928232513.GA20629@infradead.org> <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
 <20100929001954.GA9182@tango.0pointer.de> <4CA2E9CD.5090700@redhat.com>
 <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com> <20100929234327.GA8401@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Lennart Poettering <lennart@poettering.net>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929234327.GA8401@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 30, 2010 at 01:43, Christoph Hellwig <hch@infradead.org> wr=
ote:
> On Wed, Sep 29, 2010 at 10:04:31AM +0200, Kay Sievers wrote:
>> On Wed, Sep 29, 2010 at 09:25, Ric Wheeler <rwheeler@redhat.com> wro=
te:
>>
>> > Second question is why is checking in /sys a big deal, would ??you=
 prefer an
>> > interface like we did for alignment in libblkid?
>>
>> It's about knowing what's behind the 'nodev' major =3D=3D 0 of a btr=
fs
>> mount. There is no way to get that from /sys or anywhere else at the
>> moment.
>>
>> Usually filesystems backed by a disk have the dev_t of the device, o=
r
>> the fake block devices like md/dm/raid have their own major and the
>> slaves/ directory pointing to the devices.
>>
>> This is not only about readahead, it's every other tool, that needs =
to
>> know what kind of disks are behind a btrfs 'nodev' major =3D=3D 0 mo=
unt.
>
> Thanks for explaining the problem. =C2=A0It's one that affects everyt=
hing
> with more than one underlying block device, so adding a
> filesystem-specific ioctl hack is not a good idea. =C2=A0As mentioned=
 in this
> mail we already have a solution for that - the block device slaves
> links used for raid and volume managers. =C2=A0The most logical fix i=
s to
> re-use that for btrfs as well and stop it from abusing the anonymous
> block major that was never intended for block based filesystems (and
> already has caused trouble in other areas). =C2=A0One way to to this =
might
> be to allocate a block major for btrfs that only gets used for
> representing these links.

Yeah, we thought about that too, but a btrfs mount does not show up as
a block device, like md/dm, so there is no place for a slaves/
directory in /sys with the individual disks listed. How could be solve
that? Create some fake blockdev for every btrfs mount,  but that can't
be used to read/write raw blocks?

A generic solution, statfs()-like, which operates at the superblock
would be another option. Any idea if that could be made working?

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
