Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:53685 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaIYHPT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Sep 2014 03:15:19 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id 1596B123C9
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 09:15:17 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 07103-03 for <linux-btrfs@vger.kernel.org>;
 Thu, 25 Sep 2014 09:15:14 +0200 (CEST)
Received: from goto.oops.intern (unknown [IPv6:2001:15c0:65ff:8742:39e4:6d8d:b8e0:3beb])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id 9BC6A123CE
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Sep 2014 09:15:14 +0200 (CEST)
Message-ID: <5423C101.8000201@xunil.at>
Date: Thu, 25 Sep 2014 09:15:13 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com> <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net> <54208BBC.1000700@xunil.at> <542162A8.2010700@gmail.com> <5421706F.6070301@xunil.at> <542177BF.2000808@gmail.com>
In-Reply-To: <542177BF.2000808@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 23.09.2014 um 15:38 schrieb Austin S Hemmelgarn:

>> What features for example?
> Well, running 'mkfs.btrfs -O list-all' with 3.16 btrfs-progs gives the
> following list of features:
> mixed-bg        - mixed data and metadata block groups
> extref            - increased hard-link limit per file to 65536
> raid56            - raid56 extended format
> skinny-metadata        - reduced size metadata extent refs
> no-holes        - no explicit hole extents for files
> 
> mixed-bg is something that you generally wouldn't want to change after
> mkfs.
> extref can be enabled online, and the filesystem metadata gets updated
> as-needed, and dosen't provide any real performance improvement (but is
> needed for some mail servers that have HUGE mail-queues)
> I don't know anything about the raid56 option, but there isn't any way
> to change it after mkfs.
> skinyy-metadata can be changed online, and the format gets updated on
> rewrite of each metadata block.  This one does provide a performance
> improvement (stat() in particular runs noticeably faster).  You should
> probably enable this if it isn't already enabled, even if you don't
> recreate your filesystem.
> no-holes cannot currently be changed online, and is a very recent
> addition (post v3.14 btrfs-progs I believe) that provides improved
> performance for sparse files (which is particularly useful if you are
> doing things with fixed size virtual machine disk images).

Recreating or at least "btrfstune -rx" for my rootfs would mean that I
have to boot from a live medium bringing recent btrfs-progs, right?

sysresccd brings btrfs-progs-3.14.2 ... that should be enough, ok?

aside from that, the rootfs on my thinkpad shows these features:

# ls /sys/fs/btrfs/bec7dff9-8749-4db4-9a1b-fa844cfcc36a/features/
big_metadata  compress_lzo  extended_iref  mixed_backref

So I only miss the skinny extents ... and "no-holes".

Stefan
