Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:51346 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751607AbdB0Xt6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Feb 2017 18:49:58 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:53510)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.88)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1ciTrT-001Tgb-OW
        for linux-btrfs@vger.kernel.org; Mon, 27 Feb 2017 22:33:43 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1ciTqd-0005Zg-1W
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Feb 2017 22:32:51 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22708.43280.792157.283517@tree.ty.sabi.co.uk>
Date: Mon, 27 Feb 2017 22:32:48 +0000
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Low IOOP Performance
In-Reply-To: <22708.42001.499487.802133@tree.ty.sabi.co.uk>
References: <CAAafysGxU9vaEs6actqX3ZFGkoXFvPFUAC1SjwtkZ97uuuFgJg@mail.gmail.com>
        <22708.23290.349489.765780@tree.ty.sabi.co.uk>
        <22708.42001.499487.802133@tree.ty.sabi.co.uk>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>> On Mon, 27 Feb 2017 22:11:29 +0000, pg@btrfs.list.sabi.co.UK (Peter Grandi) said:

> [ ... ]
>> I have a 6-device test setup at home and I tried various setups
>> and I think I got rather better than that.

[ ... ]

> That's a range of 700-1300 4KiB random mixed-rw IOPS,

Rerun with 1M blocksize:

  soft#  fio --directory=/mnt/sdb5 --runtime=30 --status-interval=10 --blocksize=1M blocks-randomish.fio | tail -3
  Run status group 0 (all jobs):
     READ: io=2646.0MB, aggrb=89372KB/s, minb=7130KB/s, maxb=7776KB/s, mint=30081msec, maxt=30317msec
    WRITE: io=2297.0MB, aggrb=77584KB/s, minb=6082KB/s, maxb=6796KB/s, mint=30081msec, maxt=30317msec

  soft#  fio --directory=/mnt/sdb6 --runtime=30 --status-interval=10 --blocksize=1M blocks-randomish.fio | tail -3
  Run status group 0 (all jobs):
     READ: io=2781.0MB, aggrb=94015KB/s, minb=5932KB/s, maxb=10290KB/s, mint=30121msec, maxt=30290msec
    WRITE: io=2431.0MB, aggrb=82183KB/s, minb=4779KB/s, maxb=9102KB/s, mint=30121msec, maxt=30290msec
  soft#  killall -9 fio                                                                                                               
  fio: no process found
    
  soft#  fio --directory=/mnt/md0 --runtime=30 --status-interval=10 --blocksize=1M blocks-randomish.fio | tail -3
  Run status group 0 (all jobs):
     READ: io=1504.0MB, aggrb=50402KB/s, minb=3931KB/s, maxb=4387KB/s, mint=30343msec, maxt=30556msec
    WRITE: io=1194.0MB, aggrb=40013KB/s, minb=3158KB/s, maxb=3475KB/s, mint=30343msec, maxt=30556msec

Interesting that Btrfs 'single' on MD RAID10 becomes rather
slower (I guess low level of intrinsic parallelism).

For comparison, the same on a JFS on top of MD RAID10:

  soft#  grep -A1 md40 /proc/mdstat 
  md40 : active raid10 sdg4[5] sdd4[2] sdb4[0] sdf4[4] sdc4[1] sde4[3]
	486538240 blocks super 1.0 512K chunks 3 near-copies [6/6] [UUUUUU]

  soft#  fio --directory=/mnt/md40 --runtime=30 --status-interval=10 --blocksize=4K blocks-randomish.fio | grep -A2 '(all jobs)' | tail -3
  Run status group 0 (all jobs):
     READ: io=31408KB, aggrb=1039KB/s, minb=80KB/s, maxb=90KB/s, mint=30206msec, maxt=30227msec
    WRITE: io=27800KB, aggrb=919KB/s, minb=70KB/s, maxb=81KB/s, mint=30206msec, maxt=30227msec

  soft#  fio --directory=/mnt/md40 --runtime=30 --status-interval=10 --blocksize=1M blocks-randomish.fio | grep -A2 '(all jobs)' | tail -3
  Run status group 0 (all jobs):
     READ: io=2151.0MB, aggrb=72619KB/s, minb=5865KB/s, maxb=6383KB/s, mint=30134msec, maxt=30331msec
    WRITE: io=1772.0MB, aggrb=59824KB/s, minb=4712KB/s, maxb=5365KB/s, mint=30134msec, maxt=30331msec

XFS is usually better at multithreaded workloads within the same
file (rather than across files).
