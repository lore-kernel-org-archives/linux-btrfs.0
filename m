From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: make snapshot main volume, delete all others?
Date: Tue, 3 Aug 2010 20:46:34 +0200
Message-ID: <201008032046.34521.kreijack@libero.it>
References: <4C585E6E.3060704@kofler.info>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Michael Kofler <michael@kofler.info>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C585E6E.3060704@kofler.info>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Michael

This theme was discussed several times in the past.

Short answer: now it is not possible, what you are asking.

Long answer: rearranging the layout of the filesystem, it is easy to do what 
are you asking with the current tools. But this changes have to be integrated 
in the distribution, and I don't know any distribution that did so. This is my 
preferred solution (and the only available today)
Another solution require the additional of other API to permit to move the 
root of a btrfs filesystem (with all the subvolumes) from a subvolume/snapshot 
to another one.

For additional info see these posts:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03484.html
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg05334.html
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04968.html

Regard
G.Baroncelli

On Tuesday, 03 August, 2010, Michael Kofler wrote:
> Fedora provides yum-fs-snapshot. If installed, on each package 
> installation or update a snapshot of all btrfs filesystems is taken, so 
> it is possible to revert the installation/update.
> 
> Suppose an update failed and I want to get back: with
> 
> # btrfs subvolume set-default yum-snapshot-whatever /
> 
> I define which snapshot to use at the next boot.
> 
> After rebooting I decide I really want to stay with this snapshot. I can 
> delete all other snapshots, but can I also delete my previous main 
> volume, thus defining the current default snapshot as my new base. (If 
> not, a growing part of the filesystem is wasted for old data I don't 
> need anymore.)
> 
> Any insight is appreciated!
> 
> 	Michael Kofler
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
