From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Atomic replacement of subvolumes is not possible
Date: Fri, 2 Jul 2010 21:38:47 +0200
Message-ID: <201007022138.47323.kreijack@libero.it>
References: <4C263826.1060702@debian.org> <AANLkTilcAfaH4KmSzKGp8M-xj511IlowGgIZnhHopdNx@mail.gmail.com> <20100702013054.GC15319@think>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Chris Mason <chris.mason@oracle.com>,
	C Anthony Risinger <anthony@extof.me>, daniel@debian.org,
	linux-btrfs@vger.kernel.org, Roger Leigh <rleigh@debian.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100702013054.GC15319@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, July 02, 2010, Chris Mason wrote:
> On Wed, Jun 30, 2010 at 09:26:11AM -0500, C Anthony Risinger wrote:
[...]
> > what about this:  would it be possible to have TWO subvolumes by
> > "default"?  the regular one (current directory, "."):
> > 
> > mount -o subvol=. <btrfs_dev> /mnt
> > 
> > would behave as it does now.  BUT... there would then be a special,
> > permanent (like "." is right now) subvol, say "parent directory"
> > (".."):
> > 
> > mount -o subvol=.. <btrfs_dev> /mnt
> > 
> > TWO dots would mount the parent of ".", where i could then swap out
> > the real default (".").
> > 
> > would that work?
> 
> We do provide a set-default ioctl that can be used to change the default
> for the next mount.   This is pretty close to what you want, let me
> think about ways to make it easier to use.
> 
> -chris

Hello Chris,

to me it seems that the Anthony request make sense. And it not so difficult to 
have. We have all the pieces, we need only a "policy" regarding the subvolume 
use and a bit of glue
It should be sufficent to "replace" the standard mkfs.btrfs command with the 
following commands sequence

# mkfs.btrfs <device>
# mount <device> /mnt/<tmp>
# btrfs subvol create /mnt/<tmp>/__root__
# btrfs subvol set-default __root__ /mnt/<tmp>/
# umount <device>

So if an user don't want to care about a subvolume, he simply mount a btrfs 
filesystem without any option. This user will work inside the __root__ 
subvolume, where he can create snapshot, subvolume...

Instead if an user want to play with different root in different subvolumes, 
he have to mount the ".", where he can manage the root-subvolume(s) (renaming, 
moving, snapshotting/branching ... ).

The key is to think the "." subvolume only to handling the subvolumes and not 
to storing files. If you don't want to use it, you can simply ignore it, 
because the default is to mount the __root__ subvolume.


Goffredo

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
