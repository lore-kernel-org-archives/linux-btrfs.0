From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached to
 a filesystem
Date: Thu, 30 Sep 2010 21:59:09 +0200
Message-ID: <AANLkTin9=gRRWrJ66-UVkPCYHeyPQCmq9u2YoWEr1U3B@mail.gmail.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
 <20100928232513.GA20629@infradead.org> <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
 <20100929001954.GA9182@tango.0pointer.de> <4CA2E9CD.5090700@redhat.com>
 <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com>
 <20100929234327.GA8401@infradead.org> <20100930194818.GJ32420@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Lennart Poettering <lennart@poettering.net>,
	linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100930194818.GJ32420@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 30, 2010 at 21:48, Josef Bacik <josef@redhat.com> wrote:
> On Wed, Sep 29, 2010 at 07:43:27PM -0400, Christoph Hellwig wrote:
>> On Wed, Sep 29, 2010 at 10:04:31AM +0200, Kay Sievers wrote:
>> > On Wed, Sep 29, 2010 at 09:25, Ric Wheeler <rwheeler@redhat.com> w=
rote:
>> >
>> > > Second question is why is checking in /sys a big deal, would ??y=
ou prefer an
>> > > interface like we did for alignment in libblkid?
>> >
>> > It's about knowing what's behind the 'nodev' major =3D=3D 0 of a b=
trfs
>> > mount. There is no way to get that from /sys or anywhere else at t=
he
>> > moment.
>> >
>> > Usually filesystems backed by a disk have the dev_t of the device,=
 or
>> > the fake block devices like md/dm/raid have their own major and th=
e
>> > slaves/ directory pointing to the devices.
>> >
>> > This is not only about readahead, it's every other tool, that need=
s to
>> > know what kind of disks are behind a btrfs 'nodev' major =3D=3D 0 =
mount.
>>
>> Thanks for explaining the problem. =C2=A0It's one that affects every=
thing
>> with more than one underlying block device, so adding a
>> filesystem-specific ioctl hack is not a good idea. =C2=A0As mentione=
d in this
>> mail we already have a solution for that - the block device slaves
>> links used for raid and volume managers. =C2=A0The most logical fix =
is to
>> re-use that for btrfs as well and stop it from abusing the anonymous
>> block major that was never intended for block based filesystems (and
>> already has caused trouble in other areas). =C2=A0One way to to this=
 might
>> be to allocate a block major for btrfs that only gets used for
>> representing these links.
>>
>
> Ok I've spent a few hours on this and I'm hitting a wall. =C2=A0In or=
der to get the
> sort of /sys/block/btrfs-# sort of thing I have to do
>
> 1) register_blkdev to get a major
> 2) setup a gendisk
> 3) do a bdget_disk
> 4) Loop through all of our devices and do a bd_claim_by_disk on each =
of them
>
> This sucks because for step #2 I have to have a request_queue for the=
 disk.
> It's a bogus disk, and theres no way to not have a request_queue, so =
I'd have to
> wire that up and put a bunch of WARN_ON()'s to make sure nobody is tr=
ying to
> write to our special disk (since I assume that if I go through all th=
is crap I'm
> going to end up with a /dev/btrfs-# that people are going to try to w=
rite to).
>
> So my question is, is this what we want? =C2=A0Do I just need to quit=
 bitching and
> make it work? =C2=A0Or am I doing something wrong? =C2=A0This is a co=
mpletely new area for
> me so I'm just looking around at what md/dm does and trying to mirror=
 it for my
> own uses, if thats not what I should be doing please tell me, otherwi=
se this
> seems like alot of work for a very shitty solution to our problem. =C2=
=A0Thanks,

Yeah, that matches what I was experiencing when thinking about the
options. Making a btrfs mount a fake blockdev of zero size seems like
a pretty weird hack, just get some 'dead' directories in sysfs. A
btrfs mount is just not a raw blockdev, and should probably not
pretend to be one.

I guess a statfs()-like call from the filesystem side and not the
block side, which can put out such information in some generic way,
would better fit here.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
