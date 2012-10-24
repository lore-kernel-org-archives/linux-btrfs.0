Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60224 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935311Ab2JXSGT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 14:06:19 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so397090bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 11:06:18 -0700 (PDT)
Message-ID: <50882E38.4000408@gmail.com>
Date: Wed, 24 Oct 2012 20:06:48 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: device delete, error removing device [SOLVED]
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se> <5086DDAE.3050708@gmail.com> <442D159A-4A4E-4A50-B1DB-0E6E12FA6F5C@colorremedies.com> <5086E9D6.4070201@inwind.it> <3443D67F-6CCE-48BF-A1DB-12473BE95EE8@colorremedies.com> <5087174A.2060405@inwind.it> <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com>
In-Reply-To: <1BE15E02-3DBE-42AB-8900-D82C11BCD1B7@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-24 00:29, Chris Murphy wrote:
> 
> On Oct 23, 2012, at 4:16 PM, Goffredo Baroncelli <kreijack@inwind.it>
> wrote:

> 
> I think it needs to be bigger. I was at a bit over 8GB file size for
> a 9GB file system (3x 3GB drives). There was about 300MB of free
> space left according to df -h, which was for the whole volume, i.e.
> maybe around 100MB free space per device, and hence possibly not
> enough room to budge unless I added yet another drive. Then it was
> able to back out.

I was able to reproduce it:

- I filled the filesystem until I got "No space left on device".
- Then I added a new device -> success
- I balanced -> success

The status is:
ghigo@emulato:~$ sudo /mnt/home-ghigo/btrfs/btrfs-progs/btrfs fi show
Label: 'test2'  uuid: 11d0f1a8-2770-4ff2-8df5-f772f1056edc
	Total devices 4 FS bytes used 8.29GB
	devid    4 size 12.00GB used 3.35GB path /dev/vdf
	devid    3 size 3.00GB used 2.53GB path /dev/vdd
	devid    2 size 3.00GB used 2.56GB path /dev/vdc
	devid    1 size 3.00GB used 2.55GB path /dev/vdb


Note the used space.

Then I removed /dev/vdb but I got

$ sudo /mnt/home-ghigo/btrfs/btrfs-progs/btrfs dev del /dev/vdb /mnt/btrfs1/
ERROR: error removing the device '/dev/vdb' - No space left on device


The interesting things is:

ghigo@emulato:~$ sudo /mnt/home-ghigo/btrfs/btrfs-progs/btrfs fi show
Label: 'test2'  uuid: 11d0f1a8-2770-4ff2-8df5-f772f1056edc
	Total devices 4 FS bytes used 7.63GB
	devid    4 size 12.00GB used 3.48GB path /dev/vdf
	devid    3 size 3.00GB used 3.00GB path /dev/vdd
	devid    2 size 3.00GB used 3.00GB path /dev/vdc
	devid    1 size 3.00GB used 2.55GB path /dev/vdb

So it seems that I spread all the data to the other disk, filling up the
smaller ones. So it stuck to "No space left on device".

Now I rebalanced with -dconvert=single, as suggested by Hugo, then I was
able to remove the disk:

Label: 'test2'  uuid: 11d0f1a8-2770-4ff2-8df5-f772f1056edc
	Total devices 3 FS bytes used 7.63GB
	devid    4 size 12.00GB used 9.48GB path /dev/vdf
	devid    3 size 3.00GB used 492.94MB path /dev/vdd
	devid    2 size 3.00GB used 64.00MB path /dev/vdc



GB
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
