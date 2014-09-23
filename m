Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:35473 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaIWNvJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 09:51:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id D49C8123DE
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 15:51:06 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 29304-09 for <linux-btrfs@vger.kernel.org>;
 Tue, 23 Sep 2014 15:51:03 +0200 (CEST)
Received: from hiro.oops.intern (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id AFF56123D2
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 15:51:03 +0200 (CEST)
Message-ID: <54217AC7.4060108@xunil.at>
Date: Tue, 23 Sep 2014 15:51:03 +0200
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
> On 2014-09-23 09:06, Stefan G. Weichinger wrote:
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

ok, not needed here

> I don't know anything about the raid56 option, but there isn't any way
> to change it after mkfs.

not needed in my systems.

> skinyy-metadata can be changed online, and the format gets updated on
> rewrite of each metadata block.  This one does provide a performance
> improvement (stat() in particular runs noticeably faster).  You should
> probably enable this if it isn't already enabled, even if you don't
> recreate your filesystem.

So this is done via btrfstune, right?

I will give that a try, for my rootfs it doesn't allow me right now as
it is obviously mounted (live-cd, right?).

> no-holes cannot currently be changed online, and is a very recent
> addition (post v3.14 btrfs-progs I believe) that provides improved
> performance for sparse files (which is particularly useful if you are
> doing things with fixed size virtual machine disk images).

Yes, I have some of those!

> AFAIK there isn't really any 'version number' that has any meaning in
> the superblock (except for telling the kernel that it uses the stable
> disk layout), however, there are flag bits that you can look for
> (compat_flags, compat_ro_flags, and incompat_flags).  I'm not 100%
> certain what each bit means, but on my system with a only 1 month old
> BTRFS filesystem, with extref, skinny-metadata, and no-holes turned on,
> i have compat_flags: 0x0, compat_ro_flags: 0x0, and incompat_flags: 0x16b.
> 
> The other potentially significant thing is that the default
> nodesize/leafsize has changed recently from 4096 to 16384, as that gives
> somewhat better performance for most use cases.

I have the 16k for both already.

Thanks for your explanations, I will dig into it as soon as I find the
time. Seems I have to backup/restore quite some stuff ;-)

Stefan

