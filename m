Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36181 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752609AbeDPBER (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Apr 2018 21:04:17 -0400
Received: by mail-oi0-f49.google.com with SMTP id h11-v6so3707549oic.3
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Apr 2018 18:04:17 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 15 Apr 2018 19:04:15 -0600
Message-ID: <CAJCQCtQ3r16BYYtrx9rVYauh7JeAp9omWidS4zzwxqvhU1bh+g@mail.gmail.com>
Subject: Add udev-md-raid-safe-timeouts.rules
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-lvm@redhat.com,
        Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just ran into this:
https://github.com/neilbrown/mdadm/pull/32/commits/af1ddca7d5311dfc9ed60a5eb6497db1296f1bec

This solution is inadequate, can it be made more generic? This isn't
an md specific problem, it affects Btrfs and LVM as well. And in fact
raid0, and even none raid setups.

There is no good reason to prevent deep recovery, which is what
happens with the default command timer of 30 seconds, with this class
of drive. Basically that value is going to cause data loss for the
single device and also raid0 case, where the reset happens before deep
recovery has a chance. And even if deep recovery fails to return user
data, what we need to see is the proper error message: read error UNC,
rather than a link reset message which just obfuscates the problem.


-- 
Chris Murphy
