From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Fri, 19 Dec 2008 11:03:56 -0800
Message-ID: <OF3415C20F.793A0D3C-ON88257524.0067548F-88257524.0068BCEC@us.ibm.com>
References: <e1f6055f0812181336q105b4ebcy81d72edd2a35baa8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: adilger@sun.com, "Andrew Morton" <akpm@linux-foundation.org>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Jeff Garzik" <jeff@garzik.org>,
	"Kay Sievers" <kay.sievers@vrfy.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	sfr@canb.auug.org.au
To: "Brad Voth" <brad@voth.name>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <e1f6055f0812181336q105b4ebcy81d72edd2a35baa8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

"Brad Voth" <brad@voth.name> wrote on 12/18/2008 01:36:12 PM:

> I can see the desire to have the snapshot at the filesystem level to
> ensure that the filesystem knows it is consistent.  However, this 
> can be a duplication of effort because of the need to have snapshots
> at the block device level for non-fs devices.  Such as raw logical 
> devices for say a database.  I would think that a viable consistent 
> solution would be to have the block device snapshot mechanism have a
> hook into the filesystem api to say, "I'm preparing to take a 
> snapshot, please quiesce and return" <take block snapshot> "You may 
> now resume, Mr. Filesystem"

But that's a layering violation.  First of all, a block device doesn't 
know what a filesystem is, so you'd have to generalize it to making these 
requests to whatever has the block device in some sense open.  I don't see 
that this sequence gains you anything over the sequence I described where 
the user makes the request of the filesystem driver and the filesystem 
driver, while it has the filesystem quiesced, issues an order to the block 
device to make a snapshot.

>In this way there is a single interface for users to take snapshots
>of the block device level whether it is a raw logical volume, or a
>filesystem sitting on a logical volume.

I don't think it makes sense to have a common means of snapshotting any of 
the various things that might reside on a block device; for some, I can't 
even think of a meaningful concept of snapshotting the information on that 
device.  E.g. where it's one of 4 disks on which some filesystem resides.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Storage Systems

