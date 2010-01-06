From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: btrfs-progs: New utility to swap subvolumes
Date: Wed, 6 Jan 2010 08:56:17 +0100
Message-ID: <201001060856.17940.kreijack@libero.it>
References: <4B32CF4D.90406@jp.fujitsu.com> <201001041820.03591.kreijack@libero.it> <4B43D4C9.2000705@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B43D4C9.2000705@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 06 January 2010, TARUISI Hiroaki wrote:
> Thanks for your greetings.
> 
> I read your article, and could follow your idea, which looks
> very practical rule to me.
> But we may need some application which support to create or maintain
> these rules because the relation mount point and subvolumes and
> snapshots gets complicated as number of subvolumes increases.

I wrote a little script which handle the snapshot creation/deleting/listing 
and grub config file update.

This script supposing the layout which I discussed

- under /var/btrfs is mounter the real root btrfs filesystem
- under the real root file-system there are the snapshots and the root of the 
system (rootfs)
- in /var/btrfs/snaplist.txt there is the list of snaphsot
- in /boot/grub/menu.lst there is the grub configuration

In you are interested, I can send you.

BR 
Goffredo

> Regards,
> taruisi
> 
> (2010/01/05 2:20), Goffredo Baroncelli wrote:
> > On Monday 04 January 2010, TARUISI Hiroaki wrote:
> >> Buon anno, Goffredo.
> > あけまして おめでとう Taruisi,
> > 
> > (I hope that happy new year is correctly written)
> >>
> >> Taking snapshot in btrfs is very easy, but handling snapshots is
> >> very confusing. So, we must make a rule of snapshotting such as
> >> your proposal, which seems to me very good and useful.
> >> If rules like this are forced regardless of operator's preference,
> >> this utility may become a deadwood.
> > 
> > I detailed this idea in this article
> > 
> > http://kreijack.blogspot.com/2010/01/linux-btrfs-example-of-layout.html
> > 
> > BR
> > G.Baroncelli
> > 
> 
> 
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
