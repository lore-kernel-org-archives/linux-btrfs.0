Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:36516 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752204AbdG1Sof (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 14:44:35 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:35337)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dbAFV-0002I6-7N
        for linux-btrfs@vger.kernel.org; Fri, 28 Jul 2017 19:44:33 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dbAFQ-0006YJ-OQ
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 19:44:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22907.34316.375829.800577@tree.ty.sabi.co.uk>
Date: Fri, 28 Jul 2017 19:44:28 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs + compression = slow performance and high cpu usage
In-Reply-To: <8446582.541.1501260065690.JavaMail.gkos@dynomob>
References: <33040946.535.1501254718807.JavaMail.gkos@dynomob>
        <8446582.541.1501260065690.JavaMail.gkos@dynomob>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In addition to my previous "it does not happen here" comment, if
someone is reading this thread, there are some other interesting
details:

> When the compression is turned off, I am able to get the
> maximum 500-600 mb/s write speed on this disk (raid array)
> with minimal cpu usage.

No details on whether it is a parity RAID or not.

> btrfs device usage /mnt/arh-backup1/
> /dev/sda, ID: 2
>    Device size:            21.83TiB
>    Device slack:              0.00B
>    Data,single:             9.29TiB
>    Metadata,single:        46.00GiB
>    System,single:          32.00MiB
>    Unallocated:            12.49TiB

That's exactly 24TB of "Device size", of which around 45% are
used, and the string "backup" may suggest that the content is
backups, which may indicate a very fragmented freespace.
Of course compression does not help with that, in my freshly
created Btrfs volume I get as expected:

  soft#  umount /mnt/sde3
  soft#  mount -t btrfs -o commit=10 /dev/sde3 /mnt/sde3                         

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/sde3/testfile bs=1M count=10000 conv=fsync
  10000+0 records in
  10000+0 records out
  10485760000 bytes (10 GB) copied, 103.747 s, 101 MB/s
  0.00user 11.56system 1:44.86elapsed 11%CPU (0avgtext+0avgdata 3072maxresident)k
  20480672inputs+20498272outputs (1major+349minor)pagefaults 0swaps

  soft#  filefrag /mnt/sde3/testfile 
  /mnt/sde3/testfile: 11 extents found

versus:

  soft#  umount /mnt/sde3                                                        
  soft#  mount -t btrfs -o commit=10,compress=lzo,compress-force /dev/sde3 /mnt/sde3

  soft#  /usr/bin/time dd iflag=fullblock if=/dev/sda6 of=/mnt/sde3/testfile bs=1M count=10000 conv=fsync
  10000+0 records in                                                      
  10000+0 records out
  10485760000 bytes (10 GB) copied, 109.051 s, 96.2 MB/s
  0.02user 13.03system 1:49.49elapsed 11%CPU (0avgtext+0avgdata 3068maxresident)k
  20494784inputs+20492320outputs (1major+347minor)pagefaults 0swaps

  soft#  filefrag /mnt/sde3/testfile 
  /mnt/sde3/testfile: 49287 extents found

Most the latter extents are mercifully rather contiguous, their
size is just limited by the compression code, here is an extract
from 'filefrag -v' from around the middle:

  24757:  1321888.. 1321919:   11339579..  11339610:     32:   11339594:
  24758:  1321920.. 1321951:   11339597..  11339628:     32:   11339611:
  24759:  1321952.. 1321983:   11339615..  11339646:     32:   11339629:
  24760:  1321984.. 1322015:   11339632..  11339663:     32:   11339647:
  24761:  1322016.. 1322047:   11339649..  11339680:     32:   11339664:
  24762:  1322048.. 1322079:   11339667..  11339698:     32:   11339681:
  24763:  1322080.. 1322111:   11339686..  11339717:     32:   11339699:
  24764:  1322112.. 1322143:   11339703..  11339734:     32:   11339718:
  24765:  1322144.. 1322175:   11339720..  11339751:     32:   11339735:
  24766:  1322176.. 1322207:   11339737..  11339768:     32:   11339752:
  24767:  1322208.. 1322239:   11339754..  11339785:     32:   11339769:
  24768:  1322240.. 1322271:   11339771..  11339802:     32:   11339786:
  24769:  1322272.. 1322303:   11339789..  11339820:     32:   11339803:

But again this is on a fresh empty Btrfs volume.
