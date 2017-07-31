Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36832 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbdGaSau (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Jul 2017 14:30:50 -0400
Received: by mail-wm0-f49.google.com with SMTP id t201so187096106wmt.1
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Jul 2017 11:30:50 -0700 (PDT)
Received: from localhost ([88.98.201.53])
        by smtp.gmail.com with ESMTPSA id m77sm4201526wmd.21.2017.07.31.11.30.48
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 31 Jul 2017 11:30:48 -0700 (PDT)
Date: Mon, 31 Jul 2017 19:30:47 +0100
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Slow mounting raid1
Message-ID: <20170731183047.x2p4vyqd2pvf7t4g@tiamat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I got a raid1 setup of btrfs on a HDD array of 2 disks. The fstab has
the following mount settings:
  # cat /etc/fstab | grep raid1
  UUID=c9db91e6-0ba8-4ae6-b471-8fd4ff7ee72d /media/raid1 btrfs rw,relatime,compress=lzo,space_cache 0 0

When I try to mount the array it's consistent about 5 seconds+
  # time umount /media/raid1
  
  real    0m0.358s
  user    0m0.010s
  sys     0m0.010s
  # time mount /media/raid1
  
  real    0m5.605s
  user    0m0.504s
  sys     0m0.071s

I have this setup for sometime now and from the time I made it the mount
time went up (I notice that on boot). When I first build that was
almost instant. In terms of maintenance I regularly run a scrub and
rebalance every now and then.

Running kernel 4.11.12 (with -ck patchs)

Is there something I can do to speed it up (apart buying 2 SSDs :D ). I
feel like I'm missing something as the usage of the raid is not really
frequent - just backup mainly.

Thanks for your time.

-- 
Leonidas Spyropoulos

A: Because it messes up the order in which people normally read text.
Q: Why is it such a bad thing?
A: Top-posting.
Q: What is the most annoying thing on usenet and in e-mail?

