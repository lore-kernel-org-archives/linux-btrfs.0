From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Snapshot mysteries (and an oops)
Date: Sat, 12 Dec 2009 20:17:10 +0100
Message-ID: <200912122017.10255.kreijack@alice.it>
References: <cb0375e10912111116w284bfc33p3bc2bad00b20a9b1@mail.gmail.com> <200912112040.18415.kreijack@alice.it> <4B23E2E1.4020103@mit.edu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Andy Lutomirski <luto@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B23E2E1.4020103@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 12 December 2009, Andy Lutomirski wrote:
> Goffredo Baroncelli wrote:
[...]
> > 
> > Yes the docs may be improved. The syntax is:
> > 
> > btrfsctl -D <snapshotname> <directory>
> > 	<snapshotname>		snapshot name
> > 	<directory>		where the snapshot is
> > 
> 
> What's the point of the last parameter?  Can't either btrfsctl or the 
> filesystem figure that out on its own?

Pay attention that you can have different sub-volumes with the same name in 
different directories. 
It would be better if the directory is extracted from the name..

> (Can a subvolume be "mounted" in two places at once?  If so, maybe the 
> second parameter makes a tiny bit of sense.)

Yes, a subvolume may be mounted in two places (mount -t btrfs -o 
subvol=<subvolumename> ...); but that doesn't matter: if you remove a 
subvolume.. you remove iteverywhere.

> 
> --Andy
 

Goffredo
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
