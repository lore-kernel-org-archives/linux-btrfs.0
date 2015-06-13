Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35975 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbbFMSq5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jun 2015 14:46:57 -0400
Received: by wigg3 with SMTP id g3so41736637wig.1
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Jun 2015 11:46:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 13 Jun 2015 21:46:56 +0300
Message-ID: <CAJc7LbrKBPydWNZ4V8h2DOtMOJTpdX1CmmtQKhayW+F_eyk1Kg@mail.gmail.com>
Subject: Failed to delete snapshot
From: =?UTF-8?B?0JvQtdC20LDQvdC60LjQvSDQmNCy0LDQvQ==?=
	<abyss.7@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have the following snapshot scheme:

$ snapper list
Type   | #   | Pre # | Date                     | User | Cleanup |
Description           | Userdata
-------+-----+-------+--------------------------+------+---------+-----------------------+-------------
single | 0   |       |                          | root |         |
current               |
single | 1   |       | Thu Apr 16 22:07:21 2015 | root |         |
first root filesystem |
single | 329 |       | Sat May 23 16:24:19 2015 | root |         |
                  |
pre    | 377 |       | Fri Jun 12 16:57:39 2015 | root | number  |
zypp(zypper)          | important=no
post   | 378 | 377   | Fri Jun 12 16:57:40 2015 | root | number  |
                  | important=no
pre    | 379 |       | Sat Jun 13 21:35:43 2015 | root | number  |
yast snapper          |

or

$ btrfs subvolume list /
ID 257 gen 67733 top level 5 path .snapshots
ID 258 gen 67694 top level 257 path .snapshots/1/snapshot
...
ID 276 gen 66670 top level 258 path .snapshots/1/snapshot/var/lib/machines
ID 642 gen 67730 top level 257 path .snapshots/329/snapshot
ID 694 gen 67694 top level 257 path .snapshots/377/snapshot
ID 695 gen 67694 top level 257 path .snapshots/378/snapshot
ID 697 gen 67729 top level 257 path .snapshots/379/snapshot

When I try to remove the snapshot 329, I get custom errors everytime:
  * system freezes completely (the most frequent outcome)
  * systems becomes absolutely unresponsive, i.e. can't run processes,
can't connect to dbus, etc.
  * some error message comes out.

This snapshot appeared on its own when I was cleaning other pre-post
snapshots in "snapper".
The OS is OpenSUSE: kernel 4.0.5, btrfs-progs v4.0+20150429

Is it an expected behaviour?
