Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35701 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3CGRGG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 12:06:06 -0500
Received: by mail-ob0-f177.google.com with SMTP id eh20so536724obb.36
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 09:06:05 -0800 (PST)
MIME-Version: 1.0
From: Steve Heyns <notzippy@gmail.com>
Date: Thu, 7 Mar 2013 09:05:45 -0800
Message-ID: <CANDob0JBA8P1jVtB7zd=qfHVcBZMrC7pusNcSr3+OtKQv5=49g@mail.gmail.com>
Subject: Drive low space / huge performance hit.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi

I am using compression lzo on my 350GB partition, I have 2 subvolumes
on this partition. My kernel is 3.7 BTRFS v0.19 -

According to my system (df -h) that partition has 75Gb available.
According to btrfs

btrfs fi df /mnt/DevSystem/
Data: total=260.01GB, used=259.09GB
System, DUP: total=8.00MB, used=36.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=8.00GB, used=7.87GB
Metadata: total=8.00MB, used=0.00

du -cxsf shows
312GB used on one subvolume, 21GB used on the other subvolume (total of 333gb )

>From what I understand the metadata would be duplicated so that is
16G, and the data is 260G, that leaves about 80GB unallocated for, but
the drive is seeing a huge performance hit (drive is mounted with
autodefrag). I believe the issue is the fact that the partition is
getting close to be full but then what happened to the 80GB ?

Thanks
Nz
