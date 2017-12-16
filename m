Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward104j.mail.yandex.net ([5.45.198.247]:36553 "EHLO
        forward104j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756865AbdLPT6L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Dec 2017 14:58:11 -0500
Received: from mxback17j.mail.yandex.net (mxback17j.mail.yandex.net [IPv6:2a02:6b8:0:1619::93])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id 6EF03433CF
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Dec 2017 22:50:34 +0300 (MSK)
From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Unexpected raid1 behaviour
To: linux-btrfs@vger.kernel.org
Message-ID: <5A357909.8010206@yandex.ru>
Date: Sat, 16 Dec 2017 22:50:33 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Could someone please point me towards some read about how btrfs handles
multiple devices? Namely, kicking faulty devices and re-adding them.

I've been using btrfs on single devices for a while, but now I want to
start using it in raid1 mode. I booted into an Ubuntu 17.10 LiveCD and
tried to see how does it handle various situations. The experience left
me very surprised; I've tried a number of things, all of which produced
unexpected results.

I create a btrfs raid1 filesystem on two hard drives and mount it.

- When I pull one of the drives out (simulating a simple cable failure,
which happens pretty often to me), the filesystem sometimes goes
read-only. ???
- But only after a while, and not always. ???
- When I fix the cable problem (plug the device back), it's immediately
"re-added" back. But I see no replication of the data I've written onto
a degraded filesystem... Nothing shows any problems, so "my filesystem
must be ok". ???
- If I unmount the filesystem and then mount it back, I see all my
recent changes lost (everything I wrote during the "degraded" period).
- If I continue working with a degraded raid1 filesystem (even without
damaging it further by re-adding the faulty device), after a while it
won't mount at all, even with "-o degraded".

I can't wrap my head about all this. Either the kicked device should not
be re-added, or it should be re-added "properly", or it should at least
show some errors and not pretend nothing happened, right?..

I must be missing something. Is there an explanation somewhere about
what's really going on during those situations? Also, do I understand
correctly that upon detecting a faulty device (a write error), nothing
is done about it except logging an error into the 'btrfs device stats'
report? No device kicking, no notification?.. And what about degraded
filesystems - is it absolutely forbidden to work with them without
converting them to a "single" filesystem first?..

On Ubuntu 17.10, there's Linux 4.13.0-16 and btrfs-progs 4.12-1 .


-- 
darkpenguin
