From: Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: speeding up slow btrfs filesystem
Date: Sat, 17 Dec 2011 12:39:04 +0100
Message-ID: <11417281.pDov3IyVP3@venice>
References: <201112161851.52011.Martin@lichtvoll.de> <4906354.Rn8tlOeHyD@venice> <201112162053.58332.Martin@lichtvoll.de>
Reply-To: Goffredo Baroncelli <kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112162053.58332.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 16 December, 2011 20:53:58 Martin Steigerwald wrote:
> > I found a solution, but requires a bit of setup.
> >
> > 
> >
> > The idea is to avoid do perform sync during the package installation.
> > In order to avoid data loss in case of failure, I create a snapshot
> > before the upgrading. If something goes wrong (i.e. a power failure) I
> > rebooot the system from the snapshot. If the installation finish
> > without problem, I flush all the data to the disk and remove the
> > snapshot.
> >
> > 
> >
> > For the detail, see a my old post titled "[RFC] aptitude & BTRFS slow"
> > (2011-10-19)
> 
> Sounds more like a workaround to me than a solution.

Sorry but I strongly disagree.

Aptitude was designed for an ordinary filesystem. Where the only way to have a 
filesystem consistency is to issue a lot of sync for every package. But this 
doesn't prevent to have an half package installed:(think about to an 
"openoffice" upgrade: in case of power failure, you could not have nor the old 
openoffice, nor the new one.
Instead with the snapshot you can always have the old system or the new 
system. No half packages

With BTRFS, I can say that the workaround[*] is using the sync and not the 
snapshot

The true is that BTRFS is different from ext4 (or ext3, xfs....). You can use 
BTRFS like ext4 and you will find a lot of regression like this. 

BTRFS is very different from an ordinary filesystem, and you have to change some 
behaviour to take advantages with is peculiarities.

Using the snapshot during an upgrade open a lot of possibility which are not 
allowed with EXT4. With snapshot you can always go back if during an upgrade 
if something goes wrong (like strange packages dependencies). Or you can have 
the previous configuration to go back in case of trouble.



[*] Of course this is due to the fact that the most part of the filesystem is 
like ext4. Supporting BTRFS could be not the highest priority.


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
