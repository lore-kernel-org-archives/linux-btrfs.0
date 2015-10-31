Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59436 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbJaLLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 07:11:09 -0400
Received: from merkaba.localnet (ppp-62-216-209-156.dynamic.mnet-online.de [62.216.209.156])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 70412202
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 12:11:08 +0100 (CET)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: behavior of BTRFS in relation to inodes when moving/copying files between filesystems
Date: Sat, 31 Oct 2015 12:11:07 +0100
Message-ID: <1965511.ndjfqEXTD8@merkaba>
In-Reply-To: <11290984.HMVNobY9No@merkaba>
References: <11290984.HMVNobY9No@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 13. Oktober 2015, 12:39:12 CET schrieben Sie:
> Hi!
> 
> With BTRFS to XFS/Ext4 the inode number of the target file stays the same in 
> with both cp and mv case (/mnt/zeit is a freshly created XFS in this example):
> 
> merkaba:~> ls -li foo /mnt/zeit/moo
> 6609270  foo
>      99  /mnt/zeit/moo
> merkaba:~> cp foo /mnt/zeit/moo
> merkaba:~> ls -li foo /mnt/zeit/moo
> 6609270 8 foo
>      99  /mnt/zeit/moo
> merkaba:~> cp -p foo /mnt/zeit/moo  
> merkaba:~> ls -li foo /mnt/zeit/moo
> 6609270 foo
>      99 /mnt/zeit/moo
> merkaba:~> mv foo /mnt/zeit/moo
> merkaba:~> ls -lid /mnt/zeit/moo
> 99 -rw-r--r-- 1 root root 6 Okt 13 12:28 /mnt/zeit/moo
> 
> 
> With BTRFS as target filesystem however in the mv case I get a new inode:
> 
> merkaba:~> ls -li foo /home/moo
>  6609289 -rw-r--r-- 1 root root 6 Okt 13 12:34 foo
> 16476276 -rw-r--r-- 1 root root 6 Okt 13 12:34 /home/moo
> merkaba:~> cp foo /home/moo
> merkaba:~> ls -li foo /home/moo
>  6609289 -rw-r--r-- 1 root root 6 Okt 13 12:34 foo
> 16476276 -rw-r--r-- 1 root root 6 Okt 13 12:34 /home/moo
> merkaba:~> cp -p foo /home/moo 
> merkaba:~> ls -li foo /home/moo
>  6609289 -rw-r--r-- 1 root root 6 Okt 13 12:34 foo
> 16476276 -rw-r--r-- 1 root root 6 Okt 13 12:34 /home/moo
> merkaba:~> mv foo /home/moo
> merkaba:~> ls -li /home/moo 
> 16476280 -rw-r--r-- 1 root root 6 Okt 13 12:34 /home/moo
> 
> 
> Is this intentional and/or somehow related to the copy on write specifics of 
> the filesystem?
> 
> I think even with COW it can just overwrite the existing file instead of 
> removing the old one and creating a new one – but it wouldn´t give much of a 
> benefit unless the target file is nocow.
> 
> (Also I thought only certain other utilities had supercow powers, but well 
> BTRFS seems to have them as well :)

Anyone any idea?

Thanks,
-- 
Martin
