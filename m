From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
 to a filesystem
Date: Wed, 29 Sep 2010 19:43:27 -0400
Message-ID: <20100929234327.GA8401@infradead.org>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
 <20100928232513.GA20629@infradead.org>
 <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
 <20100929001954.GA9182@tango.0pointer.de>
 <4CA2E9CD.5090700@redhat.com>
 <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Lennart Poettering <lennart@poettering.net>,
	Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-btrfs@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 10:04:31AM +0200, Kay Sievers wrote:
> On Wed, Sep 29, 2010 at 09:25, Ric Wheeler <rwheeler@redhat.com> wrote:
> 
> > Second question is why is checking in /sys a big deal, would ??you prefer an
> > interface like we did for alignment in libblkid?
> 
> It's about knowing what's behind the 'nodev' major == 0 of a btrfs
> mount. There is no way to get that from /sys or anywhere else at the
> moment.
> 
> Usually filesystems backed by a disk have the dev_t of the device, or
> the fake block devices like md/dm/raid have their own major and the
> slaves/ directory pointing to the devices.
> 
> This is not only about readahead, it's every other tool, that needs to
> know what kind of disks are behind a btrfs 'nodev' major == 0 mount.

Thanks for explaining the problem.  It's one that affects everything
with more than one underlying block device, so adding a
filesystem-specific ioctl hack is not a good idea.  As mentioned in this
mail we already have a solution for that - the block device slaves
links used for raid and volume managers.  The most logical fix is to
re-use that for btrfs as well and stop it from abusing the anonymous
block major that was never intended for block based filesystems (and
already has caused trouble in other areas).  One way to to this might
be to allocate a block major for btrfs that only gets used for
representing these links.

