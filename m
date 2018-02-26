Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:37154 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbeBZWyW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 17:54:22 -0500
Received: by mail-lf0-f43.google.com with SMTP id y19so24687710lfd.4
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Feb 2018 14:54:22 -0800 (PST)
MIME-Version: 1.0
From: "Emil.s" <emil@sandnabba.se>
Date: Mon, 26 Feb 2018 23:54:00 +0100
Message-ID: <CAEA9r7BC+ozxzK_Gp50LNobgFOXfi9CoUdGLPbFjMCAW+ujVDQ@mail.gmail.com>
Subject: incremental send/receive ERROR: cannot find parent subvolume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm trying to restore a subvolume from a backup, but I'm failing when
I try to setup the replication chain again.

Previously I had disk A and B, where I was sending snapshots from A to
B using "send -c /disk_a/1 /disk_a/2 | receive /disk_b" and so on.
Now disk A failed, so I got a new disk: C.

First I sent the last backup from B to C by running "send disk_b/2 |
receive /disk_c/".

Then my plan was to use disk B as the new main disk, so on disk B, I
created a new snapshot by running "snapshot -r disk_b/2
disk_b/my_volume".
Now I want to send "disk_b/my_volume" to disk C, so that I can set
disk_b/2 to RW and start using it again, but the last send fails with
"ERROR: cannot find parent subvolume".

Disk B:
root@tillberga: /backup #> btrfs subvol sh snapshots/user_data_2018-02-17/
snapshots/user_data_2018-02-17
Name: user_data_2018-02-17
UUID: 93433261-d954-9f4b-8319-d450ae079a9a
Parent UUID: 51180286-c202-c94c-b8f9-2ecc8d2b5b7c
Received UUID: 014fc004-ae04-0148-9525-1bf556fd4d10
Flags: readonly
Snapshot(s):
user_data_test

Disk C:
root@hedemora: /btrfs #> btrfs subvol sh user_data_2018-02-17/
user_data_2018-02-17
Name: user_data_2018-02-17
UUID: 35361429-a42c-594b-b390-51ffb9725324
Parent UUID: -
Received UUID: 93433261-d954-9f4b-8319-d450ae079a9a
Flags: readonly
Snapshot(s):

Disk B has UUID 93433261-d954-9f4b-8319-d450ae079a9a, and disk C has
"Received UUID: 93433261-d954-9f4b-8319-d450ae079a9a". I think that's
alright?

The new snapshot on disk B looks as following:
root@tillberga: /backup #> btrfs subvol sh user_data_test
user_data_test
Name: user_data_test
UUID: bf88000c-e3a6-434b-8f69-f5ce2174227e
Parent UUID: 93433261-d954-9f4b-8319-d450ae079a9a
Received UUID: 014fc004-ae04-0148-9525-1bf556fd4d10
Flags: readonly
Snapshot(s):

But when I'm trying to send it, I'm getting the following:
root@tillberga: /backup #> btrfs send -v -c
snapshots/user_data_2018-02-17 user_data_test | ssh user@hedemora
"sudo btrfs receive -v /btrfs/"
At subvol user_data_test
BTRFS_IOC_SEND returned 0
joining genl thread
receiving snapshot user_data_test
uuid=014fc004-ae04-0148-9525-1bf556fd4d10, ctransid=52373
parent_uuid=014fc004-ae04-0148-9525-1bf556fd4d10,
parent_ctransid=52373
At snapshot user_data_test
ERROR: cannot find parent subvolume

Note that the receiver says
"parent_uuid=014fc004-ae04-0148-9525-1bf556fd4d10". Not really sure
where that comes from, but disk B has the same, so maybe that's the
UUID of the original snapshot on disk A?

Is it possible to continue to send incremental snapshots between these
two file systems, or must I do a full sync?
