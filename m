Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51451 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaIGUil (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Sep 2014 16:38:41 -0400
Received: by mail-lb0-f180.google.com with SMTP id s7so1472897lbd.25
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Sep 2014 13:38:39 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 7 Sep 2014 23:38:39 +0300
Message-ID: <CAL-Saa_3uU936baHYjVOHXMVkNtP4mgLD6WuPUu2Wxw4SaPrzQ@mail.gmail.com>
Subject: No space on empty, degraded raid10
From: Or Tal <ortal99@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've created a new raid10 array from 4, 4TB drives in order to migrate
old data to it.
As I didn't have enough sata ports, I:
- disconnected one of the raid10 disks to free a sata port,
- connected an old disk I wanted to migrate,
- mounted the array with -o degraded
- copied the data it it.

After about 2MB I got a "no space left on device message."
btrfs fi df showed strange things - much less space in every category
(about 8GB?) and none of then was full.

Ubuntu 14.10 beta - linux 3.16.0-14

Best regards,
Or Tal.
