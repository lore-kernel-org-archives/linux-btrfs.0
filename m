Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58085 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3AFNCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Jan 2013 08:02:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Trps6-0007rU-JN
	for linux-btrfs@vger.kernel.org; Sun, 06 Jan 2013 14:02:38 +0100
Received: from host385.static.otenet.gr ([62.103.130.130])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 14:02:38 +0100
Received: from tmjuju by host385.static.otenet.gr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 14:02:38 +0100
To: linux-btrfs@vger.kernel.org
From: TM <tmjuju@yahoo.com>
Subject: Re: block rsv returned -28
Date: Sun, 6 Jan 2013 13:02:10 +0000 (UTC)
Message-ID: <loom.20130106T140036-764@post.gmane.org>
References: <loom.20130106T102511-102@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

TM <tmjuju <at> yahoo.com> writes:

# btrfs fi df /mnt/dls
Data: total=712.01GB, used=711.24GB
System, DUP: total=8.00MB, used=80.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=998.53MB
Metadata: total=8.00MB, used=0.00

btrfs fi show
Label: 'tm_0'  uuid: f2866a33-fe53-4fc0-98bf-52d347b43824
        Total devices 1 FS bytes used 712.21GB
        devid    1 size 1.82TB used 714.04GB path /dev/sdb1

...

[root@microserver mnt]# btrfs balance start -dusage=5 /mnt/dls/
Done, had to relocate 0 out of 716 chunks
[root@microserver mnt]# btrfs balance start -dusage=10 /mnt/dls/
Done, had to relocate 0 out of 716 chunks
[root@microserver mnt]# btrfs balance start -dusage=15 /mnt/dls/
Done, had to relocate 0 out of 716 chunks
[root@microserver mnt]# btrfs balance start -dusage=25 /mnt/dls/
Done, had to relocate 0 out of 716 chunks
[root@microserver mnt]# btrfs balance start -dusage=35 /mnt/dls/
Done, had to relocate 1 out of 716 chunks

...
Meanwhile situation got worst
..


[root@microserver ~]# btrfs fi df /mnt/dls/
Data: total=713.01GB, used=712.23GB
System, DUP: total=8.00MB, used=80.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=999.31MB
Metadata: total=8.00MB, used=0.00


and I kept getting more messages
dmesg |grep "block rsv returned -28" |wc -l
60

(I had stared with only 9 messages just a few hours ago)

So I decided to remove files
I started to remove (rm -rfv) thousands of files and directories
At first the rate was about 1 filedelete per second... 
Always monitoring usage while deleteing
Utilll I got down to: 

# btrfs fi df /mnt/dls/
Data: total=712.01GB, used=638.04GB
System, DUP: total=8.00MB, used=80.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=895.24MB
Metadata: total=8.00MB, used=0.00

And then the filesystem became responsive again
Back to 100MBps range from ~1MBps

