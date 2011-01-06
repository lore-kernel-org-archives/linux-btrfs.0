From: =?UTF-8?B?SXZhbiBMYWLDoXRo?= <ilabath@gmail.com>
Subject: raw fs backup/copy
Date: Thu, 06 Jan 2011 17:36:48 +0100
Message-ID: <4D25EFA0.9010809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a reason one can not mount a btrfs and it's byte-for-byte
copy in parallel, or is the driver just acting silly?

Mini example:
# dd if=/dev/zero of=fs1 bs=1 count=1 seek=$((1024*1024*1024-1))
# mkfs.btrfs fs1
# cp --sparse=always fs1 fs2
# mkdir 1 2
# mount fs1 1 -o loop
# mount fs2 2 -o loop
# touch 1/1
# ls 2
1
# cat /proc/mounts
/dev/loop0 /tmp/test/1 btrfs rw,relatime 0 0
/dev/loop1 /tmp/test/2 btrfs rw,relatime 0 0

--
ivan
