Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41039 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750909AbaH0QzD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 12:55:03 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 3.17: Yay! New sizes in df -h
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1940832.0FjNKhTY79@merkaba>
Date: Wed, 27 Aug 2014 10:54:56 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <B16D2447-74E8-44CD-BC56-BB3AA7E8A99C@colorremedies.com>
References: <1940832.0FjNKhTY79@merkaba>
To: Martin Steigerwald <Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 27, 2014, at 5:45 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Hi!
> 
> Now I get this with 3.17-rc2:
> 
> merkaba:~> LANG=C df -hT / /home
> Filesystem     Type   Size  Used Avail Use% Mounted on
> /dev/dm-5      btrfs   30G   17G   23G  43% /
> /dev/dm-0      btrfs  160G  129G   59G  69% /home
> 
> 
> /: 17+23 = 40 GiB, compressed 10 GiB away with lzo?
> /home: 59+129 = 188 GiB, compressed 28 GiB away with lzo?
> 
> 
> This is BTRFS RAID 1 on Dual SSD:
> 
> merkaba:~> btrfs fi df /
> Data, RAID1: total=25.00GiB, used=15.33GiB
> System, RAID1: total=8.00MiB, used=16.00KiB
> Metadata, RAID1: total=2.00GiB, used=677.33MiB
> unknown, single: total=240.00MiB, used=0.00
> 
> merkaba:~> btrfs fi df /home
> Data, RAID1: total=154.97GiB, used=125.70GiB
> System, RAID1: total=32.00MiB, used=48.00KiB
> Metadata, RAID1: total=5.00GiB, used=2.71GiB
> unknown, single: total=512.00MiB, used=0.00


Hmm, I'm not seeing such a large discrepancy between Used+Avail and Size.


No compression, all volumes populated with send/receive and contain same data.

3.16.1
# df -h
Filesystem               Size  Used Avail Use% Mounted on
/dev/sdb                  40G  2.8G   37G   7% /home        # single 40GB device
/dev/sdc                  40G  5.5G   33G  15% /mnt	    # two 20GB devices, raid1

Reboot 3.17.0rc2
# df -h
Filesystem               Size  Used Avail Use% Mounted on
/dev/sdb                  40G  2.8G   37G   7% /home        # single 40GB device
/dev/sdc                  20G  2.8G   17G  15% /mnt	    # two 20GB devices, raid1

======
sde is two 20GB devices, raid1, -o compress, populated the same as above w/ send/receive

3.16.1
Filesystem               Size  Used Avail Use% Mounted on
/dev/sde                  40G  3.8G   35G  10% /mnt

3.17.0rc2
Filesystem               Size  Used Avail Use% Mounted on
/dev/sde                  20G  2.0G   18G  10% /mnt


In the last example, Used went from 2.8G to 2.0G due to compression. But with or without compression, Used+Avail=Size.

Chris Murphy