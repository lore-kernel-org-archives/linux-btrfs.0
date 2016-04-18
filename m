Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34276 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbcDRCBg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 22:01:36 -0400
Received: by mail-io0-f172.google.com with SMTP id 2so182730135ioy.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 19:01:36 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Apr 2016 20:01:35 -0600
Message-ID: <CAJCQCtSENroAomPKwpRe1aHRcgaRERek8VVpdtTN0EoETPQrdQ@mail.gmail.com>
Subject: WARN: volumes.c:2376 btrfs_init_new_device+0xcd8/0xed0 RIP: btrfs_show_devname+0x4b/0xd0
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=116601

Call traces attached to the bug.

The short version is that after (accidentally) adding a 256K 2nd
device to an existing Btrfs (seed) volume, there's a warning then an
oops and then the system becomes unstable and needs to be rebooted
soon thereafter.

kernel 4.5.0

-- 
Chris Murphy
