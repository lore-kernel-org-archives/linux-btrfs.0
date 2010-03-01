From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Quota Clarification
Date: Mon, 1 Mar 2010 20:22:40 +0100
Message-ID: <201003012022.41417.kreijack@libero.it>
References: <c5b98f841002261951k78ad0f1cnec5450218a9ed0d8@mail.gmail.com> <c5b98f841003010823k714af7bam94cabed9ed3c69cc@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c5b98f841003010823k714af7bam94cabed9ed3c69cc@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 01 March 2010, Robert LeBlanc wrote:
> On Fri, Feb 26, 2010 at 8:51 PM, Robert LeBlanc <robert@leblancnet.us> 
wrote:
> > First off, thanks for the great work on btrfs. I've been trying to
> > follow the development for some time and now that Debian has
> > everything in Squeeze, I've been playing around with btrfs.
> >
> > I would like to implement btrfs on a large file server that we are
> > currently using ACLs, user and group quotas and LVM snapshots. 

Pay attention that btrfs is under develop.

> > While
[...]
> > I went to look at the quotas and repquota said that the mount point
> > doesn't have quotas enabled. I then searched for documentation about
> > quotas and it was pretty sparse. 
AFICT quota is not available in btrfs.

[...]
> I fail to see the benefit of having a btrfs root fs that is less than
> the disk or partition as the space can't be used for anything else. I
> hope I'm just doing something wrong here.

A possible application is shrinking a filesystem, in case of change of hard 
disk.

> 
> Thanks,
> 
> Robert LeBlanc
> Life Sciences & Undergraduate Education Computer Support
> Brigham Young University
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
