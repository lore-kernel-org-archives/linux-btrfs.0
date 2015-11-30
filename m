Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24417 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbbK3Eyp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 23:54:45 -0500
Subject: Re: [PATCH 0/7] Let user specify the kernel version for features
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com> <5656EA7F.1070500@oracle.com>
 <5656FBB7.5020802@gmx.com> <565784DE.5080401@oracle.com>
 <5657A757.90909@cn.fujitsu.com> <56581742.9030308@oracle.com>
 <565A5317.8040506@gmx.com>
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <565BD67B.9090007@oracle.com>
Date: Mon, 30 Nov 2015 12:54:19 +0800
MIME-Version: 1.0
In-Reply-To: <565A5317.8040506@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  (Most of the technical reasoning were already discussed so I won't
  repeat them here).

  And jolting for new technical reasons finds only these..

> What if the fs is not only for kernel to mount, but also a boot
> partition for grub?
> Do you need to check the grub2 version? Check if this is a /boot partition?


  In the above context, which is better..
  this :

    mkfs.btrfs -O ^skinny-metadata,^mixed-bg,^extref,^raid56,^no-holes
    btrfs-convert -O ^skinny-metadata,^extref,^no-holes

  or this:

    mkfs.btrfs -O comp=<X>
    btrfs-convert -O comp=<X>

    X = some number below 2.7.37 OR grub2 (planned) (thanks to you,
    to bring this up).

  ?

> Recently I just encountered such problem. Latest xfs-progs makes xfs
> version 5 by default, but grub2 can't handle version 5 yet in latest
> stable version.
> Then system can't even boot into grub2.

   Good example. Appears that user didn't know what latest features
   to disable? so to be compatible with grub2 ? OR they have to read
   couple of grub documents to fix.

   Imagine the pain while using btrfs-convert. That means you need to
   restore Hope you have not deleted the ext_saved subvol. And then
   again run btrfs-convert.


> Did you see Dave trying to add such grub2 version based probe to change
> mkfs.xfs features?
> No, just because that's not the way things should be done.

   So what was fix in this case ? Or is there any fix-patch rejected ?

Cheers, Anand
