Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:35476 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdFKCfh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Jun 2017 22:35:37 -0400
Received: by mail-wr0-f174.google.com with SMTP id q97so64950107wrb.2
        for <linux-btrfs@vger.kernel.org>; Sat, 10 Jun 2017 19:35:37 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 10 Jun 2017 20:35:35 -0600
Message-ID: <CAJCQCtR+cnyY3YS3hxjRA37U-4tN_kDLV9+ccbpREMMziiW9Tw@mail.gmail.com>
Subject: eBPF tracing Btrfs performance
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ran into this:
http://www.brendangregg.com/ebpf.html

And then found this:
https://github.com/iovisor/bcc/blob/master/tools/btrfsslower.py


Anyone given it a shot? This is in the regular Fedora repo, so 'dnf
install bcc kernel-devel' will do it. I'm running into a segmentation
fault, most likely because I'm on a pre-release of Fedrao 26. But it
looks kinda interesting.


-- 
Chris Murphy
