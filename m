Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51446 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab2L1SJG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 13:09:06 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so4331685eaa.5
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 10:09:04 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 29 Dec 2012 04:39:04 +1030
Message-ID: <CACCfv7ot+WTV1eiBCujcyPkSt7SGqVvVCKpFo4rn8Y=FEZu_7w@mail.gmail.com>
Subject: parent transid verify failed on -- After moving btrfs closer to the
 beginning of drive with dd
From: Jordan Windsor <jordanw2@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I moved my btrfs to the beginning of my drive & updated the partition
table & also restarted, I'm currently unable to mount it, here's the
output in dmesg.

[  481.513432] device label Storage devid 1 transid 116023 /dev/sdb1
[  481.514277] btrfs: disk space caching is enabled
[  481.522611] parent transid verify failed on 1229060423680 wanted
116023 found 116027
[  481.522789] parent transid verify failed on 1229060423680 wanted
116023 found 116027
[  481.522790] btrfs: failed to read tree root on sdb1
[  481.523656] btrfs: open_ctree failed

What command should I run from here?
Thanks.
