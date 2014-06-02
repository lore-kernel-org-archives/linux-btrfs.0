Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns2.affinityvision.com.au ([220.233.38.77]:48602 "EHLO
	mail.affinityvision.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbaFBERR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Jun 2014 00:17:17 -0400
Message-ID: <538BF5A0.7050805@affinityvision.com.au>
Date: Mon, 02 Jun 2014 13:55:12 +1000
From: Andrew McGlashan <andrew.mcglashan@affinityvision.com.au>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>,
        =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
CC: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5384D53C.9070509@skagestad.org> <5384E2FA.1070509@fb.com> <5384F0B4.7040309@skagestad.org> <5384F8A4.1050206@skagestad.org> <5384FAB2.6000204@fb.com> <5385007A.4000301@fb.com> <538579F1.10106@skagestad.org> <5385E794.1030002@fb.com> <5385F938.9010009@skagestad.org> <20140601212926.GH22161@merlins.org>
In-Reply-To: <20140601212926.GH22161@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: 3.15-rc6 - btrfs-transacti:4157 blocked for more than 120 seconds.
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm getting "blocked for more than 120 seconds" messages too.

In my case, it is for a simple RAID1 volume that is rebuilding for the
first time (new volume), whilst mounted as a LUKS crypt volume and
writing /dev/zero before actual deployment.


I am running a stock Wheezy kernel:

~ # uname -a
Linux n4800eco-a 3.2.0-4-amd64 #1 SMP Debian 3.2.57-3 x86_64 GNU/Linux


As I am deliberately NOT running btrfs, the common link may be mdadm or
LUKS.


I'm also noticing btrfs modules being loaded on another box, even though
I am not at all ready to trust btrfs for any file system at this time.

There may be some bug with mdadm/crypt(LUKS)/btrfs -- or it may have
nothing to do with btrfs.  My problem almost certainly isn't btrfs
unless there is some kernel code giving me grief without loading the
btrfs module.


More details of my problem:

 https://lists.debian.org/debian-user/2014/06/msg00070.html

NB: working through my problem in a dropbear busybox environment that
hasn't loaded btrfs module.  The kernel is the same as the /normal/
system, compliments of mkinitramfs tool....


Cheers
A.

