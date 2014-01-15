Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36569 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750856AbaAOTi5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 14:38:57 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:58651 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W3WIh-004OOc-M7
	for linux-btrfs@vger.kernel.org; Wed, 15 Jan 2014 12:38:56 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: why am  I getting "No space left on device" here?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140115115543.790adafb@wpkg.org>
Date: Wed, 15 Jan 2014 12:38:56 -0700
Message-Id: <90D4E931-4763-4369-BCCC-93B4B6E2EA1E@colorremedies.com>
References: <20140115115543.790adafb@wpkg.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 15, 2014, at 3:55 AM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> I'm no longer able to write to this btrfs filesystem:
> 
> # df -h /home
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/sdb4       5.2T  3.6T  1.6T  71% /home
> 
> 
> # btrfs fi show /home
> Label: crawler-btrfs  uuid: 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
>        Total devices 2 FS bytes used 1.80TiB
>        devid    3 size 2.56TiB used 1.80TiB path /dev/sdb4
>        devid    4 size 2.56TiB used 1.80TiB path /dev/sda4
> 
> Btrfs v3.12
> 
> 
> # btrfs filesystem df /home
> Data, RAID1: total=1.75TiB, used=1.75TiB
> System, RAID1: total=32.00MiB, used=268.00KiB
> Metadata, RAID1: total=53.00GiB, used=51.71GiB
> 
> 
> However:
> 
> # dd if=/dev/urandom of=bigfile
> dd: writing to `bigfile': No space left on device
> 186+0 records in
> 185+0 records out
> 94720 bytes (95 kB) copied, 0.0144045 s, 6.6 MB/s
> 
> 
> I don't understand why - can anyone explain?

What kernel version? Can you:

umount
dmesg -n7
mount

And then try to reproduce the behavior and note any kernel messages in dmesg?


Chris Murphy
