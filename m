From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Fri, 19 Dec 2008 14:30:15 -0500
Message-ID: <1229715015.6695.71.camel@think.oraclecorp.com>
References: <OF3415C20F.793A0D3C-ON88257524.0067548F-88257524.0068BCEC@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Brad Voth <brad@voth.name>, adilger@sun.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>,
	Kay Sievers <kay.sievers@vrfy.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
To: Bryan Henderson <hbryan@us.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <OF3415C20F.793A0D3C-ON88257524.0067548F-88257524.0068BCEC@us.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-12-19 at 11:03 -0800, Bryan Henderson wrote:
> "Brad Voth" <brad@voth.name> wrote on 12/18/2008 01:36:12 PM:
> 
> > I can see the desire to have the snapshot at the filesystem level to
> > ensure that the filesystem knows it is consistent.  However, this 
> > can be a duplication of effort because of the need to have snapshots
> > at the block device level for non-fs devices.  Such as raw logical 
> > devices for say a database.  I would think that a viable consistent 
> > solution would be to have the block device snapshot mechanism have a
> > hook into the filesystem api to say, "I'm preparing to take a 
> > snapshot, please quiesce and return" <take block snapshot> "You may 
> > now resume, Mr. Filesystem"

This is what lvm does now with the write_super_lockfs calls.  They work
well for a specific purpose.

At the end of the day snapshots mean different things to different
people and different workloads.  In lots of ways the lvm snapshots work
very well.

But, doing snapshots at the FS level gives you better performance and
more control.

-chris


