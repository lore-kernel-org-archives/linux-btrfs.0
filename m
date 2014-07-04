Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49262 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbaGDRAd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 13:00:33 -0400
Received: by mail-pd0-f171.google.com with SMTP id fp1so2188654pdb.2
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Jul 2014 10:00:33 -0700 (PDT)
Message-ID: <53B6DDAD.20504@gmail.com>
Date: Fri, 04 Jul 2014 10:00:29 -0700
From: Konstantin Svist <fry.kun@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs partition remounted read-only
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have an overnight cron job with

/sbin/fstrim -v /
/bin/bedup dedup --defrag

Every once in a while, it causes the FS to be remounted read-only.
Problem is pretty intermittent so far (aside from a few kernel revisions
a while ago).

Please advise.


Corresponding bugs:
https://bugzilla.kernel.org/show_bug.cgi?id=71311
https://bugzilla.redhat.com/show_bug.cgi?id=1071408

Addtl info:

# uname -a
Linux mireille.svist.net 3.14.9-200.fc20.x86_64 #1 SMP Thu Jun 26
21:40:51 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
# btrfs --version
Btrfs v3.14.2
# btrfs fi show
Label: none  uuid: 5ac56e7d-3d04-4ffa-8160-5a47f46c2939
    Total devices 1 FS bytes used 151.77GiB
    devid    1 size 465.76GiB used 282.02GiB path /dev/sda2

Btrfs v3.14.2
# btrfs fi df /
Data, single: total=277.01GiB, used=148.86GiB
System, single: total=4.00MiB, used=48.00KiB
Metadata, single: total=5.01GiB, used=2.91GiB

