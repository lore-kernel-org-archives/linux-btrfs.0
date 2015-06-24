Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33188 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbFXI2L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 04:28:11 -0400
Received: by wgck11 with SMTP id k11so29690948wgc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2015 01:28:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150624032008.GF20517@merlins.org>
References: <20150604084245.GR23272@merlins.org>
	<20150624032008.GF20517@merlins.org>
Date: Wed, 24 Jun 2015 10:28:09 +0200
Message-ID: <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
Subject: Re: counting fragments takes more time than defragmenting
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 June 2015 at 05:20, Marc MERLIN <marc@merlins.org> wrote:
>
> Hello again,
>
> Just curious, is anyone seeing similar things with big VM images or other
> DBs?
> I forgot to mention that my vdi file is 88GB.
>
> It's surprising that it took longer to count the fragments than to actually
> defragment the file.
> Or that it took 3 defrag runs to get down to 11K extents from 104K.
>
> Are others seeing similar things?

Filefrag is pretty much instant for my 30GB (150 extents) virtual
disk, no CoW on file, no snapshots on volume.

But what doesn't make sense to me is btrfs fi defrag; the -t option says

           -t <size>
               defragment only files at least <size> bytes big

The -t value goes into struct
btrfs_ioctl_defrag_range_args.extent_thresh which is documented as

       /*
         * any extent bigger than this will be considered
         * already defragged.  Use 0 to take the kernel default
         * Use 1 to say every single extent must be rewritten
         */

Default extent_thresh is 256K. I can't see how 1 would say every
single extent must be rewritten. On the contrary; 1 skips every
extent. The compress flag even sets extent_thresh=(u32)-1 to force a
rewrite.

Marc, try btrfs fi defrag -t 4294967295 Win7.vdi for maximum defrag
and time filefrag again with fewer extents.

/Patrik


> Marc
>
> On Thu, Jun 04, 2015 at 05:42:45PM +0900, Marc MERLIN wrote:
> > Hi Chris,
> >
> > After our quick chat, I gave it a shot on 3.19.6, and things are better
> > than last time I tried.
> >
> > legolas:/var/local/nobck/VirtualBox VMs# lsattr Win7/
> > ---------------C Win7/Logs
> > ---------------C Win7/Snapshots
> > ---------------C Win7/Win7.vdi
> > ---------------C Win7/Win7.png
> > ---------------C Win7/autotune1.png
> > ---------------C Win7/new_autotune2.png
> > ---------------C Win7/Win7.vbox-prev
> > ---------------C Win7/Win7.vbox
> >
> > But I have snapshots of that subvolume, so obviously that gets
> > in the way of disabling COW.
> >
> > I had a look, and I have 100K fragments. That took 10mn to figure out:
> >
> > legolas:/var/local/nobck/VirtualBox VMs/Win7# filefrag Win7.vdi
> > Win7.vdi: 104306 extents found
> >
> > This first filefrag run took about 10mn to count all the fragments on my
> > SSD. That feels a bit slow, but maybe the userland tool is doing things
> > in suboptimal ways.
> >
> > Defrag actually worked (mostly) and wasn't too slow. It used to take hours
> > not to finish, and now it worked in 3mn:
> > legolas:/var/local/nobck/VirtualBox VMs/Win7# time btrfs fi defrag Win7.vdi
> > real  3m43.807s
> > user  0m0.000s
> > sys   0m44.044s
> >
> > This is defintely better than before.
> > Note that it's not fully defragged, but close enough. Each subsequent
> > run, filefrag is faster, and defrag is still faster than filefrag:
> >
> > legolas:/var/local/nobck/VirtualBox VMs/Win7# time filefrag Win7.vdi
> > Win7.vdi: 11428 extents found
> > real  2m42.090s
> > user  0m0.000s
> > sys   2m37.308s
> >
> > legolas:/var/local/nobck/VirtualBox VMs/Win7# time btrfs fi defrag Win7.vdi
> > real  0m7.483s
> > user  0m0.000s
> > sys   0m2.672s
> >
> > legolas:/var/local/nobck/VirtualBox VMs/Win7# time filefrag Win7.vdi
> > Win7.vdi: 11132 extents found
> > real  0m22.525s
> > user  0m0.000s
> > sys   0m22.264s
> >
> > It's a bit unexpected that I still have 10k fragments after 2 defrag
> > runs, but it's better than 100k :)
> >
> > Marc
> > --
> > "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> > Microsoft is to operating systems ....
> >                                       .... what McDonalds is to gourmet cooking
> > Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
