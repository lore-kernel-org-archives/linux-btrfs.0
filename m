Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:51337 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbdB0Xt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 18:49:56 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:53470)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1ciTWI-001Sv5-VR
        for linux-btrfs@vger.kernel.org; Mon, 27 Feb 2017 22:11:51 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ciTVx-0005Ry-Ra
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 22:11:29 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22708.42001.499487.802133@tree.ty.sabi.co.uk>
Date: Mon, 27 Feb 2017 22:11:29 +0000
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Low IOOP Performance
In-Reply-To: <22708.23290.349489.765780@tree.ty.sabi.co.uk>
References: <CAAafysGxU9vaEs6actqX3ZFGkoXFvPFUAC1SjwtkZ97uuuFgJg@mail.gmail.com>
        <22708.23290.349489.765780@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

> I have a 6-device test setup at home and I tried various setups
> and I think I got rather better than that.

* 'raid1' profile:

  soft#  btrfs fi df /mnt/sdb5                                                                                                        

  Data, RAID1: total=273.00GiB, used=269.94GiB
  System, RAID1: total=32.00MiB, used=56.00KiB
  Metadata, RAID1: total=1.00GiB, used=510.70MiB
  GlobalReserve, single: total=176.00MiB, used=0.00B

  soft#  fio --directory=/mnt/sdb5 --runtime=30 --status-interval=10 blocks-randomish.fio | tail -3                                   
  Run status group 0 (all jobs):
     READ: io=105508KB, aggrb=3506KB/s, minb=266KB/s, maxb=311KB/s, mint=30009msec, maxt=30090msec
    WRITE: io=100944KB, aggrb=3354KB/s, minb=256KB/s, maxb=296KB/s, mint=30009msec, maxt=30090msec

* 'raid10' profile:

  soft#  btrfs fi df /mnt/sdb6
  Data, RAID10: total=276.00GiB, used=272.49GiB
  System, RAID10: total=96.00MiB, used=48.00KiB
  Metadata, RAID10: total=3.00GiB, used=512.06MiB
  GlobalReserve, single: total=176.00MiB, used=0.00B

  soft#  fio --directory=/mnt/sdb6 --runtime=30 --status-interval=10 blocks-randomish.fio | tail -3                                   
  Run status group 0 (all jobs):
     READ: io=89056KB, aggrb=2961KB/s, minb=225KB/s, maxb=271KB/s, mint=30009msec, maxt=30076msec
    WRITE: io=85248KB, aggrb=2834KB/s, minb=212KB/s, maxb=261KB/s, mint=30009msec, maxt=30076msec

* 'single' profile on MD RAID10:

  soft#  btrfs fi df /mnt/md0
  Data, single: total=278.01GiB, used=274.32GiB
  System, single: total=4.00MiB, used=48.00KiB
  Metadata, single: total=2.01GiB, used=615.73MiB
  GlobalReserve, single: total=208.00MiB, used=0.00B

  soft#  grep -A1 md0 /proc/mdstat 
  md0 : active raid10 sdg1[6] sdb1[0] sdd1[2] sdf1[4] sdc1[1] sde1[3]
	364904232 blocks super 1.0 8K chunks 2 near-copies [6/6] [UUUUUU]
	
  soft#  fio --directory=/mnt/md0 --runtime=30 --status-interval=10 blocks-randomish.fio | tail -3                                    
  Run status group 0 (all jobs):
     READ: io=160928KB, aggrb=5357KB/s, minb=271KB/s, maxb=615KB/s, mint=30012msec, maxt=30038msec
    WRITE: io=158892KB, aggrb=5289KB/s, minb=261KB/s, maxb=616KB/s, mint=30012msec, maxt=30038msec

That's a range of 700-1300 4KiB random mixed-rw IOPS, quite
reasonable for 6x 1TB 7200RPM SATA drives, each capable of
100-120. It helps that the test file is just 100G, 10% of the
total drive extent, so arm movement is limited.

Not surprising that the much more mature MD RAID has an edge, a
bit stranger that on this the 'raid1' profile seems a bit faster
than the 'raid10' profile.

The much smaller numbers seem to happen to me too (probably some
misfeature of 'fio') with 'buffered=1', and the larger numbers
for ZFSonLinux are "suspicious".

> It seems unlikely to me that you got that with a 10-device
> mirror 'vdev', most likely you configured it as a stripe of 5x
> 2-device mirror vdevs, that is RAID10.

Indeed I double checked the end of the attached lost and that
was the case.

My FIO config file:

  # vim:set ft=ini:

  [global]
  filename=FIO-TEST
  fallocate=keep
  size=100G

  buffered=0
  ioengine=libaio
  io_submit_mode=offload

  iodepth=2
  numjobs=12
  blocksize=4K

  kb_base=1024

  [rand-mixed]

  rw=randrw
  stonewall
