Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47524 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdCYXSM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 25 Mar 2017 19:18:12 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cruQo-0006CT-8b
        for linux-btrfs@vger.kernel.org; Sat, 25 Mar 2017 23:45:10 +0100
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: send snapshot from snapshot incremental
Date: Sat, 25 Mar 2017 23:37:13 +0100
Message-ID: <p18jqd-a0m.ln1@aldebaran.xundeenergie.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there!

I asked one or two years ago for the ability of btrfs to use btrfs
send|receive with a parent-subvolume from a snapshot from a snapshot.

The thing is, if i take a snapshot from my system, transfer it with
btrfs send|receive  to an external HD on USB-Port, make some changes to
my system, which destroy my whole system, i can boot in the former taken
snapshot and work from there, as if nothing happened.

This part works.

BUT if i take a snapshot from the system, and want to transfer it to the
external HD, i can not set a parent subvolume, because there isn't any.

The problem was on my last question, there are missing
tansactional-numbers or something similar... I'm not a programmer, but i
use btrfs very extensive and wrote a fancy python-script and a
gnome-shell-extension and a fuse-filesystem to do enhanced and
userfriendly snapshots an backups with btrfs - also for non-programmer
users... something similar userfriendly as time-machine for apple does.

And one missing feature is the described problem above... booting into
an older snapshot and transfer a snapshot from this one lead to a full
transfer - even if there is a transferred snapshot on the external HD.

I hope, i described my problem understandable...

regards

Jakob

