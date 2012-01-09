From: Marios Titas <redneb8888@gmail.com>
Subject: Re: [PATCH 00/21] Btrfs: restriper
Date: Mon, 9 Jan 2012 01:50:34 -0500
Message-ID: <CAAdM645+sZ-z1T5==M9S_GBJ1R2h=8fwtx57uvXxWkFR=VtReg@mail.gmail.com>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I tried this for many different scenarios and it seems to work pretty
well. I only ran into one problematic case: If you remove a device
from a multidevice filesystem it crashes. Here's how to reproduce it:

truncate -s1g /tmp/test1
truncate -s1g /tmp/test2
losetup /dev/loop1 /tmp/test1
losetup /dev/loop2 /tmp/test2
mkdir /tmp/test
./mkfs.btrfs -L test -d single -m single /dev/loop1 /dev/loop2
mount -o noatime /dev/loop1 /tmp/test
./btrfs dev del /dev/loop1 /tmp/test
./btrfs fi bal start /tmp/test

There is no actual restriping involved but the above example does work
corretly under 3.1+for-linus whereas it fails with your patches.
