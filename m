Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.rus.uni-stuttgart.de ([129.69.192.2]:40760 "EHLO
	mx2.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbHNHcO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 03:32:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx2.rus.uni-stuttgart.de (Postfix) with ESMTP id 1B8C7200B6
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 09:32:13 +0200 (CEST)
Received: from mx2.rus.uni-stuttgart.de ([127.0.0.1])
	by localhost (mx2.rus.uni-stuttgart.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ws3J3OyBmAy6 for <linux-btrfs@vger.kernel.org>;
	Fri, 14 Aug 2015 09:32:11 +0200 (CEST)
Received: from diaspora.rus.uni-stuttgart.de (diaspora.rus.uni-stuttgart.de [129.69.13.139])
	by mx2.rus.uni-stuttgart.de (Postfix) with SMTP
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 09:32:11 +0200 (CEST)
Date: Fri, 14 Aug 2015 09:32:11 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID0 wrong (raw) device?
Message-ID: <20150814073211.GA10650@rus.uni-stuttgart.de>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
 <55CC488D.4020203@oracle.com>
 <20150813120211.GA24122@rus.uni-stuttgart.de>
 <20150813145556.GA27405@rus.uni-stuttgart.de>
 <55CCC4AB.2080600@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55CCC4AB.2080600@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2015-08-14 (00:24), Anand Jain wrote:

> >> root@toy02:~# btrfs filesystem show
> >> Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
> >>          Total devices 2 FS bytes used 106.51GiB
> >>          devid    3 size 1.82TiB used 82.03GiB path /dev/drbd2
> >>          devid    4 size 1.82TiB used 82.03GiB path /dev/drbd3
> >
> > And now, after a reboot:
> >
> > root@toy02:~/bin# btrfs filesystem show
> > Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
> >          Total devices 2 FS bytes used 119.82GiB
> >          devid    3 size 1.82TiB used 82.03GiB path /dev/drbd2
> >          devid    4 size 1.82TiB used 82.03GiB path /dev/sde
> >
> > GRMPF!
> 
> pls use 'btrfs fi show -m' and just ignore no option or -d if fs is 
> mounted, as -m reads from the kernel.

There is now a new behaviour: after the btrfs mount, I can see shortly the
wrong raw device /dev/sde and a few seconds later there is the correct
/dev/drbd3 :


root@toy02:/etc# umount /data
root@toy02:/etc# mount /data
root@toy02:/etc# btrfs filesystem show
Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
        Total devices 2 FS bytes used 109.56GiB
        devid    3 size 1.82TiB used 63.03GiB path /dev/drbd2
        devid    4 size 1.82TiB used 63.03GiB path /dev/sde

Btrfs v3.12
root@toy02:/etc# btrfs filesystem show
Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
        Total devices 2 FS bytes used 109.56GiB
        devid    3 size 1.82TiB used 63.03GiB path /dev/drbd2
        devid    4 size 1.82TiB used 63.03GiB path /dev/drbd3

Btrfs v3.12

root@toy02:/etc# btrfs filesystem show -m
Label: data  uuid: 411af13f-6cae-4f03-99dc-5941acb3135b
        Total devices 2 FS bytes used 109.56GiB
        devid    3 size 1.82TiB used 63.03GiB path /dev/drbd2
        devid    4 size 1.82TiB used 63.03GiB path /dev/drbd3

Btrfs v3.12


Still, the kernel sees 3 instead of (really) 2 HGST drives:

root@toy02:/etc# hdparm -I /dev/sdb | grep Number:
        Model Number:       HGST HUS724020ALA640
        Serial Number:      PN2134P5G2P2AX

root@toy02:/etc# hdparm -I /dev/sde | grep Number:
        Model Number:       HGST HUS724020ALA640
        Serial Number:      PN2134P5G2P2AX

root@toy02:/etc# hdparm -I /dev/sdd | grep Number:
        Model Number:       HGST HUS724020ALA640
        Serial Number:      PN2134P5G2P2XX

-- 
Ullrich Horlacher              Informationssysteme und Serverbetrieb
IZUS/TIK                       E-Mail: horlacher@rus.uni-stuttgart.de
Universitaet Stuttgart         Tel:    ++49-711-68565868
Allmandring 30a                Fax:    ++49-711-682357
70550 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<55CCC4AB.2080600@oracle.com>
