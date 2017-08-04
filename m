Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34654 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751265AbdHDFvQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Aug 2017 01:51:16 -0400
Received: by mail-oi0-f50.google.com with SMTP id x3so6670097oia.1
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Aug 2017 22:51:16 -0700 (PDT)
MIME-Version: 1.0
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 4 Aug 2017 11:21:15 +0530
Message-ID: <CANT5p=rND=6FZYz6+x0924JHs3G8RH+G9GXqDfoS-ndtQUXuKQ@mail.gmail.com>
Subject: Power down tests...
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

We're running a couple of experiments on our servers with btrfs
(kernel version 4.4).
And we're running some abrupt power-off tests for a couple of scenarios:

1. We have a filesystem on top of two different btrfs filesystems
(distributed across N disks). i.e. Our filesystem lays out data and
metadata on top of these two filesystems. With the test workload, it
is going to generate a good amount of 16MB files on top of the system.
On abrupt power-off and following reboot, what is the recommended
steps to be run. We're attempting btrfs mount, which seems to fail
sometimes. If it fails, we run a fsck and then mount the btrfs. The
issue that we're facing is that a few files have been zero-sized. As a
result, there is either a data-loss, or inconsistency in the stacked
filesystem's metadata.
We're mounting the btrfs with commit period of 5s. However, I do
expect btrfs to journal the I/Os that are still dirty. Why then are we
seeing the above behaviour.

2. Another test that we're running is to create a virtual disk each on
multiple NFS mounts (softmount with timeout of 1 min), and use these
virtual disks as individual devices for one single btrfs. What is the
expected btrfs behaviour when one of the virtual disk becomes
unresponsive for a period of time (say 5 min)? Does the expectation
change if the NFS mounts are mounted with sync option?

Thanks in advance for any help you can offer.
-- 
-Shyam
