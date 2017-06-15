Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:36146 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdFOJoh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 05:44:37 -0400
Received: by mail-wr0-f180.google.com with SMTP id 36so13816958wry.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 02:44:37 -0700 (PDT)
Received: from [192.168.0.24] ([78.194.205.2])
        by smtp.googlemail.com with ESMTPSA id x18sm1323108eda.39.2017.06.15.02.44.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Jun 2017 02:44:35 -0700 (PDT)
Reply-To: vianney@stroebel.fr
To: linux-btrfs@vger.kernel.org
From: Vianney Stroebel <vianney@stroebel.fr>
Subject: Disk usage is more than double the snapshots exclusive data
Message-ID: <53ff5efd-74de-2ea5-fd1a-12ca35c550f3@stroebel.fr>
Date: Thu, 15 Jun 2017 11:44:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On a backup drive for a home computer, disk usage as shown by 'btrfs fi show' 
is more than double the snapshots exclusive data as shown by "btrfs qgroup 
show" (574 GB vs 265 GB).

I've done a lot of research online and I couldn't find any answer to this problem.

Output of some commands:

uname -a
Linux viybel-pc 4.10.0-22-generic #24-Ubuntu SMP Mon May 22 17:43:20 UTC 2017 
x86_64 x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.9.1

sudo btrfs fi show
Label: 'btrfs-backup'  uuid: 35905dc5-1400-4687-8be7-cf87d6ad0980
	Total devices 1 FS bytes used 573.89GiB
	devid    1 size 698.64GiB used 697.04GiB path /dev/sdb1

btrfs fi df /mnt/btrfs-backup
Data, single: total=670.01GiB, used=564.26GiB
System, DUP: total=8.00MiB, used=112.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=13.50GiB, used=8.64GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=14.95MiB

 From https://github.com/agronick/btrfs-size (i.e. more readable "btrfs qgroup 
show")

btrfs-size /mnt/btrfs-backup
==================================================================================================================================
Snapshot / Subvolume                                               ID   Total 
   Exclusive Data
==================================================================================================================================
10726 gen 216807 top level 5 path full/2016-06-19_12-32-01         10726 
208.68GB 208.68GB
21512 gen 216853 top level 5 path full/2016-12-14_16-21-34         21512 
166.98GB 40.36GB
23054 gen 216853 top level 5 path full/2017-03-03_08-47-00         23054 
154.79GB 7.53GB
25451 gen 216856 top level 5 path full/2017-04-14_21-54-25         25451 
123.48GB 3.07GB
26514 gen 216862 top level 5 path full/2017-05-02_14-58-09         26514 
123.70GB 5.03GB
28499 gen 218095 top level 5 path full/2017-06-11_19-29-16         28499 
154.65GB 169.78MB
28556 gen 218094 top level 5 path full/2017-06-13_03-15-00         28556 
154.88GB 403.89MB
==================================================================================================================================
                                                                 Exclusive 
Total: 265.23GB

Feel free to ask me any question.

Vianney


