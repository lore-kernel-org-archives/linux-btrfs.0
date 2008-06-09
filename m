From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfs device management
Date: Mon, 09 Jun 2008 12:22:29 -0400
Message-ID: <1213028549.10187.51.camel@think.oraclecorp.com>
References: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com>
	 <1213019571.10187.12.camel@think.oraclecorp.com>
	 <f058a9c30806090837k3a6d18afm942acd9c257c677@mail.gmail.com>
	 <200806091819.18985.mail@earthworm.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: btrfs-devel@oss.oracle.com,
	Miguel Sousa Filipe <miguel.filipe@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	btrfs-devel@arbitraryconstant.com, linux-btrfs@vger.kernel.org
To: Christian Hesse <mail@earthworm.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200806091819.18985.mail@earthworm.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-06-09 at 18:19 +0200, Christian Hesse wrote:
> On Monday 09 June 2008, Miguel Sousa Filipe wrote:
> > On Mon, Jun 9, 2008 at 2:52 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > > mkfs.btrfs already has a way to set the label of the filesystem.
> > > mkfs.btrfs -L label /dev/xxxx
> > >
> > > btrfs-show will show you the labels of any existing filesystems.
> >
> > Can I mount by label ?
> > something like:
> > # mount /dev/btrfs/label /mountpoint
> 
> Yes, by mounting /dev/disk/by-label/label. That should work with every block 
> device.

Once btrfs support is in libblkid (or whatever udev uses) that is.
Today btrfs won't show up in /dev/disk/by-label/label or mount -L

-chris


