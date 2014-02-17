Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:58193 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaBQJ0e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 04:26:34 -0500
Received: from frosties.localnet ([149.172.224.32]) by smtp.web.de (mrweb003)
 with ESMTPSA (Nemesis) id 0Lfzwp-1X45dT0wqx-00pboT for
 <linux-btrfs@vger.kernel.org>; Mon, 17 Feb 2014 10:26:32 +0100
Date: Mon, 17 Feb 2014 10:26:31 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Dan van der Ster <dan@vanderster.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with 270GiB free
Message-ID: <20140217092631.GA32256@frosties>
References: <20140216135808.GA1491@frosties>
 <CABZ+qqmbU3gR-FeR4tpok-QcUgVyCL5Vq5ygrmM4CEqf=PTXcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABZ+qqmbU3gR-FeR4tpok-QcUgVyCL5Vq5ygrmM4CEqf=PTXcw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 17, 2014 at 08:42:23AM +0100, Dan van der Ster wrote:
> Did you already try this?? [1]:
> 
>    btrfs fi balance start -dusage=5 /mnt/nas3
> 
> Cheers, dan
> 
> [1] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_get_.22No_space_left_on_device.22_errors.2C_but_df_says_I.27ve_got_lots_of_space
> 
> On Sun, Feb 16, 2014 at 2:58 PM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
> > Hi,
> >
> > I'm getting a ENOSPC error from btrfs despite there still being plenty
> > of space left:
> >
> > % df -m /mnt/nas3
> > Filesystem         1M-blocks     Used Available Use% Mounted on
> > /dev/mapper/nas3-a  19077220 18805132    270773  99% /mnt/nas3
> >
> > % btrfs fi show
> > Label: none  uuid: 4b18f84e-2499-41ca-81ff-fe1783c11491
> >         Total devices 1 FS bytes used 17.91TiB
> >         devid    1 size 18.19TiB used 17.94TiB path /dev/mapper/nas3-a
> >
> > Btrfs v3.12
> >
> > % btrfs fi df
> > Data, single: total=17.89TiB, used=17.88TiB
> > System, DUP: total=32.00MiB, used=1.92MiB
> > Metadata, DUP: total=25.50GiB, used=24.89GiB
> >
> > As you can see there are still 270GiB free and plenty of block groups
> > free on the device too.
> >
> > So why isn't btrfs allocating a new block group to store more data?
> >
> > MfG
> >         Goswin

I did and that isn't the problem. Balancing only frees up partially
used block groups so they can be reused. But the problem is that the
remaining free block groups are not getting used.

MfG
	Goswin
