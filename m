Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f48.google.com ([209.85.160.48]:46734 "EHLO
        mail-pl0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751096AbeCIQDC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Mar 2018 11:03:02 -0500
Received: by mail-pl0-f48.google.com with SMTP id y8-v6so5435695pll.13
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Mar 2018 08:03:02 -0800 (PST)
MIME-Version: 1.0
From: Paul Richards <paul.richards@gmail.com>
Date: Fri, 9 Mar 2018 16:02:59 +0000
Message-ID: <CAMoswehA9P+JEoLmrMcWDys8t_pgNQxjvSGsk5XHhshFo+=e-Q@mail.gmail.com>
Subject: How to replace a failed drive in btrfs RAID 1 filesystem
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there,

I have a 3 disk btrfs RAID 1 filesystem, with a single failed drive.
Before I attempt any recovery I’d like to ask what is the recommended
approach?  (The wiki docs suggest consulting here before attempting
recovery[1].)

The system is powered down currently and a replacement drive is being
delivered soon.

Should I use “replace”, or “add” and “delete”?

Once replaced should I rebalance and/or scrub?

I believe that the recovery may involve mounting in degraded mode.  If
I do this, how do I later get out of degraded mode, or if it’s
automatic how do i determine when I’m out of degraded mode?


The system is running Ubuntu 16.04 LTS with kernel 4.4.0.



1: “it may be helpful to consult the mailing list of irc channel
before attempting recovery”. -
https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Replacing_failed_devices
