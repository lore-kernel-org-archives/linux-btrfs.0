Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63891 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaDRRHD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 13:07:03 -0400
Received: by mail-lb0-f177.google.com with SMTP id z11so1488637lbi.8
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Apr 2014 10:07:02 -0700 (PDT)
Received: from [192.168.1.2] (host-62-63-77-69.rev.as20985.net. [62.63.77.69])
        by mx.google.com with ESMTPSA id zf7sm28692232lab.7.2014.04.18.10.07.00
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 18 Apr 2014 10:07:01 -0700 (PDT)
Message-ID: <53515BB4.7070700@gmail.com>
Date: Fri, 18 Apr 2014 21:07:00 +0400
From: "Sergey E. Kolesnikov" <rockingdemon@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: SSD TRIM on balance
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings everyone.

I've recently rebalanced my btrfs (kernel 3.13) running on two SSD 
drives (raid-0) and a question arose.
Does btrfs perform TRIM on SSD balance? Fs is mounted with 'ssd' option, 
but not 'discard'.

It seems fstrim only trims free chunks in allocated space, so we 
possibly having a "trim leak" if no special treatment is taken on blocks 
reallocated during balance operation.

root@midnight:/mnt/tmp# fstrim -v /
/: 0 bytes were trimmed


root@midnight:/mnt/tmp# btrfs fi df /
Data, RAID0: total=90.00GiB, used=86.84GiB
System, RAID1: total=32.00MiB, used=12.00KiB
Metadata, RAID1: total=4.00GiB, used=2.56GiB


root@midnight:/mnt/tmp# btrfs fi show /
Label: ssdbtrfs  uuid: f61f749b-dce6-4e73-9d53-693e93ad61aa
     Total devices 2 FS bytes used 89.41GiB
     devid    1 size 111.31GiB used 49.03GiB path /dev/sda2
     devid    2 size 111.31GiB used 49.03GiB path /dev/sdb2

Btrfs v3.12


Best regards,
Sergey E. Kolesnikov
