Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:38776 "EHLO
	homiemail-a78.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752464Ab3GRC70 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 22:59:26 -0400
From: Shridhar Daithankar <ghodechhap@ghodechhap.net>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: What is the current status of defragmentation?
Date: Thu, 18 Jul 2013 08:29:22 +0530
Message-ID: <62476934.S7K7xSYr36@bheem>
In-Reply-To: <51E7182F.9020009@statystyka.net>
References: <51E7182F.9020009@statystyka.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, July 18, 2013 12:18:23 AM you wrote:
> * Is the defragmentation of the whole filesystem supported at all? I
> can't find a single reference that it is, and a syntax of btrfs-progs
> suggest that it isn't. If supported, under what conditions? Like what %
> of free space should be available?

It works for me, I have done it few times on 3.9.9/arch. But I have kept 
plenty of free space handy to avoid any corner cases.

> * How to check the level of defragmentation, and what are the reasonable
> threshold values, that should indicate the desktop filesystem needs
> defragmenting? I know, that everyone's millage my vary; I just want to
> know some values as a point-of-reference.

Thats a hard question to answer but after you fully defrag the system(every 
btrfs mount/partition/filesystem), rebooting immediately with 
compress/autodefrag should do it automatically, since then.

Are you mounting with noatime? storing access time could lead to massive 
direcory level fragmentation which is hard to measure.

filefrag can help you but its per file and does not exactly give the level of 
fragmentation.
> 
> * What is the recommended command, that would efficiently defragment the
> whole file system, preferably with some sort of progress indication?
> Does this command
> 
> find / -type f -o -type d -print0 | xargs --null --no-run-if-empty btrfs
> filesystem defragment -cv
> 
> look like a reasonable idiom for defragmenting the whole filesystem?

again, I use this. no progress indicator but it works

----------
for dir in / /home ;
do

find $dir -mount -type d -exec btrfs fi defrag '{}' \; ;
find $dir -mount -type f -exec btrfs fi defrag '{}' \; ;

done
----------

HTH


-- 
Regards
 Shridhar
