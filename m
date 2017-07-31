Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:59006 "EHLO
        postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdGaLFk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 07:05:40 -0400
Received: from [131.220.3.232] (hocheck.informatik.uni-bonn.de [131.220.3.232])
        by postfix.iai.uni-bonn.de (Postfix) with ESMTP id 823AD5C469
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 12:51:43 +0200 (MEST)
        (envelope-from ochmann@cs.uni-bonn.de)
        (envelope-to linux-btrfs@vger.kernel.org) (1)
        (internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Subject: btrfs-freespace ever doing anything?
Message-ID: <bf03be69-e9c4-f0c3-6853-936647630d05@cs.uni-bonn.de>
Date: Mon, 31 Jul 2017 12:51:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have a quite simple and possibly stupid question. Since I'm 
occasionally seeing warnings about failed loading of free space cache, I 
wanted to clear and rebuild space cache. So I mounted the filesystem(s) 
with -o clear_cache and subsequently with my regular options which 
includes space_cache. Indeed, dmesg tells me:

[   60.285190] BTRFS info (device dm-1): force clearing of disk cache

and then

[  137.151845] BTRFS info (device dm-1): use ssd allocation scheme
[  137.151850] BTRFS info (device dm-1): disk space caching is enabled
[  137.151852] BTRFS info (device dm-1): has skinny extents

To my understanding, btrfs-freespace should then start working to 
rebuild the free space cache. However, I can't remember that I have ever 
seen btrfs work hard after clearing the space cache. The drives aren't 
working much, and the btrfs-freespace processes (which are indeed there) 
don't do anything either.

So simple question: Can anyone try to clear their space cache and 
confirm that btrfs actually does something after doing so? Is there 
anything I could do to confirm that something is happening?

The drives in question are a SSD and a HDD, both in the range of 1-2 TB 
in size.

I'm on Arch Linux, kernel 4.12.3, btrfs-progs 4.11.1

Best regards
Sebastian
