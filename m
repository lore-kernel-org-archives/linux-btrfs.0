Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40853 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3IEOnt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 10:43:49 -0400
Received: by mail-wi0-f176.google.com with SMTP id cb5so5038570wib.9
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Sep 2013 07:43:48 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>
Date: Thu, 5 Sep 2013 17:43:27 +0300
Message-ID: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
Subject: btrfs-convert won't convert ext* - No valid Btrfs found on /dev/sdb1
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello guys, i try to convert ext4 volume, but btrfs-convert show me error:
"No valid Btrfs found on file
unable to open ctree
conversion aborted."
Ubuntu 13.04
Kernel: 3.11
btrfs-progs git version 0.20-git20130822~194aa4a13

way to reproduce error:
$ truncate -s 4G file
$ mkfs.ext4 file #say yes to create fs on non block device.
$ btrfs-convert file
 No valid Btrfs found on file
 unable to open ctree
 conversion aborted.

With best regards,
Timofey.
