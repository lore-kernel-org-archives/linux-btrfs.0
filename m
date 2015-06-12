Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34288 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbFLUCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 16:02:05 -0400
Received: by wgv5 with SMTP id 5so30940117wgv.1
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 13:02:04 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 12 Jun 2015 13:02:04 -0700
Message-ID: <CAPF83mte1BQaq8snqx_dJETttpAiqJpKbqxdz0OsJTeR_C7=JQ@mail.gmail.com>
Subject: subvolume parent id and uuid mismatch (progs 4.0, kernel 4.0.2)
From: Suman C <schakrava@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a raid1 filesystem:

Label: 'raid1pool'  uuid: b97d3055-c60c-4f10-aa1b-bf9554f043c9
Total devices 2 FS bytes used 320.00KiB
devid    1 size 2.00GiB used 437.50MiB path /dev/sdd
devid    2 size 2.00GiB used 417.50MiB path /dev/sde

It's mounted at /mnt2/raid1pool

# mount | grep raid1pool
/dev/sdd on /mnt2/raid1pool type btrfs (rw,relatime,space_cache)

created a subvolume

# btrfs subvol create /mnt2/raid1pool/share1
Create subvolume '/mnt2/raid1pool/share1'
# btrfs subvol list -u -p -q /mnt2/raid1pool/
ID 261 gen 27 parent 5 top level 5 parent_uuid - uuid
0e31fe3c-d35d-d346-9560-b29b82ff384a path share1

created two snapshots(different destinations) like so:

# mkdir -p /mnt2/raid1pool/.snapshots/share1
# btrfs subvol snapshot /mnt2/raid1pool/share1
/mnt2/raid1pool/.snapshots/share1/snap1
Create a snapshot of '/mnt2/raid1pool/share1' in
'/mnt2/raid1pool/.snapshots/share1/snap1'
# btrfs subvol snapshot /mnt2/raid1pool/share1 /mnt2/raid1pool/share1/snap2
Create a snapshot of '/mnt2/raid1pool/share1' in '/mnt2/raid1pool/share1/snap2'

Then..

# btrfs subvol list -u -p -q /mnt2/raid1pool/
ID 261 gen 29 parent 5 top level 5 parent_uuid - uuid
0e31fe3c-d35d-d346-9560-b29b82ff384a path share1
ID 262 gen 28 parent 5 top level 5 parent_uuid
0e31fe3c-d35d-d346-9560-b29b82ff384a uuid
91354cbc-615f-be40-8afb-eb0c254157d8 path .snapshots/share1/snap1
ID 263 gen 29 parent 261 top level 261 parent_uuid
0e31fe3c-d35d-d346-9560-b29b82ff384a uuid
d236544e-5044-c645-a0b7-440c15727d8e path share1/snap2

You see how the parent_uuids of both snapshots match the uuid of the
subvolume(0e31fe3c-d35d-d346-9560-b29b82ff384a) but the parent ids
don't match. I was hoping to see 261 as the parent id for both
snapshots. Am I missing something or is this a bug in btrfs-progs?

Suman
