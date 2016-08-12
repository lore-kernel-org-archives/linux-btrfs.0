Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35176 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbcHLRhF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 13:37:05 -0400
Received: by mail-qt0-f194.google.com with SMTP id q11so1206160qtb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Aug 2016 10:37:05 -0700 (PDT)
Received: from ronan.ete.inpe.br ([150.163.62.206])
        by smtp.gmail.com with ESMTPSA id v24sm3718901qkv.3.2016.08.12.10.37.02
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Aug 2016 10:37:03 -0700 (PDT)
Message-ID: <1471023419.16857.9.camel@gmail.com>
Subject: BTRFS constantly reports "No space left on device" even with a huge
 unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: linux-btrfs@vger.kernel.org
Date: Fri, 12 Aug 2016 14:36:59 -0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I'm facing a daily problem with BTRFS. Almost everyday, I get the
message "No space left on device". Sometimes I can recover by balancing
the system but sometimes even balancing does not work due to the lack
of space. In this case, only a hard reset works if I can't delete some
files. The problem is that I have a huge unallocated space as you can
see here:

# btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		 119.07GiB
    Device unallocated:		   1.14TiB
    Device missing:		     0.00B
    Used:			 115.08GiB
    Free (estimated):		   1.14TiB	(min: 586.21GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:113.01GiB, Used:111.19GiB
   /dev/sda6	 113.01GiB

Metadata,DUP: Size:3.00GiB, Used:1.94GiB
   /dev/sda6	   6.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.14TiB

It is not easy to trigger the problem. But I do find some correlation
between two things:

1) When I started to create jails to build openSUSE packages locally,
then the problem happens more often. In these jails, some directories
like /dev/, /dev/pts, /proc, are mounted inside the jail.

2) When I open my KVM, I also see this problem more often. Notice,
however, that the KVM disk is stored in another EXT4 partition.

I would be glad if anyone can help me to fix it. In the following, I'm
providing more information about my system:

# uname -a
Linux ronanarraes-osd 4.7.0-1-default #1 SMP PREEMPT Mon Jul 25
08:42:47 UTC 2016 (89a2ada) x86_64 x86_64 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.6.1+20160714

# btrfs fi show
Label: none  uuid: 80381f7f-8cef-4bd8-bdbc-3487253ee566
	Total devices 1 FS bytes used 113.13GiB
	devid    1 size 1.26TiB used 119.07GiB path /dev/sda6

# btrfs fi df /
Data, single: total=113.01GiB, used=111.19GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=3.00GiB, used=1.94GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Regards,
Ronan Arraes
