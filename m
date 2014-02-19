Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f193.google.com ([209.85.215.193]:56222 "EHLO
	mail-ea0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaBSNqF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 08:46:05 -0500
Received: by mail-ea0-f193.google.com with SMTP id f15so187852eak.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 05:46:02 -0800 (PST)
Received: from linuxpc.localnet (194-118-189-56.adsl.highway.telekom.at. [194.118.189.56])
        by mx.google.com with ESMTPSA id x2sm928321eeo.8.2014.02.19.05.46.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 19 Feb 2014 05:46:01 -0800 (PST)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Incremental backup over writable snapshot
Date: Wed, 19 Feb 2014 14:45:57 +0100
Message-ID: <17860756.QfG9CfNMqv@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

As suggested in another thread, I would like to know the reliability of the 
following backup scheme:

Suppose I have a subvolume of my homedirectory  called @home. 

Now I am interested in making incremental backups of data in home I am 
interested in, but not everything, so I create a normal snapshot of @home 
called @home-w and delete the files/folders I am not interested in backing up. 
After that I create a readonly snapshot of @home-w called @home-r, that I sent 
to my target volume with btrfs send. 

After that is done, I do regular backups, by always going over the writeable 
snapshot where I remove always the same directories I am not interested and 
send the difference to the target volume with  btrfs send -p @home-r @home-r-1| 
btrfs receive /path/of/target/volume. 

I do not like the idea of making subvolumes of all directories I am not 
interested in backing up.

So what I would like to know now is the following: Could there be drawbacks of 
doing this resp. could I further optimize my backup strategy, as I experienced 
it takes a while for deleting large files in the writeable snapshot (What does 
it write there?)

Could my method somehow lead to inefficiency in terms of the disk space used at 
the target volume (I mean, could the deleting cause a change, so that more is 
actually transferred as change, than in reality is?)?

One last question would be: Is there a quick way I could verify the local read 
only snapshot used last time is the same as the one synced to the target 
volume last time?


Thank you for your support and the great work!
