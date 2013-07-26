Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:65233 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3GZHFE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 03:05:04 -0400
Received: by mail-ob0-f172.google.com with SMTP id f8so3672284obp.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 00:05:03 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Jul 2013 09:05:03 +0200
Message-ID: <CANKzOHASE9pB6TjJ4JbqY1PE6cRsbCsY=KU3NVRjwcb74tikVQ@mail.gmail.com>
Subject: Adding 500G disk to btrfs volume... but I don't get 500G more of
 available space (raid0)
From: Axelle <aafortinet@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs folks,

I'm afraid I have a newbie question... but I can't sort it out? It's
just about adding a disk to a btrfs volume and not getting the correct
amount of GB in the end...

I have a btrfs volume which already consists of two different devices
and which is mounted on /samples. Its total size is 194G.

$ df -h
Filesystem Size Used Avail Use% Mounted on ... /dev/sdc1 194G 165G 20G
90% /samples

Now, I would like to add another 500G to that volume, from another device. I did

$ sudo mkfs.btrfs -m raid0 -d raid0 /dev/sdb
$ sudo btrfs device add /dev/sdb /samples
My filesystem now correctly reports:

$ sudo btrfs filesystem show
Label: none  uuid: 545e95c6-d347-4a8c-8a49-38b9f9cb9add
    Total devices 3 FS bytes used 161.98GB
    devid    3 size 465.76GB used 0.00 path /dev/sdb
    devid    2 size 93.13GB used 84.51GB path /dev/sdc1
    devid    1 size 100.61GB used 84.53GB path /dev/sdc6
But I miss some space when I do:

$ df -h
Filesystem      Size  Used Avail Use% Mounted on
...
/dev/sdc1       660G  165G   43G  80% /samples
I added 500G! Why haven't I got more available??

To debug, I ran this command:

$ sudo btrfs filesystem df /samples
Data, RAID0: total=162.00GB, used=159.79GB
Data: total=8.00MB, used=7.48MB
System, RAID1: total=8.00MB, used=24.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=3.50GB, used=2.19GB
Metadata: total=8.00MB, used=0.00
My data is in RAID0, that's ok. So where have my 500G gone, and how
can I fix this?

Thanks
