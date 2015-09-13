Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34879 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbbIMEzd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Sep 2015 00:55:33 -0400
Received: by pacfv12 with SMTP id fv12so113713911pac.2
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Sep 2015 21:55:33 -0700 (PDT)
Date: Sat, 12 Sep 2015 21:55:30 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Martin Bakiev <mbakiev@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Crash when trying to start a replace on missing device
Message-ID: <20150913045530.GA24813@mew>
References: <CAHs_hg33fkxpFzT881BGDOQNBaarcCiROHSG3Q2fCDn_SSLa-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHs_hg33fkxpFzT881BGDOQNBaarcCiROHSG3Q2fCDn_SSLa-g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 12, 2015 at 04:51:18PM -0600, Martin Bakiev wrote:
> Hi guys,
> 
> I'm just doing testing with btrfs and I ran into a crash when
> simulating a failed drive. I yanked out one (/dev/sdc) of 4 drives and
> tried to replace it with another (/dev/sdf) with this command:
> 
> btrfs replace start missing /dev/sdf /mount_point -f
> 
> That seemed to cause a crash, you can check out the attached dmesg
> file for stack/more info. I was told to report the crash on from IRC.
> I hope this helps.
> 
> Other info:
> uname -a:
> Linux fedora-nas 4.1.6-201.fc22.x86_64 #1 SMP Fri Sep 4 17:49:24 UTC
> 2015 x86_64 x86_64 x86_64 GNU/Linux
> 
> btrfs --version
> btrfs-progs v4.1
> 
> btrfs fi show
> Label: 'raid5'  uuid: 8b17c1d2-4ef6-4946-b77f-eac57c4e23a6
>        Total devices 5 FS bytes used 18.32GiB
>        devid    0 size 4.55TiB used 7.38GiB path /dev/sdf
>        devid    1 size 4.55TiB used 7.38GiB path /dev/sdb
>        devid    3 size 4.55TiB used 7.38GiB path /dev/sdd
>        devid    4 size 4.55TiB used 7.38GiB path /dev/sde
>        *** Some devices missing
> 
> btrfs fi df
> Data, RAID5: total=21.00GiB, used=18.30GiB
> System, RAID5: total=96.00MiB, used=16.00KiB
> Metadata, RAID5: total=1.03GiB, used=19.59MiB
> GlobalReserve, single: total=16.00MiB, used=0.00B
> 
> dmesg attached.
> 
> Thanks,
> Martin

Thanks for the report, Martin. This should be fixed in v4.3-rc1 if you
want to give that a spin. Specifically, you'll want these commits:

4a770891d9dd Btrfs: fix parity scrub of RAID 5/6 with missing device
73ff61dbe5ed Btrfs: fix device replace of a missing RAID 5/6 device
b4ee1782686d Btrfs: add RAID 5/6 BTRFS_RBIO_REBUILD_MISSING operation
7cb2c4202ed5 Btrfs: count devices correctly in readahead during RAID 5/6 replace
03679ade86b2 Btrfs: remove misleading handling of missing device scrub

-- 
Omar
