Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp1.belwue.de ([129.143.2.12]:52895 "EHLO smtp1.belwue.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbbHMMPz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 08:15:55 -0400
Received: from fex.belwue.de (fex.belwue.de [129.143.4.198])
	by smtp1.belwue.de with ESMTP id t7DC2CfH019125
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 14:02:12 +0200 (MEST)
	env-from (framstag@rus.uni-stuttgart.de)
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
	by fex.belwue.de (Postfix) with SMTP id DF7F42036A
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 14:02:11 +0200 (CEST)
Date: Thu, 13 Aug 2015 14:02:11 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150813120211.GA24122@rus.uni-stuttgart.de>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <55CC488D.4020203@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CC488D.4020203@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 2015-08-13 (15:34), anand jain wrote:
> > root@toy02:~# df -T /data
> > Filesystem     Type   1K-blocks      Used  Available Use% Mounted on
> > /dev/sdb       btrfs 3906909856 140031696 3765056176   4% /data
> >
> > root@toy02:~# btrfs filesystem show /data
> > Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
> >          Total devices 2 FS bytes used 129.81GiB
> >          devid    3 size 1.82TiB used 67.03GiB path /dev/drbd2
> >          devid    4 size 1.82TiB used 67.03GiB path /dev/sdb
> >
> > Btrfs v3.12
> >
> > ==> btrfs shows the wrong (raw) device /dev/sdb instead of /dev/drbd3 !
> 
> Don't be too alarmed by that, progs do a bit of user land fabrication 
> (wrong). kernel may /may-not be using sdb. try -m option.

It is really weird: meanwhile (without any mount change or even reboot) I
get: 

root@toy02:~# btrfs filesystem show   
Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
        Total devices 2 FS bytes used 106.51GiB
        devid    3 size 1.82TiB used 82.03GiB path /dev/drbd2
        devid    4 size 1.82TiB used 82.03GiB path /dev/drbd3

==> no more /dev/sdb !

BUT:

root@toy02:~# df -T /data
Filesystem     Type   1K-blocks      Used  Available Use% Mounted on
/dev/sdb       btrfs 3906909856 111822636 3793208212   3% /data

root@toy02:~# mount | grep /data
/dev/sdb on /data type btrfs (rw)

root@toy02:~# grep /data /proc/mounts
/dev/drbd2 /data btrfs rw,relatime,space_cache 0 0

And still, Linux sees 3 HGST devices (there are real 2 drives):

root@toy02:~# hdparm -I /dev/sdb | grep Number:
        Model Number:       HGST HUS724020ALA640
        Serial Number:      PN2134P5G2P2AX

root@toy02:~# hdparm -I /dev/sdd | grep Number:
        Model Number:       HGST HUS724020ALA640
        Serial Number:      PN2134P5G2P2XX

root@toy02:~# hdparm -I /dev/sde | grep Number:
        Model Number:       HGST HUS724020ALA640
        Serial Number:      PN2134P5G2P2AX


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum IZUS/TIK         E-Mail: horlacher@tik.uni-stuttgart.de
Universitaet Stuttgart         Tel:    ++49-711-68565868
Allmandring 30a                Fax:    ++49-711-682357
70550 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<55CC488D.4020203@oracle.com>
