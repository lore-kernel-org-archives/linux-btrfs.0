Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57028 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3CZLh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 07:37:57 -0400
Received: by mail-ea0-f175.google.com with SMTP id r16so138197ead.34
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 04:37:55 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Kernel BUG on corrupted space cache under 3.7 and 3.8
Date: Tue, 26 Mar 2013 12:37:35 +0100
Message-ID: <1420920.Yent3fKO0t@linux-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

Yesterday I was about to restart my computer and that's why I closed every 
opened applications: three Eclipse instances, two other Java applications, 2 
web browsers etc. It involved a lot of IO operations and before everything 
could settle down my system became unresponsive.

I mean X & co. worked fine, but anything related to IO (opening a new screen, a 
new application etc.) hung. My process explorer showed that nearly all of the 
applications which were shutting down have very high IO, but in fact there 
were no HDD head movement at all. I did a hard reset.

Today morning when I restarted Linux I got a kernel BUG from btrfs. I 
successfully started a recovery Linux (with kernel 3.7) and when I tried to 
mount this partition, the bug/panic appeared again. After I could rebuild the 
space cache with clear_cache option and my system was fixed.

Since all this logs are written only onto screen, I made some photographs :), 
and I uploaded them.

System parameters:
- openSUSE 12.3, Kernel 3.8, x86_64
- Linux linux-suse 3.8.0-5-desktop #1 SMP PREEMPT Tue Feb 26 20:55:05 UTC 2013 
(db497a6) x86_64 x86_64 x86_64 GNU/Linux
- Photos are made on Kernel 3.7
- Default mount options: compress=lzo,space_cache
- On 3.7, the problematic line: fs/btrfs/free-space-cache.c:1553
- Photos location: www.morrohun.hu/temp/btrfs/[123].jpeg

If you need any other information, ask me :).

Best regards,

Ákos Szőts
