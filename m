From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: removing a snapshot that is outside the subvolume directory fails, sorta
Date: Thu, 21 Jan 2010 19:43:44 +0100
Message-ID: <201001211943.44940.kreijack@libero.it>
References: <593044.1345.qm@web51908.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <593044.1345.qm@web51908.mail.re2.yahoo.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 21 January 2010, Brian Neu wrote:
> Well, it fails the way that I'm trying to do it.
> kernel:            2.6.31.9-174.fc12.x86_64
> btrfs-progs:     btrfs-progs-0.19-9.fc12.x86_64
> 
> On a new filesystem:
> 
> $ cd /mnt/btrfs1
> $ btrfsctl -S subvol1 .
> operation complete
> Btrfs Btrfs v0.19
> $ btrfsctl -s snapofsubvol1 subvol1
> operation complete
> Btrfs Btrfs v0.19
> $ btrfsctl -D snapofsubvol1 subvol1
> ioctl:: No such file or directory
> 

Correct; the syntax should be:

$ btrfsctl -D snapofsubvol1  .

the last parameters is directory where the snapshot is.

> 
> $ btrfsctl -S subvol2 .
> operation complete
> Btrfs Btrfs v0.19
> --------> # cd subvol2    <------------
> $ btrfsctl -s snapofsubvol2 subvol2
> operation complete
> Btrfs Btrfs v0.19

To me this last step doesn't work. It works only if the "cd subvol2" command 
is not executed.

> $ btrfsctl -D snapofsubvol2 subvol2
> operation complete
> Btrfs Btrfs v0.19
> 
> 
> AHA, I figured it out!
> 
> $ btrfsctl -D snapofsubvol1 subvol1/..
> 
> I don't know if that's the intended syntax or if it's accidental, but I'll 
go ahead and send this as an FYI if anyone has the same issue.  Maybe it's 
obvious to some, but it wasn't to me.


Yes it is obvious :-) Because "subvol1/.." is like "." .

BR
G.Baroncelli


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
