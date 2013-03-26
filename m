Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f194.google.com ([209.85.223.194]:43764 "EHLO
	mail-ie0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934519Ab3CZOdr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 10:33:47 -0400
Received: by mail-ie0-f194.google.com with SMTP id qd14so2591433ieb.9
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 07:33:47 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Date: Tue, 26 Mar 2013 14:33:27 +0000
Message-ID: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com>
Subject: Kernel bug on mismatching generation_v2 in inode.c:835
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

In my previous thread at
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23333.html
there was a space_cache kernel bug/panic on kernel 3.8. I could
successfully "fix" that with rebuilding the cache. But some files were
missing/corrupted. So I booted a rescue CD with kernel 3.7 and ran
btrfsck --repair, which repaired quite a few things.

After a reboot I got the following message:
[  469.457386] btrfs: disk space caching is enabled
[  469.503612] btrfs: mismatching generation and generation_v2 found
in root item. This root was probably mounted with an older kernel.
Resetting all new fields.

As soon as anything had wanted to read a bit from the file system, the
hard drive went crazy and was working for 5-10 minutes. After I got a
kernel panic which said there's an error in fs/btrfs/inode.c:835.

In the moment I don't just mount, but want to read something from the
mounted file system under the rescue system, the same procedure
happens.

I made some pictures of it (since I cannot read anything from the
logs, if there are any).
You can find them here: www.morrohun.hu/temp/btrfs/v2/[123].jpg

I wanted to create an image with the aforementined btrfs-image tool,
but yet to have any success .

Could you please give me an advice what can I do now? Living on a
live-CD is not a life insurance :)

Best regards,

Ákos Szőts
