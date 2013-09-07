Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:61600 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IGDSW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Sep 2013 23:18:22 -0400
Received: by mail-vc0-f172.google.com with SMTP id m17so2776302vca.3
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Sep 2013 20:18:21 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 7 Sep 2013 05:18:21 +0200
Message-ID: <CAFvQSYSHChUQ1vCzG=+kDOn3rpH8EgFWFxagRVHwNGOb_W4uSQ@mail.gmail.com>
Subject: Btrfsck Assertion btrfs_find_last_root !(path->slots[0] == 0) - any
 hope left?
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Because of being clumsy, I recently overwrote my btrfs-partition.
Worse, the only recent backup I own is a dd-copy which was created
while the system was running.

Both, btrfsck (from btrfsprogs-next) and mount -o recovery failed - so
I wonder, are there any steps left I could try?

[root@localhost btrfs-progs]# ./btrfsck /dev/mapper/main
parent transid verify failed on 27785830400 wanted 168295 found 168298
parent transid verify failed on 27785830400 wanted 168295 found 168298
Ignoring transid failure
btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
`!(path->slots[0] == 0)' failed.
Aborted

mount -o recovery:
[  555.978120] device label fedora00 devid 1 transid 168295 /dev/mapper/ce
[  555.981272] btrfs: enabling auto recovery
[  555.981275] btrfs: disk space caching is enabled
[  555.981276] btrfs: has skinny extents
[  555.983736] parent transid verify failed on 27785830400 wanted
168295 found 168298
[  555.983741] btrfs: failed to read tree root on dm-0
[  555.984014] parent transid verify failed on 27785830400 wanted
168295 found 168298
[  555.984017] btrfs: failed to read tree root on dm-0
[  555.984487] parent transid verify failed on 27780313088 wanted
168294 found 168297
[  555.984491] btrfs: failed to read tree root on dm-0
[  555.984951] parent transid verify failed on 27763916800 wanted
168293 found 168299
[  555.984954] btrfs: failed to read tree root on dm-0
[  556.003065] btrfs bad tree block start 8844446699414819576 27357323264
[  556.003080] Failed to read block groups: -5
[  556.006211] btrfs: open_ctree failed

Thank you in advance, Clemens
