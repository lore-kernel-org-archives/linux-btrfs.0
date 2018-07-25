Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f173.google.com ([209.85.208.173]:43893 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725752AbeGYEax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 00:30:53 -0400
Received: by mail-lj1-f173.google.com with SMTP id r13-v6so5390888ljg.10
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jul 2018 20:21:16 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jul 2018 21:21:15 -0600
Message-ID: <CAJCQCtS2kv1irJ6fg36cCZb2Yf-beJEUY8Hu8-whFm+h89q22w@mail.gmail.com>
Subject: ssd vs ssd_spread with sdcard or emmc
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm not finding any recent advice for sdcard or eMMC media, both of
which trigger the ssd mount option automatically. I seem to recall ssd
has had some optimizations recently, but haven't heard much about
ssd_spread.

While sdcard and eMMC are rather different, it seems they have two
things in common: they don't have the wear durability of even consumer
SATA SSD let alone NVMe, and also they both suffer from dog slow
writes. I'm unable to tell that ssd_spread does any better writes wise
on a Samsung EVO+ sdcard. So that leaves wear and in particular if
wandering trees is at all affected by ssd_spread?

-- 
Chris Murphy
