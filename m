Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:44906 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab2HBLZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 07:25:18 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: How can btrfs take 23sec to stat 23K files from an SSD?
Date: Thu, 2 Aug 2012 13:25:17 +0200
Cc: Marc MERLIN <marc@merlins.org>, "Fajar A. Nugraha" <list@fajar.net>
References: <20120722185848.GA10089@merlins.org> <201208012357.39786.Martin@lichtvoll.de> <20120802050741.GA22772@merlins.org> (sfid-20120802_121045_885836_CB856E78)
In-Reply-To: <20120802050741.GA22772@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208021325.17433.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 2. August 2012 schrieb Marc MERLIN:
> So, doctor, is it bad? :)
> 
> randomwrite: (g=0): rw=randwrite, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentialwrite: (g=1): rw=write, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> randomread: (g=2): rw=randread, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> sequentialread: (g=3): rw=read, bs=2K-16K/2K-16K, ioengine=libaio, iodepth=64
> 2.0.8
> Starting 4 processes
> randomwrite: Laying out IO file(s) (1 file(s) / 2048MB)
> Jobs: 1 (f=1): [___R] [100.0% done] [558.8M/0K /s] [63.8K/0  iops] [eta 00m:00s]  
> randomwrite: (groupid=0, jobs=1): err= 0: pid=7193
>   write: io=102048KB, bw=1700.8KB/s, iops=189 , runt= 60003msec
>     slat (usec): min=21 , max=219834 , avg=5250.91, stdev=5936.55
>     clat (usec): min=25 , max=738932 , avg=329339.45, stdev=106004.63
>      lat (msec): min=4 , max=751 , avg=334.59, stdev=107.57
>     clat percentiles (msec):

Heck, I didn´t look at the IOPS figure!

189 IOPS for a SATA-600 SSD. Thats pathetic.

So again, please test this without dm_crypt. I can´t believe that this
is the maximum the hardware is able to achieve.

A really fast 15000 rpm SAS harddisk might top that.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
