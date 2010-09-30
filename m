From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
 to  a filesystem
Date: Thu, 30 Sep 2010 22:37:32 +0200
Message-ID: <20100930203732.GA27473@tango.0pointer.de>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
 <20100928232513.GA20629@infradead.org>
 <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
 <20100929001954.GA9182@tango.0pointer.de>
 <4CA2E9CD.5090700@redhat.com>
 <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com>
 <20100929234327.GA8401@infradead.org>
 <20100930194818.GJ32420@dhcp231-156.rdu.redhat.com>
 <AANLkTin9=gRRWrJ66-UVkPCYHeyPQCmq9u2YoWEr1U3B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin9=gRRWrJ66-UVkPCYHeyPQCmq9u2YoWEr1U3B@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 30.09.10 21:59, Kay Sievers (kay.sievers@vrfy.org) wrote:

> > So my question is, is this what we want? =A0Do I just need to quit =
bitching and
> > make it work? =A0Or am I doing something wrong? =A0This is a comple=
tely new area for
> > me so I'm just looking around at what md/dm does and trying to mirr=
or it for my
> > own uses, if thats not what I should be doing please tell me, other=
wise this
> > seems like alot of work for a very shitty solution to our problem. =
=A0Thanks,
>=20
> Yeah, that matches what I was experiencing when thinking about the
> options. Making a btrfs mount a fake blockdev of zero size seems like
> a pretty weird hack, just get some 'dead' directories in sysfs. A
> btrfs mount is just not a raw blockdev, and should probably not
> pretend to be one.
>=20
> I guess a statfs()-like call from the filesystem side and not the
> block side, which can put out such information in some generic way,
> would better fit here.

Note that for my particular usecase it would even suffice to have two
flags in struct statfs or struct statvfs that encode whether there's a =
at
least one SSD in the fs, resp. at least one rotating disk in the fs.

if (statvfs.f_flag & ST_SSD)=20
        printf("FS contains at least one SSD disk");
if (statvfs.f_flag & ST_ROTATING)=20
        printf("FS contains at least one rotating disk");

Lennart

--=20
Lennart Poettering - Red Hat, Inc.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
