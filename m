Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from drutsystem.com ([84.10.39.251]:55504 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbeHTTtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 15:49:22 -0400
To: linux-btrfs@vger.kernel.org
From: Michal Soltys <soltys@ziu.info>
Subject: [btrfs-progs] btrfs receive complains about not being able to open
 its temporary file(s) (e.g. o123802-148688-0)
Message-ID: <b1e9bdf7-659f-0b63-803a-2efcac9d8af4@ziu.info>
Date: Mon, 20 Aug 2018 18:27:00 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have small btrfs filesystem with the following structure (created and used during 4.x kernels):

17:35 # btrfs subvolume list /src -qu
ID 263 gen 141492 top level 5 parent_uuid -                                    uuid e3a77929-0e4d-6744-9aed-d4d6a4de5f78 path xenial
ID 340 gen 134847 top level 5 parent_uuid e3a77929-0e4d-6744-9aed-d4d6a4de5f78 uuid f05f0983-3954-e440-ba54-3cc1d458f317 path xenial2
ID 461 gen 160056 top level 5 parent_uuid f05f0983-3954-e440-ba54-3cc1d458f317 uuid 3292eba1-4129-b841-9ab9-8a4b03d79187 path orig1
ID 462 gen 160532 top level 5 parent_uuid f05f0983-3954-e440-ba54-3cc1d458f317 uuid c806ca4d-40c1-e04a-b33f-7799648f8aff path tr
ID 464 gen 160056 top level 5 parent_uuid f05f0983-3954-e440-ba54-3cc1d458f317 uuid 51de47cb-9fbb-a64b-84c9-0ed7614cba22 path edge1
ID 465 gen 160056 top level 5 parent_uuid f05f0983-3954-e440-ba54-3cc1d458f317 uuid bcfe5026-d781-b04e-83e1-c20b9b57f1c6 path edge2
ID 466 gen 160542 top level 5 parent_uuid f05f0983-3954-e440-ba54-3cc1d458f317 uuid bc3035c5-1609-be4f-959a-2cf89559df08 path anal1
ID 475 gen 160062 top level 5 parent_uuid f05f0983-3954-e440-ba54-3cc1d458f317 uuid 5e23ff06-dbbb-7743-966f-75408084be36 path back1
ID 488 gen 160056 top level 5 parent_uuid 5e23ff06-dbbb-7743-966f-75408084be36 uuid 06a5956f-864d-4243-b303-3e9768a24a31 path back2

Originally it was used as loop mounted /var/lib/machines. In the above as you can see, the loopack device is mounted under /src
The filesystem is clean - no errors reported via btrfs scrub or btrfs check.

As I migrated my main fs to btrfs, I wanted to move the subvolumes to new btrfs, so what I did so far:

mount /dev/loop0 /src -o noatime
for x in /src/*; do btrfs property set "$x" ro; done

Then I started moving them one by one, following the structure above, thus:

btrfs send                 /src/xenial  | btrfs receive -v -e /var/lib/machines/
btrfs send -p /src/xenial  /src/xenial2 | btrfs receive -v -e /var/lib/machines/
btrfs send -p /src/xenial2 /src/orig1   | btrfs receive -v -e /var/lib/machines/
btrfs send -p /src/xenial2 /src/tr      | btrfs receive -v -e /var/lib/machines/
btrfs send -p /src/xenial2 /src/edge1   | btrfs receive -v -e /var/lib/machines/
btrfs send -p /src/xenial2 /src/edge2   | btrfs receive -v -e /var/lib/machines/
btrfs send -p /src/xenial2 /src/anal1   | btrfs receive -v -e /var/lib/machines/
btrfs send -p /src/xenial2 /src/back1   | btrfs receive -v -e /var/lib/machines/

Up to this point everything seems to have worked fine, but:

btrfs send -p /src/back1   /src/back2   | btrfs receive -v -e /var/lib/machines/
At subvol /src/back2
At snapshot back2
receiving snapshot back2 uuid=06a5956f-864d-4243-b303-3e9768a24a31, ctransid=160056 parent_uuid=5e23ff06-dbbb-7743-966f-75408084be36, parent_ctransid=160062

stops with the following error:

ERROR: cannot open /var/lib/machines/back2/o123802-148688-0: No such file or directory


Am I doing something fundamentally wrong here, or is this perhaps a bug ?

kernel version: 4.18.3
btrfs-progs: 4.17.1
