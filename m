Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f68.google.com ([74.125.83.68]:37712 "EHLO
	mail-ee0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3JZT5V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 15:57:21 -0400
Received: by mail-ee0-f68.google.com with SMTP id b45so927358eek.11
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 12:57:20 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Oct 2013 21:46:01 +0200
Message-ID: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com>
Subject: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I just upgraded kernel to 3.11.6 added new disk and created btrfs:

# mkfs.btrfs /dev/sdb
# mount -t btrfs -o compress=lzo,compress-force=lzo /dev/sdb
/usr/local/mysql/data

I started copying files from old disk and then I got 'No space left on
device', but there is a lot of space.

# df -h
Filesystem                Size  Used Avail Use% Mounted on
/dev/sdb                  2.8T  110G  2.7T   4% /usr/local/mysql/data

# btrfs fi show
Label: none  uuid: c0bfcb22-8b7c-4936-afcd-7acdf58f1d6c
        Total devices 1 FS bytes used 108.68GB
        devid    1 size 2.73TB used 113.04GB path /dev/sdb

# btrfs fi df /usr/local/mysql/data
Data: total=111.01GB, used=108.25GB
System, DUP: total=8.00MB, used=20.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=441.91MB
Metadata: total=8.00MB, used=0.00

I tried balance from FAQ:

# btrfs fi balance start -dusage=5 /usr/local/mysql/data
Done, had to relocate 4 out of 117 chunks


But it doesn't help. When I try to copy file there is still 'No space
left on device'.

What to do ?


Regards,

Igor
