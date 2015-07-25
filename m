Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from us2.outbound.mailhostbox.com ([208.91.199.209]:52589 "EHLO
	us2.outbound.mailhostbox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbbGYJBj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jul 2015 05:01:39 -0400
Received: from mail-oi0-f46.google.com (mail-oi0-f46.google.com [209.85.218.46])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: kernel@rp2.org)
	by us2.outbound.mailhostbox.com (Postfix) with ESMTPSA id ED253780C6B
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2015 08:56:24 +0000 (GMT)
Received: by oihq81 with SMTP id q81so30680364oih.2
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jul 2015 01:56:24 -0700 (PDT)
MIME-Version: 1.0
From: Mojtaba <kernel@rp2.org>
Date: Sat, 25 Jul 2015 13:26:04 +0430
Message-ID: <CAHTNZTcZiXYg5AqsgsdOpigUva_5EcGmCKCu8tqcbSsjYDxpTQ@mail.gmail.com>
Subject: Inappropriate ioctl for device
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello
I have had some problems with btrfs for some time and it seems no one
else had such problems as I couldn't find anything on the web. All I
could find was either upgrade your kernel or btrfs is experimental so
it's your problem!
The problem is sometimes on some of my servers I get the free space
problem(DF shows free space but I can't create/update and sometimes
delete files)
So as the wiki suggest I try to issue a balance command to get the
Inappropriate ioctl for device
On some of my servers I can successfully use the command one however
after that I get the same error
System is debian wheezy or Jessie.
This is Debian Jessie:

root@s2:/# uname -a
Linux s2 3.2.0-4-amd64 #1 SMP Debian 3.2.60-1+deb7u3 x86_64 GNU/Linux
root@s2:/#   btrfs --version
Btrfs v3.17
root@s2:/#   btrfs fi show
ERROR: unable get label Inappropriate ioctl for device
Label: none  uuid: 257c0845-1d12-4749-b813-4c69b38fb9fc
        Total devices 1 FS bytes used 3.16TiB
        devid    1 size 3.62TiB used 3.17TiB path /dev/vda4

Btrfs v3.17

root@s2:/# btrfs fi df /home
Data, single: total=3.16TiB, used=3.15TiB
System, DUP: total=8.00MiB, used=356.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, DUP: total=4.62GiB, used=3.84GiB
root@s2:/#
Dmesg:
http://50.7.76.234/dmesg.log


I've successfully run balance on this system once a few days ago
however after that I'm getting Inappropriate ioctl


Thanks
