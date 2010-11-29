From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Root fs on raid1
Date: Mon, 29 Nov 2010 19:02:44 +0100
Message-ID: <201011291902.45064.kreijack@libero.it>
References: <GM8zfnmgV9SK.SwXVG4nX@mail.prnet.org> <201011180759.36779.kreijack@libero.it> <AANLkTi=hSJkDBQz6pg=a9Wdm28NpJBgBB4snu1XEAQsZ@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: linux-btrfs@vger.kernel.org
To: Erik Jensen <eriksjunk@rkjnsn.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=hSJkDBQz6pg=a9Wdm28NpJBgBB4snu1XEAQsZ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, 29 November, 2010, you (Erik Jensen) wrote:
> I have a similar setup on one of my computers.  I set it up a while ago
> using an initramfs, but I could not get the device scan to work properly,
> for whatever reason.  I ended up having it just trying to mount every device
> in the array in turn.  When it gets to the last device, the array mounts
> since btrfs now knows about all of the other ones.  Really ugly, I know, but
> it works.
>

I also had a lot of problem to get a btrfs-aware initramfs working properly. 
One of the biggest proble was to find the right list of modules. Btrfs depends 
by crc32c, and I need a lot of retries to discover it.

The main problem was that if the module is not available (it is the case of a 
initramfs) btrfs doesn't start...

When you say " it just trying to mount every device in the array in turn", do 
you mean in the initarmfs ?



> -- Erik Jensen
> 
> On Wed, Nov 17, 2010 at 10:59 PM, Goffredo Baroncelli 
<kreijack@libero.it>wrote:
> 
> > On Thursday, 18 November, 2010, admin@prnet.org wrote:
> > > Hi,
> > >
> > > I have read that for using raid1 btrfs device scan must be run before
> > mounting the fs. How do I proceed if root filesystem is mounted from btrfs
> > ?
> > >
> >
> >
> > See a my previous post
> >
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04709.html
> >
> >
> > > Thanks in advance
> > > Bye,
> > > David Arendt
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
> >
> > --
> > gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <
> > kreijack@inwind.it>
> > Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
