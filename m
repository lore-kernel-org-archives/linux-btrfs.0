From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC] proposal for a btrfs filesystem layout
Date: Sat, 21 Nov 2009 00:31:06 +0100
Message-ID: <200911210031.06858.kreijack@libero.it>
References: <200911201950.06662.kreijack@libero.it> <20091120195408.GA3110@think>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091120195408.GA3110@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Friday 20 November 2009, Chris Mason wrote:
> On Fri, Nov 20, 2009 at 07:50:06PM +0100, Goffredo Baroncelli wrote:
> > Hi all,
> > 
> > after the Chirs (Ball) email, I thought about a possible btrfs file-system 
> > layout, which may permit to snapshot the root and mount (if required) an 
old 
> > snapshot of the root.
> 
> [ very clear description of a filesystem tree layout ]
> > 
> > 
> > Any comments ? 
> 
> This is definitely possible, but not strictly required.  We'll be able
> to create an ioctl (or mount option) that replaces the default subvolume
> ('.' in your examples) pointer with a pointer to another subvolume, and
> an ioctl to delete the old root.

That was my first thought... but so the risk is to implement with ioctl(s) 
commands (rename, delete, list  ) that 
a) already exist in the VFS abstraction.
b) refer to objects that are like "directories" (in fact the differences 
between a volume and a directory are very small)

> Basically it will end up hiding the extra layer of indirection your
> proposal adds.  

Yes, my idea introduces an extra layer, that
a) is different from all other file-systems 
b) is not useful if you don't use the snapshot at all
And both a) and b) are not good point :((

> This doesn't mean your ideas were bad, my plan all along
> has been to leave this up to the distros to work out with the users, and
> give them enough tools that they have the flexibility to do what they
> need.

My concern is about the btrfs user interface.
The biggest difficult that I had to learn the btrfs capabilities is its "user-
interface". I have to admit to be not the smartest person, but I spent a lot 
of time in order to understand which was the difference between a btrfs 
subvolume creation and a "mkfs + mount".
Finally I concluded that there no is difference (except the COW behaviour and 
other implementation detail). My impression was that in some area too often 
the VFS and btrfs do the same things. [*]
The point is that if btrfs do the same things of VFS, this may be called as 
"flexibility". 
But the history has highlight that from a long term point of view is the 
orthogonality of the subsystems that leads to the flexibility of the system..

I definitively need to sleep. Now in Italy is deep night and it is too late to 
email about "orthogonality of the subsystems".. 
In any case, thank you Chris for your work for btrfs. And read my comment only 
as suggestion to improve btrfs.

> -chris
Goffredo

[*] May be that my confusion is due to the fact that when btrfs creates a 
subvolume, two different actions were performed
- a new subvolume is create (and definitely this is a btrfs competence)
- the new subvolume is mounted in a new directory (and I think that this is a 
VFS competence). 

That raise me a question: what about to separate the subvolume creation from 
the subvolume mounting ? That definitely put the two kind of objects 
(directories and subvolume) in two different name-spaces: Btrfs will be 
responsible to create subvolume (and handle the COW/snapshot semantic), and 
the mounting will be responsible to the VFS.



-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
