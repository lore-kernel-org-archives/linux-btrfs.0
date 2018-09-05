Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f180.google.com ([209.85.208.180]:35481 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbeIEGWt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2018 02:22:49 -0400
Received: by mail-lj1-f180.google.com with SMTP id p10-v6so4838567ljg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 18:55:01 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 4 Sep 2018 19:55:00 -0600
Message-ID: <CAJCQCtTH-z5u9d6AmommSgC+bESp+Ze4WHMwKueiD+OYpphcqg@mail.gmail.com>
Subject: nbdkit as a flexible alternative to loopback mounts
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://rwmj.wordpress.com/2018/09/04/nbdkit-as-a-flexible-alternative-to-loopback-mounts/

This is a pretty cool writeup. I can vouch Btrfs will format mount,
write to, scrub, and btrfs check works on an 8EiB (virtual) disk.

The one thing I thought might cause a problem is the ndb device has a
1KiB sector size, but Btrfs (on x86_64) still uses 4096 byte "sector"
and it all seems to work fine despite that.

Anyway, maybe it's useful for some fstests instead of file backed
losetup devices?


-- 
Chris Murphy
