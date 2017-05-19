Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsmx012.vodafonemail.xion.oxcs.net ([153.92.174.90]:36388 "EHLO
        vsmx012.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751155AbdESQci (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 12:32:38 -0400
Received: from vsmx004.vodafonemail.xion.oxcs.net (unknown [192.168.75.198])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTP id CCCD68CDD52
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 16:32:35 +0000 (UTC)
Received: from [192.168.0.1] (unknown [91.10.3.204])
        by mta-8-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 25DFDCDF8E
        for <linux-btrfs@vger.kernel.org>; Fri, 19 May 2017 16:32:33 +0000 (UTC)
From: Ochi <ochi@arcor.de>
Subject: Recurring free space warnings for same blocks
To: linux-btrfs@vger.kernel.org
Message-ID: <b6786249-1101-03fd-4ce0-30d41d2114a0@arcor.de>
Date: Fri, 19 May 2017 18:32:31 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

looking at the journals of three different machines running btrfs on 
crypt-devices on SSDs for root (dm-0 in the logs below) and other 
volumes, I'm seeing space cache warnings recurring for the same blocks 
over and over again. The machines are usually (re)booted once a day. See 
below for excerpts from the journals of the three machines. It is 
striking that these warnings seem to start somewhere around April/May. I 
thought maybe it is worth pointing out before I try something else like 
resetting the space cache manually. I've been using the 4.10.* series 
kernel on all machines for quite a while now (it's a routinely updated 
Arch Linux). Currently installed btrfs-progs are 4.10.2.

Mai 19 08:57:45 machine0 kernel: BTRFS warning (device dm-0): block 
group 6471811072 has wrong amount of free space
Mai 19 08:57:45 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 6471811072, rebuilding it now
Mai 18 10:00:26 machine0 kernel: BTRFS warning (device dm-0): block 
group 6471811072 has wrong amount of free space
Mai 18 10:00:26 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 6471811072, rebuilding it now
Mai 18 10:00:26 machine0 kernel: BTRFS warning (device dm-0): block 
group 105256058880 has wrong amount of free space
Mai 18 10:00:26 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 105256058880, rebuilding it now
Mai 17 14:57:00 machine0 kernel: BTRFS warning (device dm-0): block 
group 6471811072 has wrong amount of free space
Mai 17 14:57:00 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 6471811072, rebuilding it now
Mai 17 09:08:09 machine0 kernel: BTRFS warning (device dm-0): block 
group 6471811072 has wrong amount of free space
Mai 17 09:08:09 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 6471811072, rebuilding it now
Mai 16 11:41:42 machine0 kernel: BTRFS warning (device dm-0): block 
group 6471811072 has wrong amount of free space
Mai 16 11:41:42 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 6471811072, rebuilding it now
Mai 16 11:41:43 machine0 kernel: BTRFS warning (device dm-0): block 
group 105256058880 has wrong amount of free space
Mai 16 11:41:43 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 105256058880, rebuilding it now
Mai 03 16:46:48 machine0 kernel: BTRFS warning (device dm-0): block 
group 53179580416 has wrong amount of free space
Mai 03 16:46:48 machine0 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 53179580416, rebuilding it now

Apr 26 20:06:27 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Apr 26 20:06:27 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Apr 27 18:46:19 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Apr 27 18:46:19 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Apr 29 00:00:10 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Apr 29 00:00:10 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Apr 30 00:01:07 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Apr 30 00:01:07 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Mai 01 18:05:25 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Mai 01 18:05:25 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Mai 02 23:17:05 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Mai 02 23:17:05 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Mai 03 22:47:08 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Mai 03 22:47:08 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Mai 04 22:05:59 machine1 kernel: BTRFS warning (device dm-0): block 
group 31159484416 has wrong amount of free space
Mai 04 22:05:59 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 31159484416, rebuilding it now
Mai 17 17:53:39 machine1 kernel: BTRFS warning (device dm-0): block 
group 8610906112 has wrong amount of free space
Mai 17 17:53:39 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 8610906112, rebuilding it now
Mai 17 17:55:03 machine1 kernel: BTRFS warning (device dm-0): block 
group 8610906112 has wrong amount of free space
Mai 17 17:55:03 machine1 kernel: BTRFS warning (device dm-0): failed to 
load free space cache for block group 8610906112, rebuilding it now

Mai 15 07:15:56 machine2 kernel: BTRFS info (device dm-0): The free 
space cache file (99006545920) is invalid. skip it
Mai 18 00:00:05 machine2 kernel: BTRFS info (device dm-0): The free 
space cache file (99006545920) is invalid. skip it

Best regards
Sebastian
