Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:38626 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbcF3VCc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jun 2016 17:02:32 -0400
Received: by mail-wm0-f54.google.com with SMTP id r201so2827003wme.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jun 2016 14:02:31 -0700 (PDT)
Received: from system (dslb-188-099-185-114.188.099.pools.vodafone-ip.de. [188.99.185.114])
        by smtp.gmail.com with ESMTPSA id o2sm5311393wjp.26.2016.06.30.14.02.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jun 2016 14:02:29 -0700 (PDT)
Date: Thu, 30 Jun 2016 23:02:27 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160630230227.4582b5a2@system>
In-Reply-To: <CAJCQCtRjh6HEdVtkqNv4y-HZhv+deeVZ6J_AK3E1yog-1pswNA@mail.gmail.com>
References: <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
	<20160629005208.5e9addcf@system>
	<CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
	<20160629115055.29018e6a@system>
	<CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
	<20160629201208.275b37ad@system>
	<16e65a07-03b6-2540-fc96-3538c5bc5c99@gmail.com>
	<20160629210217.0e4e4d1c@system>
	<CAJCQCtRyPyXA+4+D-J8940xiOMcEwQHgsk6uSpnPeLUduAJd2Q@mail.gmail.com>
	<20160629211613.125ce3f0@system>
	<20160629192357.GC10223@carfax.org.uk>
	<20160630015109.6901070d@system>
	<CAJCQCtRjh6HEdVtkqNv4y-HZhv+deeVZ6J_AK3E1yog-1pswNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 29 Jun 2016 18:24:07 -0600, Chris Murphy
<lists@colorremedies.com> wrote :

> On Wed, Jun 29, 2016 at 5:51 PM, Saint Germain <saintger@gmail.com>
> wrote:
> > On Wed, 29 Jun 2016 19:23:57 +0000, Hugo Mills <hugo@carfax.org.uk>
> > wrote :
> >
> >> On Wed, Jun 29, 2016 at 09:16:13PM +0200, Saint Germain wrote:
> >> > On Wed, 29 Jun 2016 13:08:30 -0600, Chris Murphy
> >> > <lists@colorremedies.com> wrote :
> >> >
> >> > > >> > Ok I will follow your advice and start over with a fresh
> >> > > >> > BTRFS volume. As explained on another email, rsync doesn't
> >> > > >> > support reflink, so do you think it is worth trying with
> >> > > >> > BTRFS send instead ? Is it safe to copy this way or rsync
> >> > > >> > is more reliable in case of faulty BTRFS volume ?
> >> > > >> >
> >> > > >> If you have the space, btrfs restore would probably be the
> >> > > >> best option. It's not likely, but using send has a risk of
> >> > > >> contaminating the new filesystem as well.
> >> > > >>
> >> > > >
> >> > > > I have to copy through the network (I am running out of
> >> > > > disks...) so btrfs restore is unfortunately not an option.
> >> > > > I didn't know that btrfs send could contaminate the target
> >> > > > disk as well ?
> >> > > > Ok rsync it is then.
> >> > >
> >> > > restore will let you extract files despite csum errors. I don't
> >> > > think send will, and using cp or rsync Btrfs definitely won't
> >> > > hand over the file.
> >> > >
> >> >
> >> > That's Ok I'd prefer to avoid copying files with csum errors
> >> > anyway (I can restore them from backups).
> >> > However will btrfs send abort the whole operation as soon as it
> >> > finds a csum error ?
> >> > And will I have the risk to "contaminate" the target BTRFS
> >> > volume by using BTRFS send ?
> >>
> >>    A send stream is effectively just a sequence of filesystem
> >> commands (mv, cp, cp --reflink, rm, dd). So any damage that it can
> >> do when replayed by receive is limited to what you can do with the
> >> basic shell commands (plus cloning extents). If you have metadata
> >> breakage in your source filesystem, this won't cause the same
> >> metadata breakage to show up in the target filesystem.
> >>
> >
> > Well after 300GB copied through "btrfs send", the process is aborted
> > with the following error:
> > ERROR: send ioctl failed with -5: Input/output error
> > ERROR: unexpected EOF in stream.
> >
> > /var/log/syslog relevant lines are appended at the end of this
> > email.
> >
> > So it seems that I will have to go with rsync then.
> 
> You'll likely hit the same bad file and get EIO, is my guess. What you
> can do is mount it ro from the get go, and do btrfs send receive again
> and maybe then it won't hit this sequence where it's finding some need
> to clean up a transaction and free an extent. Maybe you still get some
> failure to send whatever file is using that extent, but I think
> receive will tolerate it.
> 

Well I tried "btrfs send" and the process stalled at 300 GB (on a total
of 2 TB) with a never ending stream of:
"ERROR: unexpected EOF in stream."
I gave up and launched a rsync which is about to be finished.

Now I have some work to make sure that all rsynced files are consistent
(I have to compared them to the backuped ones).

Thanks for your help, I learned a bit more about BTRFS this way.
