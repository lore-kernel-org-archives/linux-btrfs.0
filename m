From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH] Btrfs: add a disk info ioctl to get the disks attached
  to a filesystem
Date: Wed, 29 Sep 2010 13:59:04 +0200
Message-ID: <20100929115903.GA13882@tango.0pointer.de>
References: <1285707196-16268-1-git-send-email-josef@redhat.com>
 <20100928232513.GA20629@infradead.org>
 <20100929000809.GC32420@dhcp231-156.rdu.redhat.com>
 <20100929001954.GA9182@tango.0pointer.de>
 <4CA2E9CD.5090700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-btrfs@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CA2E9CD.5090700@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 29.09.10 16:25, Ric Wheeler (rwheeler@redhat.com) wrote:

> >This in fact is how all current readahead implementations work, be it
> >the fedora, the suse or ubuntu's readahead or Arjan's sreadahead. What's
> >new is that in the systemd case we try to test for ssd/rotating
> >properly, instead of just hardcoding a check for
> >/sys/class/block/sda/queue/rotational.
> >
> 
> A couple of questions pop into mind - is systemd the right place to
> automatically tune readahead?  If this is a generic feature for the
> type of device, it sounds like something that we should be doing
> somewhere else in the stack (not relying on tuning from user space).

Note that this is not the kind of readahead that is controllable via 
/sys/class/block/sda/queue/read_ahead_kb, this is about detecting "hot"
files at boot, and then preloading them on the next boot. i.e. the
problem Jens once proposed fcache for.

> Second question is why is checking in /sys a big deal, would  you
> prefer an interface like we did for alignment in libblkid?

Well, currently there's no way to discover the underlying block devices
if you have a btrfs mount point. This is what Josef's patch added for
us.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
