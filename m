Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41157 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LRKor (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 05:44:47 -0500
Received: by mail-wi0-f169.google.com with SMTP id hn6so4862366wib.0
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 02:44:46 -0800 (PST)
Received: from pdb1.th.formicary.net (vl488-formicary-host150.jump.net.uk. [212.13.207.150])
        by mx.google.com with ESMTPSA id mt2sm2860842wic.7.2013.12.18.02.44.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 18 Dec 2013 02:44:45 -0800 (PST)
Date: Wed, 18 Dec 2013 10:44:43 +0000
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance on single device
Message-ID: <20131218104442.GA28559@pdb1.th.formicary.net>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
 <20131215202456.GA11281@carfax.org.uk>
 <CAAeznTryb7kyuvEyBFniv-UtGCQwdNtZMhpxm=-2MtKZSOj9Tw@mail.gmail.com>
 <pan$138cb$448d68e$2d9dcb10$fc6a898a@cox.net>
 <CAAeznTpZ6p1_ZR6xy-YGynAJu88jZ_52AQURuxT4qTeEYLOjdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAeznTpZ6p1_ZR6xy-YGynAJu88jZ_52AQURuxT4qTeEYLOjdg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using the same subject as it might be relevant, feel free to change it.#

I'm trying to do some maintenance to the system running over a btrfs file system on root (/). I started a balance on the '/' partition and it failed with the below information:
$ sudo btrfs balance start /
[sudo] password for inglor:
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
$ dmesg | tail
[93827.115887] btrfs: found 29461 extents
[93827.481849] btrfs: relocating block group 29855055872 flags 1
[93841.646011] btrfs: found 33171 extents
[93851.421207] btrfs: found 33171 extents
[93851.782054] btrfs: relocating block group 28781314048 flags 1
[93866.815342] btrfs: found 52535 extents
[93877.159354] btrfs: found 52534 extents
[93877.356805] btrfs: relocating block group 28747759616 flags 34
[93880.287185] btrfs: found 1 extents
[93880.608798] btrfs: 1 enospc errors during balance

$ df |grep sda2
/dev/sda2       20971520  13980396   5797124  71% /


$ sudo btrfs fi show
[sudo] password for inglor:
Label: none  uuid: 699d671b-7064-441d-95ec-c616049fe287
        Total devices 1 FS bytes used 12.75GB
        devid    1 size 20.00GB used 15.31GB path /dev/sda2

Btrfs v0.20-rc1-358-g194aa4a-dirty

$ sudo btrfs fi df /
[sudo] password for inglor:
Data: total=13.00GB, used=12.16GB
System, DUP: total=32.00MB, used=4.00KB
Metadata, DUP: total=1.12GB, used=601.54MB

Does it really needs more than 5.7GB to do a balance? I though it suppose to move chunks one by one and considering the chunks for Data is 1GB and for MetaData 512MB (256 x2 for dublication) it should be more than enough.
Also I had less space before and the dmesg reported 7 enospc errors. With cleaning a bit of packages installed now it reports only 1 enospc. Is that anywhere relevant?

Thanks,
Leonidas
