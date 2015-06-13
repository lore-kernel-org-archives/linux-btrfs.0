Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49286 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752405AbbFMJvv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jun 2015 05:51:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z3i6O-0006U3-MX
	for linux-btrfs@vger.kernel.org; Sat, 13 Jun 2015 11:51:48 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jun 2015 11:51:48 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jun 2015 11:51:48 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs filesystem show confused when label is same as mountpoint
Date: Sat, 13 Jun 2015 09:51:41 +0000 (UTC)
Message-ID: <pan$1585f$f9669c8c$f28f170$ac1741de@cox.net>
References: <557ADBAE.9040407@oracle.com> <1791793.W1h8pBaUgj@hoefnix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sjoerd posted on Sat, 13 Jun 2015 09:20:12 +0200 as excerpted:

> versus for label:
> btrfs fi show MULTIMEDIA
> Label: 'MULTIMEDIA'  uuid: ce5d23cd-73a4-4f7c-83cd-2c40d12f6697

Hmm... I wasn't even aware that you could /use/ label!  But sure enough, 
it works here, too:

btrfs fi show rt0238gcnx+35l0
Label: 'rt0238gcnx+35l0'  uuid: 8f8d79ef-a86f-4306-a255-e0519e0f6132
        Total devices 2 FS bytes used 1.94GiB
        devid    1 size 8.00GiB used 3.78GiB path /dev/sda5
        devid    2 size 8.00GiB used 3.78GiB path /dev/sdb5

btrfs-progs v4.0.1


It works for UUID as well...

btrfs fi show 8f8d79ef-a86f-4306-a255-e0519e0f6132
Label: 'rt0238gcnx+35l0'  uuid: 8f8d79ef-a86f-4306-a255-e0519e0f6132
        Total devices 2 FS bytes used 1.94GiB
        devid    1 size 8.00GiB used 3.78GiB path /dev/sda5
        devid    2 size 8.00GiB used 3.78GiB path /dev/sdb5

btrfs-progs v4.0.1

... but that's a lot of arbitrary typing.

Doesn't work with partlabel or id (see /dev/disk/by-*), however. =:^(

Anyway, thanks!  Learned something new about btrfs fi show, today! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

