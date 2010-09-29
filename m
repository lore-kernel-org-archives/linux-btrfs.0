From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached to
 a filesystem
Date: Wed, 29 Sep 2010 10:04:31 +0200
Message-ID: <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
 <20100928232513.GA20629@infradead.org> <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
 <20100929001954.GA9182@tango.0pointer.de> <4CA2E9CD.5090700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Lennart Poettering <lennart@poettering.net>,
	Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CA2E9CD.5090700@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 09:25, Ric Wheeler <rwheeler@redhat.com> wrote:

> Second question is why is checking in /sys a big deal, would =C2=A0yo=
u prefer an
> interface like we did for alignment in libblkid?

It's about knowing what's behind the 'nodev' major =3D=3D 0 of a btrfs
mount. There is no way to get that from /sys or anywhere else at the
moment.

Usually filesystems backed by a disk have the dev_t of the device, or
the fake block devices like md/dm/raid have their own major and the
slaves/ directory pointing to the devices.

This is not only about readahead, it's every other tool, that needs to
know what kind of disks are behind a btrfs 'nodev' major =3D=3D 0 mount=
=2E

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
