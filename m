From: Christian Hesse <mail@earthworm.de>
Subject: Re: btrfs device management
Date: Mon, 9 Jun 2008 18:19:16 +0200
Message-ID: <200806091819.18985.mail@earthworm.de>
References: <62325.68.145.107.21.1212882817.squirrel@avalon.arbitraryconstant.com> <1213019571.10187.12.camel@think.oraclecorp.com> <f058a9c30806090837k3a6d18afm942acd9c257c677@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	btrfs-devel@arbitraryconstant.com, linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30806090837k3a6d18afm942acd9c257c677@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 09 June 2008, Miguel Sousa Filipe wrote:
> On Mon, Jun 9, 2008 at 2:52 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > mkfs.btrfs already has a way to set the label of the filesystem.
> > mkfs.btrfs -L label /dev/xxxx
> >
> > btrfs-show will show you the labels of any existing filesystems.
>
> Can I mount by label ?
> something like:
> # mount /dev/btrfs/label /mountpoint

Yes, by mounting /dev/disk/by-label/label. That should work with every block 
device.
-- 
Regards,
Chris
