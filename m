From: "Jean-Philippe Robichaud" <jean.philippe.robichaud@gmail.com>
Subject: Re: unexpected raid1 behavior?
Date: Fri, 27 Nov 2009 17:36:22 -0500
Message-ID: <200911271736.22930.jean.philippe.robichaud@gmail.com>
References: <200911271541.17451.jean.philippe.robichaud@gmail.com> <20091127210442.GA18273@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091127210442.GA18273@vlad.carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 27 November 2009 16:04:42 Hugo Mills wrote:
> yOn Fri, Nov 27, 2009 at 03:41:17PM -0500, Jean-Philippe Robichaud wrote:
> > Now I have 2 partitions (on 2 different sata disks) that are free for me
> > to play with, each about 375 gb in size.  I wanted to create a "raid1"
> > volume using these two partitions, so I did:
> >
> > # mkfs.btrfs -d raid1 /dev/sda5 /dev/sdb5
> > # mount /dev/sda5 /btrfs
> >
> > and everything seems fine.
> >
> > Now what I find strange is that everything looks like a raid0 was
> > created, not a raid1:
> >
> > $ df -h /btrfs/
> >  Filesystem            Size  Used Avail Use% Mounted on
> > /dev/sda5             684G   72G  612G  11% /btrfs
> >
> > What am I doing (or understanding) wrong?
> 
>    It's effectively showing you the number of unallocated blocks, so
> (with a RAID-1, single-redundancy filesystem), files will appear to
> take twice as much of your free space as you think they should: write
> a 2GiB file to that filesystem, and free space will drop by 4GiB.
> 
>    I think that the reasoning behind this is that if you're using
> per-object mirroring/striping, it's impossible to give a precise count
> of the free space remaining on the volume in any meaningful way: write
> a 1GiB striped file, and you'll take 1GiB of space; write the same
> file mirrored, and you'll take 2GiB of space.
> 
>    Hugo.
> 
Thanks for your input Hugo, but somehow it looks like something different is 
happening:

du toto
1088 toto
$ df .
/dev/sda5            716579256  75455900 641123356  11% /btrfs
$ cp toto toto2 
$ btrfsctl -c .
$ df .
/dev/sda5            716579256  75456992 641122264  11% /btrfs

So 1092 block were 'consumed', we're far from the +2000 I would have 
expected...

Is there a place in /sys or /proc where I could perhaps get 'stats' about the 
btrfs volume?

