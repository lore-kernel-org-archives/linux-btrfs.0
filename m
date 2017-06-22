Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34280 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdFVCFN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 22:05:13 -0400
Received: by mail-wr0-f171.google.com with SMTP id 77so3442172wrb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 19:05:12 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 21 Jun 2017 20:05:10 -0600
Message-ID: <CAJCQCtQGmYtdNXhwhXCy7N=rBoNTuCCpew+f7ZSuWoG-Ofe1sg@mail.gmail.com>
Subject: commands hang 30-60s during scrubs, includes sysrq t
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm getting command hangs and service start failures during scrubs.
top says CPU idle is 58-64%.

Running 'perf top' takes more than 1 minute for results to appear.
Connecting to a web management service (cockpit) takes longer, maybe 2
minutes or sometimes the login times out. And just doing an ls -l on a
directory takes 30-45 seconds. I don't remember things being this bad
but I don't do scrubs all that often and then try to use the system at
the same time.

Anyway, it seems like scrub should not soak system resources enough to
cause any hangs or system service failures.

kernel-4.11.6-301.fc26.x86_64
btrfs-progs-4.11-1.fc27.x86_64

There are two Btrfs file systems: rootfs, and the one being scrubbed.
The file system being scrubbed is only being scrubbed, nothing is
reading or writing to it. Both file systems share the same physical
block device, a laptop hard drive.

rootfs
/dev/sda1 on / type btrfs
(rw,noatime,seclabel,compress=zlib,space_cache,subvolid=983,subvol=/root)

filesystem being scrubbed (is LUKS device)
/dev/mapper/most on /srv/most type btrfs
(rw,noatime,seclabel,space_cache,subvolid=659,subvol=/most)

elevator=deadline

Linked file "perf top" output while the scrub is happening.
https://drive.google.com/open?id=0B_2Asp8DGjJ9VzhPRklGUXdOQkE

Linked file "kernelmsgsysrqt.log" contains two sysrq t's.
https://drive.google.com/open?id=0B_2Asp8DGjJ9aDBxeVpwVURPNGc


440 monotonic time I'm waiting for 'perf top' to do something. The
command has been issued, screen is black and appears "hung".

976 monotonic time I'm waiting for a client to authenticate to the
webui management system (cockpit), which ends up failing to
authenticate due to a timeout.


-- 
Chris Murphy
