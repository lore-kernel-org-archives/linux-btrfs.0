Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaCVTYS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 15:24:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WRRWh-0004of-ED
	for linux-btrfs@vger.kernel.org; Sat, 22 Mar 2014 20:24:15 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 20:24:15 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 22 Mar 2014 20:24:15 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: free space inode generation (0) did not match free space cache
 generation
Date: Sat, 22 Mar 2014 19:23:48 +0000 (UTC)
Message-ID: <pan$ed109$9aee6786$583238bb$64d8ada4@cox.net>
References: <532DD2DC.3030408@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Friedel posted on Sat, 22 Mar 2014 19:13:48 +0100 as excerpted:

> I have a file-system on which I cannot write anymore (no space left on
> device, which is not true

> root@homeserver:~/btrfs/integration/devel# df -h
> Dateisystem    Größe Benutzt Verf. Verw% Eingehängt auf
> /dev/sdd2        30G     24G  5,1G   83% /mnt/test1

> root@homeserver:~/btrfs/integration/devel# ./btrfs fi show /mnt/test1
> Label: 'ROOT_BTRFS_RAID'  uuid: a2d5f2db-04ca-413a-aee1-cb754aa8fba5
>          Total devices 2 FS bytes used 11.84GiB
>          devid    1 size 14.85GiB used 14.67GiB path /dev/sde2
>          devid    2 size 14.65GiB used 14.65GiB path /dev/sdd2
> Btrfs this-will-become-v3.13-48-g57c3600

That's a FAQ and I just replied to a different thread with a detailed 
explanation and procedure for fixing.  See

http://permalink.gmane.org/gmane.comp.file-systems.btrfs/33643

It's linked there, but you'll also want to read up on the btrfs wiki, 
particularly the free-space and balance sections of the FAQ, along with 
the balance filters page.

https://btrfs.wiki.kernel.org

Bookmark it! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

