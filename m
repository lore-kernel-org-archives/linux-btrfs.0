From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Free space left
Date: Sat, 16 Jan 2010 20:34:12 +0100
Message-ID: <201001162034.12778.kreijack@inwind.it>
References: <20100116164120.47eceecd@simplux> <201001162010.37752.kreijack@libero.it> <4B521420.8030306@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Svein Erik Brostigen <svein.brostigen@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B521420.8030306@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 16 January 2010, you (Svein Erik Brostigen) wrote:
> Goffredo Baroncelli wrote:
> > Try btrfs-show
> >   
> Ok:



> $ mount
> /dev/sdc on /media/452f782b-738a-4699-abfa-588eecab07ea type btrfs 
> (rw,nosuid,nodev,uhelper=devkit)
> 
> $ df
> /dev/sdc              932G  6.7G  925G   1% 
> /media/452f782b-738a-4699-abfa-588eecab07ea
> 
> $ btrfs-show
> failed to read /dev/sdb1
> failed to read /dev/sdc
^^^^^^^^^

It seems that you don't have the right to read /dev/sdc.

Retry as super user.
[...]
> Btrfs Btrfs v0.19
> 
> The drive used is a Seagate FreeAgent 1Tb USB drive under Ubuntu 9.10
> 
> $ uname -a
> Linux ebrostig-laptop 2.6.31-18-generic-pae #55-Ubuntu SMP Fri Jan 8 
> 16:13:23 UTC 2010 i686 GNU/Linux
> 
> Erik
> 
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
