Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55540 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2GTM6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 08:58:13 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Very slow samba file transfer speed... any ideas ?
Date: Fri, 20 Jul 2012 14:58:11 +0200
Cc: Remco Hosman <remco@hosman.xs4all.nl>
References: <CALa9hx1ojpNEYOr8-pLbcm3Y80+GNaeJBtnEugh-BZF4OkpAHw@mail.gmail.com> <201207201115.42483.Martin@lichtvoll.de> <500923E5.6040609@hosman.xs4all.nl> (sfid-20120720_113234_810772_6AF30F06)
In-Reply-To: <500923E5.6040609@hosman.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207201458.12018.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 20. Juli 2012 schrieb Remco Hosman:
> > 11 really fast 15000rpm FC / SAS disks could possibly do 936 MB/s.
> > But regular 7200rpm SATA disks depending to the on disk location
> > might be as slow as 40-50 MB/s – just try fio disk-zone-profile on
> > one if you do not believe this – and then even with 11 disks 936
> > MB/s is out of reach.
> 
> My BTRFS array consists of 5 WD Green 2T disks. each of them goes a
> bit  over 100MB/sec on sequential read/write.

I tested 2 WD Green 1,5 TB and each of them goes about 90-100 MB/s at the 
beginning of the disk and about 40-50 MB/s at the end of the disk.

So did you run fio disk-zone-profile on the whole disk and made a graph?

If not, I do not believe your figures.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
