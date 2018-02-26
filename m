Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:52884 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbeBZXU3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Feb 2018 18:20:29 -0500
Subject: Re: incremental send/receive ERROR: cannot find parent subvolume
To: "Emil.s" <emil@sandnabba.se>, linux-btrfs@vger.kernel.org
References: <CAEA9r7BC+ozxzK_Gp50LNobgFOXfi9CoUdGLPbFjMCAW+ujVDQ@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <cdc11036-72ff-7f6a-77d7-17db81547a98@mendix.com>
Date: Tue, 27 Feb 2018 00:20:26 +0100
MIME-Version: 1.0
In-Reply-To: <CAEA9r7BC+ozxzK_Gp50LNobgFOXfi9CoUdGLPbFjMCAW+ujVDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/26/2018 11:54 PM, Emil.s wrote:
> Hello,
> 
> I'm trying to restore a subvolume from a backup, but I'm failing when
> I try to setup the replication chain again.
> 
> Previously I had disk A and B, where I was sending snapshots from A to
> B using "send -c /disk_a/1 /disk_a/2 | receive /disk_b" and so on.
> Now disk A failed, so I got a new disk: C.
> 
> First I sent the last backup from B to C by running "send disk_b/2 |
> receive /disk_c/".

I can't read all of it right now, my time is a bit limited, but I have a
quick suggestion to at least make the original goal work, I think.

The list of snapshots that were on your A was organized differently than
the list with the same numbers 1, 2, 3 on B.

On A, you always snapshot the main r/w subvolume.

A
\_ A1
\_ A2
\_ A3

On B, every time you receive based on a previous one, it snapshots the
previous one and then puts changes on top:

B1 (received from A1)
\_ B2 (snap from B1, with changes from A1->A2)
   \_ B3 (snap from B2, with changes from A2->A3)
      \_ etc...

If A is gone, and you have new empty C:

> Then my plan was to use disk B as the new main disk, so on disk B, I
> created a new snapshot by running "snapshot -r disk_b/2
> disk_b/my_volume".
> Now I want to send "disk_b/my_volume" to disk C, so that I can set
> disk_b/2 to RW and start using it again, but the last send fails with
> "ERROR: cannot find parent subvolume".

Do it like this:

-# btrfs snap B2 my_volume (so no -r)

now my_volume is a writable clone of B2

-# btrfs snap -r my_volume my_volume1

now you start a new line of snapshots where my_volume has the same role
as A before.

my_volume
\_ my_volume1
\_ my_volume2
\_ my_volume3

Now you can send my_volume3 -p my_volume2 etc...

Then you discard all old Bx whenever you want.

In the following, disk_b/2 and your other example names are suddenly
replaced by real names, which makes it a bit hard to follow quickly.

> Disk B:
> root@tillberga: /backup #> btrfs subvol sh snapshots/user_data_2018-02-17/
> snapshots/user_data_2018-02-17
> Name: user_data_2018-02-17
> UUID: 93433261-d954-9f4b-8319-d450ae079a9a
> Parent UUID: 51180286-c202-c94c-b8f9-2ecc8d2b5b7c
> Received UUID: 014fc004-ae04-0148-9525-1bf556fd4d10
> Flags: readonly
> Snapshot(s):
> user_data_test
> 
> Disk C:
> root@hedemora: /btrfs #> btrfs subvol sh user_data_2018-02-17/
> user_data_2018-02-17
> Name: user_data_2018-02-17
> UUID: 35361429-a42c-594b-b390-51ffb9725324
> Parent UUID: -
> Received UUID: 93433261-d954-9f4b-8319-d450ae079a9a
> Flags: readonly
> Snapshot(s):
> 
> Disk B has UUID 93433261-d954-9f4b-8319-d450ae079a9a, and disk C has
> "Received UUID: 93433261-d954-9f4b-8319-d450ae079a9a". I think that's
> alright?
> 
> The new snapshot on disk B looks as following:
> root@tillberga: /backup #> btrfs subvol sh user_data_test
> user_data_test
> Name: user_data_test
> UUID: bf88000c-e3a6-434b-8f69-f5ce2174227e
> Parent UUID: 93433261-d954-9f4b-8319-d450ae079a9a
> Received UUID: 014fc004-ae04-0148-9525-1bf556fd4d10
> Flags: readonly
> Snapshot(s):
> 
> But when I'm trying to send it, I'm getting the following:
> root@tillberga: /backup #> btrfs send -v -c
> snapshots/user_data_2018-02-17 user_data_test | ssh user@hedemora
> "sudo btrfs receive -v /btrfs/"
> At subvol user_data_test
> BTRFS_IOC_SEND returned 0
> joining genl thread
> receiving snapshot user_data_test
> uuid=014fc004-ae04-0148-9525-1bf556fd4d10, ctransid=52373
> parent_uuid=014fc004-ae04-0148-9525-1bf556fd4d10,
> parent_ctransid=52373
> At snapshot user_data_test
> ERROR: cannot find parent subvolume
> 
> Note that the receiver says
> "parent_uuid=014fc004-ae04-0148-9525-1bf556fd4d10". Not really sure
> where that comes from, but disk B has the same, so maybe that's the
> UUID of the original snapshot on disk A?
> 
> Is it possible to continue to send incremental snapshots between these
> two file systems, or must I do a full sync?


-- 
Hans van Kranenburg
