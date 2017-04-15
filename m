Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34505 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbdDOSR1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 14:17:27 -0400
Received: by mail-yw0-f169.google.com with SMTP id k13so44514141ywk.1
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Apr 2017 11:17:27 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <chris@colorremedies.com>
Date: Sat, 15 Apr 2017 12:17:25 -0600
Message-ID: <CAJCQCtTU6M1c-B1thYtTBidyEpM9AWPMSPU=NGxj3QHnqTM7+A@mail.gmail.com>
Subject: remount and conflicting ssd options?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I don't understand this:

/dev/mmcblk0p3 on / type btrfs
(rw,noatime,seclabel,compress=zlib,nossd,ssd_spread,space_cache,commit=150,subvolid=260,subvol=/root)


The fstab uses ssd_spread. It looks like during startup the initial
option is ssd via autodetection and then at switchroot time, when it
goes ro to rw, the fstab options are applied and it becomes
ssd_spread. Fine.

Then later I tried

mount -o remount,ssd

To go back to regular ssd option, but nothing happens, mount still
shows ssd_spread. And then if I do

mount -o remount,nossd

I get the above mount output with nossd,ssd_spread options which would
seem to be a contradiction. At least it's confusing. So... now what?

kernel 4.10.8-200.fc25.x86_64

-- 
Chris Murphy
