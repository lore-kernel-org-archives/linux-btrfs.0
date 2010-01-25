From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: mount after reboot of btrfs RAID-10 fails with "btrfs: failed to read the system array on sda"
Date: Mon, 25 Jan 2010 19:19:39 +0100
Message-ID: <201001251919.40182.kreijack@libero.it>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com> <23a15591001241535h3768f413iee4bde3214a07bc5@mail.gmail.com> <c67eed301001242100x92e5fc2s6e130ed6ccf3b97d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org, Leszek Ciesielski <skolima@gmail.com>
To: 0bo0 <0.bugs.only.0@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001242100x92e5fc2s6e130ed6ccf3b97d@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 25 January 2010, 0bo0 wrote:
> On Sun, Jan 24, 2010 at 3:35 PM, Leszek Ciesielski <skolima@gmail.com> 
wrote:
> >> how would that, then, get handled for automount @ boot via fstab?  i
> >> guess that the scan needs to get done as well ...
> >> --
> >
> > Please see this discussion:
> > http://thread.gmane.org/gmane.comp.file-systems.btrfs/4126/focus=4187
> 
> Thanks for the reference.
> 
> @ that link,
> 
>   "Would this option ["mount -t btrfs -o device=/dev/sdb2 /dev/sda2
>   /mnt"] work on boot, bypasing the need for "btrfsctl -a" to mount a
>   multi-device filesystem?"
> 
> 
> would translate how, in my case, to an fstab entry?
> 
>    /dev/sda    /mnt    btrfs
> device=/dev/sdb,device=/dev/sdc,device=/dev/sdd     1 2
> 
> ?

Yes; it works for me.

> thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
