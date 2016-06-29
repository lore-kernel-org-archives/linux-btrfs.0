Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36063 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbcF2TQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 15:16:18 -0400
Received: by mail-wm0-f48.google.com with SMTP id f126so193851024wma.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 12:16:15 -0700 (PDT)
Received: from system (dslb-092-074-022-141.092.074.pools.vodafone-ip.de. [92.74.22.141])
        by smtp.gmail.com with ESMTPSA id z5sm126913wme.5.2016.06.29.12.16.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2016 12:16:14 -0700 (PDT)
Date: Wed, 29 Jun 2016 21:16:13 +0200
From: Saint Germain <saintger@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug during RAID1 replace
Message-ID: <20160629211613.125ce3f0@system>
In-Reply-To: <CAJCQCtRyPyXA+4+D-J8940xiOMcEwQHgsk6uSpnPeLUduAJd2Q@mail.gmail.com>
References: <20160627233612.662d2a9a@system>
	<CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
	<20160628002602.022258bf@system>
	<CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
	<CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
	<20160628010618.58e235fa@system>
	<CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
	<20160628024940.3b323b26@system>
	<CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
	<20160629005208.5e9addcf@system>
	<CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
	<20160629115055.29018e6a@system>
	<CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
	<20160629201208.275b37ad@system>
	<16e65a07-03b6-2540-fc96-3538c5bc5c99@gmail.com>
	<20160629210217.0e4e4d1c@system>
	<CAJCQCtRyPyXA+4+D-J8940xiOMcEwQHgsk6uSpnPeLUduAJd2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 29 Jun 2016 13:08:30 -0600, Chris Murphy
<lists@colorremedies.com> wrote :

> >> > Ok I will follow your advice and start over with a fresh BTRFS
> >> > volume. As explained on another email, rsync doesn't support
> >> > reflink, so do you think it is worth trying with BTRFS send
> >> > instead ? Is it safe to copy this way or rsync is more reliable
> >> > in case of faulty BTRFS volume ?
> >> >
> >> If you have the space, btrfs restore would probably be the best
> >> option. It's not likely, but using send has a risk of contaminating
> >> the new filesystem as well.
> >>
> >
> > I have to copy through the network (I am running out of disks...) so
> > btrfs restore is unfortunately not an option.
> > I didn't know that btrfs send could contaminate the target disk as
> > well ?
> > Ok rsync it is then.
> 
> restore will let you extract files despite csum errors. I don't think
> send will, and using cp or rsync Btrfs definitely won't hand over the
> file.
> 

That's Ok I'd prefer to avoid copying files with csum errors anyway (I
can restore them from backups).
However will btrfs send abort the whole operation as soon as it finds a
csum error ?
And will I have the risk to "contaminate" the target BTRFS volume by
using BTRFS send ?

Thanks !
