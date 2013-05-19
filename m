Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49129 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3ESKlF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 06:41:05 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org, sekharan@us.ibm.com, chris.mason@fusionio.com,
        Ilya Dryomov <idryomov@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [RFC 0/5] BTRFS hot relocation support
Date: Sun, 19 May 2013 12:41:01 +0200
Message-ID: <10727333.ycOo9UTNXM@merkaba>
In-Reply-To: <CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
References: <1367830418-26865-1-git-send-email-zwu.kernel@gmail.com> <CAEH94LgHqyFHhmdPE439hQQFGNCVyraDq0ta0XV1kCGnNDi0yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 9. Mai 2013, 07:13:56 schrieb Zhi Yong Wu:
> HI, all

Hi!

>    I saw that bcache will be merged into kernel upstream soon, so i
> want to know if btrfs hot relocation support is still meanful, if no,
> i will not continue to work on it. can anyone let me know this?
> thanks.

I really look forward to VFS hot data tracking with BTRFS (and other 
filesystem) support.

ZFS and BTRFS have shown that RAID support within the filesystem can make a lot 
of sense. I think hot relocation is another area which can be done more 
accurate within the filesystem. I think there are several features only 
possible by going this route:

1) Mark files as hot via ioctl. MySQL can mark InnoDB journal files for example.

2) Proper BTRFS RAID support (as noted elsewhere in this thread)

3) Easier setup. With BTRFS flexibility I would expect that a SSD as hot data 
cache can be added and removed on the fly during filesystem is mounted. Only 
seems supported at mkfs-time as I read the patch docs, but from my basic 
technical understanding of BTRFS it can be extented to be done on the fly with 
a mounted FS as well.


Block based caching can make sense for other use cases like raw device with 
Oracle DB on it or maybe a swap device. Or for filesystems not (yet) supporting 
VFS hot data tracking.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
