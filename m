Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38006 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaLPJwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 04:52:43 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so16888440wgh.36
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 01:52:42 -0800 (PST)
MIME-Version: 1.0
From: Joe Doliner <jdoliner@pachyderm.io>
Date: Tue, 16 Dec 2014 01:52:22 -0800
Message-ID: <CAA2X+Rn0LgVEcovYLGvu_kjHBqc7qQgXgEAQ7mKs6MORmeop4A@mail.gmail.com>
Subject: finding path of subvolume from uuid
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using `btrfs subvolume show path` I can get information about what a
subvolume's parent is by uuid.
I'd like to use that information to perform a find-new between the
subvolume and its parent. To do that though I need the path of the
parent and I'm not sure the best way to do find it.

One way would be to grep a `btrfs subvolume list` which is probably
fine but needlessly slow if there's a direct way to convert from uuid
to path.

Also just subscribed to this list, nice to meet all of you I'm jdoliner.

Thanks in advance for the help.


Likely irrelevant but here's system config:

Linux jd.c.celtic-guru-651.internal 3.17.2+ #2 SMP Thu Dec 4 18:08:02
UTC 2014 x86_64 Intel(R) Xeon(R) CPU @ 2.60GHz GenuineIntel GNU/Linux
Btrfs v3.14_pre20140414
Label: 'ROOT'  uuid: 4c2a047c-c81f-4838-b281-0e562fe02afe
        Total devices 1 FS bytes used 3.43GiB
        devid    1 size 6.68GiB used 4.82GiB path /dev/sda9

Label: none  uuid: 25db08a6-4771-48b6-bcae-999a65f49bf1
        Total devices 1 FS bytes used 24.56GiB
        devid    1 size 100.00GiB used 27.04GiB path /dev/sdb

Label: none  uuid: dc6cd8a9-ff7e-4577-9098-3909061be47c
        Total devices 1 FS bytes used 379.74MiB
        devid    1 size 10.00GiB used 3.04GiB path /dev/loop0

Btrfs v3.14_pre20140414
Data, single: total=24.01GiB, used=23.70GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=1.50GiB, used=880.41MiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=304.00MiB, used=0.00
