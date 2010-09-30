From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
	to a filesystem
Date: Thu, 30 Sep 2010 15:48:19 -0400
Message-ID: <20100930194818.GJ32420@dhcp231-156.rdu.redhat.com>
References: <1285707196-16268-1-git-send-email-josef@redhat.com> <20100928232513.GA20629@infradead.org> <20100929000809.GC32420@dhcp231-156.rdu.redhat.com> <20100929001954.GA9182@tango.0pointer.de> <4CA2E9CD.5090700@redhat.com> <AANLkTimHmbVbScgDHsb8f=ts0QKr-+pwNm=YY4sG+bz1@mail.gmail.com> <20100929234327.GA8401@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	Ric Wheeler <rwheeler@redhat.com>,
	Lennart Poettering <lennart@poettering.net>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929234327.GA8401@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 07:43:27PM -0400, Christoph Hellwig wrote:
> On Wed, Sep 29, 2010 at 10:04:31AM +0200, Kay Sievers wrote:
> > On Wed, Sep 29, 2010 at 09:25, Ric Wheeler <rwheeler@redhat.com> wrote:
> > 
> > > Second question is why is checking in /sys a big deal, would ??you prefer an
> > > interface like we did for alignment in libblkid?
> > 
> > It's about knowing what's behind the 'nodev' major == 0 of a btrfs
> > mount. There is no way to get that from /sys or anywhere else at the
> > moment.
> > 
> > Usually filesystems backed by a disk have the dev_t of the device, or
> > the fake block devices like md/dm/raid have their own major and the
> > slaves/ directory pointing to the devices.
> > 
> > This is not only about readahead, it's every other tool, that needs to
> > know what kind of disks are behind a btrfs 'nodev' major == 0 mount.
> 
> Thanks for explaining the problem.  It's one that affects everything
> with more than one underlying block device, so adding a
> filesystem-specific ioctl hack is not a good idea.  As mentioned in this
> mail we already have a solution for that - the block device slaves
> links used for raid and volume managers.  The most logical fix is to
> re-use that for btrfs as well and stop it from abusing the anonymous
> block major that was never intended for block based filesystems (and
> already has caused trouble in other areas).  One way to to this might
> be to allocate a block major for btrfs that only gets used for
> representing these links.
> 

Ok I've spent a few hours on this and I'm hitting a wall.  In order to get the
sort of /sys/block/btrfs-# sort of thing I have to do

1) register_blkdev to get a major
2) setup a gendisk
3) do a bdget_disk
4) Loop through all of our devices and do a bd_claim_by_disk on each of them

This sucks because for step #2 I have to have a request_queue for the disk.
It's a bogus disk, and theres no way to not have a request_queue, so I'd have to
wire that up and put a bunch of WARN_ON()'s to make sure nobody is trying to
write to our special disk (since I assume that if I go through all this crap I'm
going to end up with a /dev/btrfs-# that people are going to try to write to).

So my question is, is this what we want?  Do I just need to quit bitching and
make it work?  Or am I doing something wrong?  This is a completely new area for
me so I'm just looking around at what md/dm does and trying to mirror it for my
own uses, if thats not what I should be doing please tell me, otherwise this
seems like alot of work for a very shitty solution to our problem.  Thanks,

Josef
