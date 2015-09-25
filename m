Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vandusen.herrbischoff.com ([148.251.66.209]:49606 "EHLO
	vandusen.herrbischoff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbbIYWOu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 18:14:50 -0400
Received: from port-90030.pppoe.wtnet.de ([84.46.64.31] helo=localhost)
	by vandusen.herrbischoff.com with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.82)
	(envelope-from <marcel@herrbischoff.com>)
	id 1ZfaoK-0005JU-Uc
	for linux-btrfs@vger.kernel.org; Fri, 25 Sep 2015 23:45:45 +0200
Date: Fri, 25 Sep 2015 23:45:44 +0200
From: Marcel Bischoff <marcel@herrbischoff.com>
To: linux-btrfs@vger.kernel.org
Subject: Too many missing devices, writeable mount is not allowed
Message-ID: <20150925214544.GB4639@herrbischoff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I have kind of a serious problem with one of my disks.

The controller of one of my external drives died (WD Studio). The disk 
is alright though. I cracked open the case, got the drive out and 
connected it via a SATA-USB interface.

Now, mounting the filesystem is not possible. Here's the message:

$ btrfs fi show
warning devid 3 not found already
Label: none  uuid: bd6090df-5179-490e-a5f8-8fbad433657f
        Total devices 3 FS bytes used 3.02TiB
        devid    1 size 596.17GiB used 532.03GiB path /dev/sdd
        devid    2 size 931.51GiB used 867.03GiB path /dev/sde
        *** Some devices missing

Yes, I did bundle up three drives with very different sizes with the 
--single option on creating the file system.

I have already asked for help on StackExchange but replies have been 
few. Now I thought people on this list, close to btrfs development may 
be able and willing to help. This would be so much appreciated.

Here's the issue with lots of information and a record of what I/we have 
tried up until now: 
http://unix.stackexchange.com/questions/231174/btrfs-too-many-missing-devices-writeable-mount-is-not-allowed

Thanks for your time and consideration!

Best,
Marcel
