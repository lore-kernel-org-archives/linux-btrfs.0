Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:48876 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaHTJ3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 05:29:22 -0400
Received: from mailext.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id B04983519A5
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Aug 2014 11:23:26 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Questions on using BtrFS for fileserver
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 20 Aug 2014 11:23:26 +0200
From: Tomasz Chmielewski <tch@virtall.com>
Message-ID: <0f416a00a2dabac75caa768581a5e965@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> we are thinking about using BtrFS on standard hardware for a
>> fileserver with about 50T (100T raw) of storage (25Ã—4TByte).
>> 
> 
> I would recommend carefully reading this thread titled: "1 week to
> rebuid 4x 3TB raid10 is a long time!"

So I have a 2 x 2.6 TB devices in btrfs RAID-1, 716G used. Linux 3.16.

One of the disks failed.

"btrfs device delete missing /home" is taking 9 days so far, on an idle 
system:

root      4828  0.3  0.0  17844   260 pts/1    D+   Aug11  38:18 btrfs 
device delete missing /home

There is some kind of btrfs debug info printed in dmesg which seems to 
tell me that the operation is working, like:

[744657.598810] BTRFS info (device sda4): relocating block group 
908951814144 flags 17
[744672.021612] BTRFS info (device sda4): found 4784 extents
[744688.604997] BTRFS info (device sda4): found 4784 extents
[744689.133397] BTRFS info (device sda4): relocating block group 
910025555968 flags 17
[744701.162678] BTRFS info (device sda4): found 4196 extents
[744725.000459] BTRFS info (device sda4): found 4196 extents


but other than that, the recovery time doesn't look optimistic to me, 
there is no ability to check the progress etc.


-- 
Tomasz Chmielewski
http://www.sslrack.com

