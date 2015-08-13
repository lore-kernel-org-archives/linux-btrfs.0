Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.belwue.de ([129.143.2.15]:48887 "EHLO smtp2.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbbHMOz6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 10:55:58 -0400
Received: from fex.belwue.de (fex.belwue.de [129.143.4.198])
	by smtp2.belwue.de with ESMTP id t7DEtvtR016219
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:55:57 +0200 (MEST)
	env-from (framstag@rus.uni-stuttgart.de)
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
	by fex.belwue.de (Postfix) with SMTP id 988C620324
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 16:47:23 +0200 (CEST)
Date: Thu, 13 Aug 2015 16:55:56 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150813145556.GA27405@rus.uni-stuttgart.de>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <55CC488D.4020203@oracle.com>
 <20150813120211.GA24122@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150813120211.GA24122@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 2015-08-13 (14:02), Ulli Horlacher wrote:
> On Thu 2015-08-13 (15:34), anand jain wrote:
> 
> > > root@toy02:~# df -T /data
> > > Filesystem     Type   1K-blocks      Used  Available Use% Mounted on
> > > /dev/sdb       btrfs 3906909856 140031696 3765056176   4% /data
> > >
> > > root@toy02:~# btrfs filesystem show /data
> > > Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
> > >          Total devices 2 FS bytes used 129.81GiB
> > >          devid    3 size 1.82TiB used 67.03GiB path /dev/drbd2
> > >          devid    4 size 1.82TiB used 67.03GiB path /dev/sdb
> > >
> > > Btrfs v3.12
> > >
> > > ==> btrfs shows the wrong (raw) device /dev/sdb instead of /dev/drbd3 !
> > 
> > Don't be too alarmed by that, progs do a bit of user land fabrication 
> > (wrong). kernel may /may-not be using sdb. try -m option.
> 
> It is really weird: meanwhile (without any mount change or even reboot) I
> get: 
> 
> root@toy02:~# btrfs filesystem show   
> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
>         Total devices 2 FS bytes used 106.51GiB
>         devid    3 size 1.82TiB used 82.03GiB path /dev/drbd2
>         devid    4 size 1.82TiB used 82.03GiB path /dev/drbd3

And now, after a reboot:

root@toy02:~/bin# btrfs filesystem show
Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
        Total devices 2 FS bytes used 119.82GiB
        devid    3 size 1.82TiB used 82.03GiB path /dev/drbd2
        devid    4 size 1.82TiB used 82.03GiB path /dev/sde

GRMPF!


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum IZUS/TIK         E-Mail: horlacher@tik.uni-stuttgart.de
Universitaet Stuttgart         Tel:    ++49-711-68565868
Allmandring 30a                Fax:    ++49-711-682357
70550 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20150813120211.GA24122@rus.uni-stuttgart.de>
