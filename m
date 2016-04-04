Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35621 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbcDDXgt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 19:36:49 -0400
Received: by mail-oi0-f50.google.com with SMTP id p188so187338949oih.2
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Apr 2016 16:36:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Apr 2016 09:36:48 +1000
Message-ID: <CA+WRLO-vu4B8X3Td12F0gueU70G6KwjRTD07MNwDrJfodAscNA@mail.gmail.com>
Subject: Scrub priority, am I using it wrong?
From: Gareth Pye <gareth@cerberos.id.au>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a btrfs file system set up on 6 drbd disks running on 2Tb
spinning disks. The server is moderately loaded with various regular
tasks that use a fair bit of disk IO, but I've scheduled my weekly
btrfs scrub for the best quiet time in the week.

The command that is run is:
/usr/local/bin/btrfs scrub start -Bd -c idle /data

Which is my best attempt to try and get it to have a low impact on
user operations

But iotop shows me:

1765 be/4 root       14.84 M/s    0.00 B/s  0.00 % 96.65 % btrfs scrub
start -Bd -c idle /data
 1767 be/4 root       14.70 M/s    0.00 B/s  0.00 % 95.35 % btrfs
scrub start -Bd -c idle /data
 1768 be/4 root       13.47 M/s    0.00 B/s  0.00 % 92.59 % btrfs
scrub start -Bd -c idle /data
 1764 be/4 root       12.61 M/s    0.00 B/s  0.00 % 88.77 % btrfs
scrub start -Bd -c idle /data
 1766 be/4 root       11.24 M/s    0.00 B/s  0.00 % 85.18 % btrfs
scrub start -Bd -c idle /data
 1763 be/4 root        7.79 M/s    0.00 B/s  0.00 % 63.30 % btrfs
scrub start -Bd -c idle /data
28858 be/4 root        0.00 B/s  810.50 B/s  0.00 % 61.32 % [kworker/u16:25]


Which doesn't look like an idle priority to me. And the system sure
feels like a system with a lot of heavy io going on. Is there
something I'm doing wrong?

System details:

# uname -a
Linux emile 4.4.3-040403-generic #201602251634 SMP Thu Feb 25 21:36:25
UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

# /usr/local/bin/btrfs --version
btrfs-progs v4.4.1

I'm waiting on the ppa version of 4.5.1 before upgrading, that is my
usual kernel update strategy.

# cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=14.04
DISTRIB_CODENAME=trusty
DISTRIB_DESCRIPTION="Ubuntu 14.04.4 LTS"

Any other details that people would like to see that are relevant to
this question?

-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
