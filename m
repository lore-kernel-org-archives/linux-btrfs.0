Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:37889 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbcGXCDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jul 2016 22:03:13 -0400
Received: from homiemail-a22.g.dreamhost.com (sub3.mail.dreamhost.com [69.163.253.7])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 3F69AA9FD2
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 19:03:12 -0700 (PDT)
Received: from homiemail-a22.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a22.g.dreamhost.com (Postfix) with ESMTP id 84E90114066
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 19:03:11 -0700 (PDT)
Received: from [192.168.0.96] (31-178-200-210.dynamic.chello.pl [31.178.200.210])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: liori@exroot.org)
	by homiemail-a22.g.dreamhost.com (Postfix) with ESMTPSA id 1C491114065
	for <linux-btrfs@vger.kernel.org>; Sat, 23 Jul 2016 19:03:10 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Tomasz Melcer <liori@exroot.org>
Subject: Force recalculation of a data block checksum
Message-ID: <72704872-fb0b-a951-2b7e-55236071094f@exroot.org>
Date: Sun, 24 Jul 2016 04:03:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've got a USB-connected HDD with a btrfs partition. The partition 
contains a 1TB file, a disk image. The first `btrfs scrub` after writing 
that file found 3 logical bad blocks that developed somewhere in the 
middle of that file (logs below).

The full area of the btrfs partition can be read without I/O error, so I 
think there are two possible cases: either the data block was written 
incorrectly or an incorrect checksum is stored. The first case is 
obviously unrecoverable, but if it's the second case, fixing the problem 
should be as simple as recomputing the checksum for what is already stored.

How can I ask btrfs to recompute the checksum of a data block as it is 
stored on the drive? I don't see any command doing an operation like 
that, and I couldn't find anything on the topic on the internet.

Thanks,


Logs:

#v+
[ 7702.964265] BTRFS warning (device sdd1): checksum error at logical
5473719291904 on dev /dev/sdd1, sector 222940168, root 5, inode 1245769,
offset 97110921216, length 4096, links 1 (path: dysk/dysk.bin)
[ 7702.964274] BTRFS error (device sdd1): bdev /dev/sdd1 errs: wr 0,
rd 0, flush 0, corrupt 17, gen 0
[ 7702.964278] BTRFS error (device sdd1): unable to fixup (regular) 
error at logical 5473719291904 on dev /dev/sdd1
[…]
[ 9588.625906] BTRFS warning (device sdd1): checksum error at logical
5241172611072 on dev /dev/sdd1, sector 691494312, root 5, inode 1245769,
offset 310632271872, length 4096, links 1 (path: dysk/dysk.bin)
[ 9588.625916] BTRFS error (device sdd1): bdev /dev/sdd1 errs: wr 0,
rd 0, flush 0, corrupt 18, gen 0
[ 9588.625920] BTRFS error (device sdd1): unable to fixup (regular) 
error at logical 5241172611072 on dev /dev/sdd1
[…]
[20545.302898] BTRFS warning (device sdd1): checksum error at logical
3991747321856 on dev /dev/sdd1, sector 3185809200, root 5, inode 
1245769, offset 907925676032, length 4096, links 1 (path: dysk/dysk.bin)
[20545.302908] BTRFS error (device sdd1): bdev /dev/sdd1 errs: wr 0,
rd 0, flush 0, corrupt 19, gen 0
[20545.302912] BTRFS error (device sdd1): unable to fixup (regular) 
error at logical 3991747321856 on dev /dev/sdd1
#v-


-- 
Tomasz Melcer
