Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37097 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbbKML6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 06:58:17 -0500
Received: by wmww144 with SMTP id w144so27405793wmw.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 03:58:16 -0800 (PST)
Received: from [192.168.254.20] ([37.120.121.173])
        by smtp.googlemail.com with ESMTPSA id z13sm13906793wjr.47.2015.11.13.03.58.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Nov 2015 03:58:15 -0800 (PST)
To: linux-btrfs@vger.kernel.org
From: Tobias Reinhard <trtracer@gmail.com>
Subject: Check tree block failed
Message-ID: <5645D059.5090702@gmail.com>
Date: Fri, 13 Nov 2015 12:58:17 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I attached an 3TB drive to my ODroid, created a BTRFS FS on it an copied 
some data on it. (with RSYNC)
uname -a:
Linux odroid 3.10.92-63 #1 SMP PREEMPT Wed Nov 11 16:48:34 BRST 2015 
armv7l armv7l armv7l GNU/Linux

btrfs fi show /dev/sdc1:
Label: none  uuid: b56f091d-a65e-4c3b-8bb5-62fe64abbf49
         Total devices 1 FS bytes used 531.56GiB
         devid    1 size 2.73TiB used 535.04GiB path /dev/sdc1

While that I caused several hangs and hard resets. So the copy process 
got interrupted and I restarted it quite often.

Now I noticed that RSYNC had problems copying and these errors were in 
the syslog:
Nov 13 10:07:47 odroid kernel: [36992.586642] [c2] 
btree_readpage_end_io_hook: 80 callbacks suppressed
Nov 13 10:07:47 odroid kernel: [36992.586665] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:07:47 odroid kernel: [36992.595929] [c2] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:07:47 odroid kernel: [36992.596636] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:07:47 odroid kernel: [36992.597214] [c2] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:07:47 odroid kernel: [36992.598078] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:07:47 odroid kernel: [36992.600270] [c1] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:07:47 odroid kernel: [36992.601185] [c1] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:07:47 odroid kernel: [36992.601912] [c1] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:07:47 odroid kernel: [36992.602541] [c1] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:07:47 odroid kernel: [36992.603035] [c1] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:14:58 odroid kernel: [37423.873444] [c2] 
btree_readpage_end_io_hook: 1287 callbacks suppressed
Nov 13 10:14:58 odroid kernel: [37423.873464] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:14:58 odroid kernel: [37423.882742] [c2] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:14:58 odroid kernel: [37423.883415] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:14:58 odroid kernel: [37423.883931] [c2] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:14:58 odroid kernel: [37423.884807] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:14:58 odroid kernel: [37423.885289] [c2] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:14:58 odroid kernel: [37423.887607] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:14:58 odroid kernel: [37423.888131] [c2] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:14:58 odroid kernel: [37423.888767] [c2] btrfs bad tree block 
start 12374580131803448295 349183197184
Nov 13 10:14:58 odroid kernel: [37423.889255] [c2] btrfs bad tree block 
start 17126698417783671595 349183197184
Nov 13 10:15:08 odroid kernel: [37433.380973] [c1] 
btree_readpage_end_io_hook: 152 callbacks suppressed
Nov 13 10:15:08 odroid kernel: [37433.380993] [c1] btrfs bad tree block 
start 18333166547621876310 349182935040
Nov 13 10:15:08 odroid kernel: [37433.391719] [c1] btrfs bad tree block 
start 12350952233302023580 349182935040
Nov 13 10:15:08 odroid kernel: [37433.394788] [c1] btrfs bad tree block 
start 18333166547621876310 349182935040
Nov 13 10:15:08 odroid kernel: [37433.395243] [c1] btrfs bad tree block 
start 12350952233302023580 349182935040
Nov 13 10:15:08 odroid kernel: [37433.396542] [c1] btrfs bad tree block 
start 18333166547621876310 349182935040
Nov 13 10:15:08 odroid kernel: [37433.396984] [c1] btrfs bad tree block 
start 12350952233302023580 349182935040
Nov 13 10:15:08 odroid kernel: [37433.397494] [c1] btrfs bad tree block 
start 18333166547621876310 349182935040
Nov 13 10:15:08 odroid kernel: [37433.397919] [c1] btrfs bad tree block 
start 12350952233302023580 349182935040
Nov 13 10:15:08 odroid kernel: [37433.401755] [c1] btrfs bad tree block 
start 18333166547621876310 349182935040
Nov 13 10:15:08 odroid kernel: [37433.402153] [c1] btrfs bad tree block 
start 12350952233302023580 349182935040
...

I unmounted and ran:
btrfs check --repair /dev/sdc1
enabling repair mode
Check tree block failed, want=349182689280, have=13636680588330724269
Check tree block failed, want=349182689280, have=13636680588330724269
Check tree block failed, want=349182689280, have=9483066940738130800
Check tree block failed, want=349182689280, have=9483066940738130800
Check tree block failed, want=349182689280, have=9483066940738130800
read block failed check_tree_block

But the error stays.

btrfs rescue chunk-recover -v /dev/sdc1 gives a long list and ends with:
Total Chunks:   538
   Heathy:       282
   Bad:  256

Orphan Block Groups:

Orphan Device Extents:
The chunks in memory can not match the metadata of the fs. Repair failed.
Fail to recover the chunk tree.

The installed btrfs-progs version is
btrfs version
Btrfs v3.17

So I check out btrfs-progs (I tried master and 4.3 branch - same result) 
and tried with that. Again, a long list and ends with:
Total Chunks:           538
   Recoverable:          431
   Unrecoverable:        107

Orphan Block Groups:

Orphan Device Extents:

volumes.c:1216: btrfs_rmap_block: Assertion `!ce` failed.

What can I do next?

Any help would be appreciated.

Tobias

