Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52964 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2IAGpG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Sep 2012 02:45:06 -0400
Received: by iahk25 with SMTP id k25so2283683iah.19
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Aug 2012 23:45:06 -0700 (PDT)
MIME-Version: 1.0
From: Shentino <shentino@gmail.com>
Date: Fri, 31 Aug 2012 23:44:25 -0700
Message-ID: <CAGDaZ_oFzakgBC+NzK4X3J9yL0Q5YfZVKk671QKN0xHAMgPN7g@mail.gmail.com>
Subject: rfc: fuzz testing by direct writes to device
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How effective would it be to directly write to the underlying device
and then running tests to see if the corruption is properly detected?

I just ran a fuzz test by syncing, and then manually corrupting a file
with the help of a surgical sed (yes, the before and after patterns
had fixed equal lengths).  First I got an I/O error (expected), then I
ran scrub and got more problems (not ok), the system froze (not good),
a reboot failed to mount the system again (worse), and then the fsck
program dumped core.
