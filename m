Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41861 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750836AbdGIFcf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Jul 2017 01:32:35 -0400
Date: Sat, 8 Jul 2017 22:32:28 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
Message-ID: <20170709053228.donh2nh75idlzfck@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: Can I drop/reset files with corrupted data if they are in a read
 only snapshot?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the mails, I still have one more problem I'm trying to work
through.

My filesystem that probably got real corruption due to an unstable block
layer underneath (my 2 other machines with other problems did not have
an unstable block layer and just started having problem recently, which
is why I'm wondering if 4.11 has issues over 4.8 which I was running.
before)

I have 2 filesystems that mostly pass check --repair, except for some
checksum verify errors which do not get fixed/reset by check --repair.

btrfs scrub shows 2 files that have issues.

First, check --repair should tell me what those "on 739295232" refer to.
Can't it tell me what pathname it refers to? That would seem like the
useful thing to do :)

Second, ok, after a 24H scrub (yes, it's long and slow), I know which
filenames have issues. Problem is that they are inside a read only btrfs
snapshot. I cannot delete this snapshot because if I do so, I will
destroy a btrfs send/receive relationship that will take 2 + 1 day to
recreate (2 filesystems both have 2 files to delete each).
How can I force delete the file anyway, or reset the checksum and accept 
that the file is corrupted, but not care?
(I've deleted it and the next btrfs send/receive will free the blocks anyway)

Yes, of course you're going to tell me "well, just btrfs send/receive
the new subvolume with the file deleted and then you can delete the old snapshot
and free the corrupted data blocks".
That sounds like a grand idea except for the fact that that the filesystem
I'm syncing to is the one that's even more corrupted (previous post where
btrfs check --repair just bails) and I'm not really interested in deleting 
and recreating that filesystem until I've gotten the source back to a
100% consistent state.


Here's the not very helpful check --repair output which doesn't actually
fix this error (it should have an option to show the pathames and reset
the checksum to pass, giving me a consistent file with corrupted data as
opposed to a corrupted file that will keep giving scrub errors).


gargamel:/mnt/dshelf2# btrfs check --repair  /dev/mapper/dshelf2
enabling repair mode
Checking filesystem on /dev/mapper/dshelf2
UUID: 85441c59-ad11-4b25-b1fe-974f9e4acede
checking extents
checksum verify failed on 739295232 found AB0CFE79 wanted E49CEF52
checksum verify failed on 739295232 found AB0CFE79 wanted E49CEF52
checksum verify failed on 1004978176 found 28A151B1 wanted 78F6E880
checksum verify failed on 1004978176 found 28A151B1 wanted 78F6E880
checksum verify failed on 1004994560 found D6F1289C wanted 0FA88800
checksum verify failed on 1004994560 found D6F1289C wanted 0FA88800
checksum verify failed on 1005010944 found 977BEF09 wanted 22373398
checksum verify failed on 1005010944 found 977BEF09 wanted 22373398
checksum verify failed on 1005027328 found 34BEB207 wanted E6A513DF
checksum verify failed on 1005027328 found 34BEB207 wanted E6A513DF
checksum verify failed on 1005043712 found F5D4AE42 wanted 12BB8F8A
checksum verify failed on 1005043712 found F5D4AE42 wanted 12BB8F8A
checksum verify failed on 1005305856 found 1BF2C6B2 wanted 47612155
checksum verify failed on 1005305856 found 1BF2C6B2 wanted 47612155
checksum verify failed on 1005322240 found 9D6E28D3 wanted 62A9226F
checksum verify failed on 1005322240 found 9D6E28D3 wanted 62A9226F
checksum verify failed on 1005338624 found 43C7415B wanted 0EA181CD
checksum verify failed on 1005338624 found 43C7415B wanted 0EA181CD
checksum verify failed on 1005355008 found 34412580 wanted CE332649
checksum verify failed on 1005355008 found 34412580 wanted CE332649
checksum verify failed on 1005371392 found 1C4E7E82 wanted 45E50CFA
checksum verify failed on 1005371392 found 1C4E7E82 wanted 45E50CFA
checksum verify failed on 1005633536 found 807C372E wanted 43C01363
checksum verify failed on 1005633536 found 807C372E wanted 43C01363
checksum verify failed on 1005649920 found 394F7D66 wanted 33287C40
checksum verify failed on 1005649920 found 394F7D66 wanted 33287C40
checksum verify failed on 1005666304 found EB0C7401 wanted B4F6D008
checksum verify failed on 1005666304 found EB0C7401 wanted B4F6D008
checksum verify failed on 1005682688 found AC3B9712 wanted 1929DF15
checksum verify failed on 1005682688 found AC3B9712 wanted 1929DF15
checksum verify failed on 1005699072 found 2D97416A wanted 9ED13B7A
checksum verify failed on 1005699072 found 2D97416A wanted 9ED13B7A
checksum verify failed on 1005961216 found 38C53268 wanted 498134D2
checksum verify failed on 1005961216 found 38C53268 wanted 498134D2
checksum verify failed on 1005977600 found 83FDF0D8 wanted E053CB4C
checksum verify failed on 1005977600 found 83FDF0D8 wanted E053CB4C
checksum verify failed on 1005993984 found FC14EAA1 wanted 77CC1138
checksum verify failed on 1005993984 found FC14EAA1 wanted 77CC1138
checksum verify failed on 1004716032 found 0D81ACC5 wanted 7D183AC3
checksum verify failed on 1004716032 found 0D81ACC5 wanted 7D183AC3
checksum verify failed on 5007628828672 found E310440B wanted B97786A9
checksum verify failed on 5007628828672 found E310440B wanted B97786A9
checksum verify failed on 5007634382848 found AB2C51FB wanted 652C2576
checksum verify failed on 5007634382848 found AB2C51FB wanted 652C2576
checksum verify failed on 5007629533184 found FFEFCC4E wanted BE0D95C5
checksum verify failed on 5007629533184 found FFEFCC4E wanted BE0D95C5
checksum verify failed on 5007630188544 found F13BA327 wanted 5BF425F0
checksum verify failed on 5007630188544 found F13BA327 wanted 5BF425F0
checksum verify failed on 5007630450688 found C36204E9 wanted F063A8D6
checksum verify failed on 5007630450688 found C36204E9 wanted F063A8D6
checksum verify failed on 5007631433728 found 422E6B77 wanted 7D492202
checksum verify failed on 5007631433728 found 422E6B77 wanted 7D492202
Fixed 0 roots.
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
checksum verify failed on 1004978176 found 28A151B1 wanted 78F6E880
checksum verify failed on 1004978176 found 28A151B1 wanted 78F6E880
checksum verify failed on 1004994560 found D6F1289C wanted 0FA88800
checksum verify failed on 1004994560 found D6F1289C wanted 0FA88800
checksum verify failed on 1005010944 found 977BEF09 wanted 22373398
checksum verify failed on 1005010944 found 977BEF09 wanted 22373398
checksum verify failed on 1005027328 found 34BEB207 wanted E6A513DF
checksum verify failed on 1005027328 found 34BEB207 wanted E6A513DF
checksum verify failed on 1005043712 found F5D4AE42 wanted 12BB8F8A
checksum verify failed on 1005043712 found F5D4AE42 wanted 12BB8F8A
checksum verify failed on 1005355008 found 34412580 wanted CE332649
checksum verify failed on 1005355008 found 34412580 wanted CE332649
checksum verify failed on 1005649920 found 394F7D66 wanted 33287C40
checksum verify failed on 1005649920 found 394F7D66 wanted 33287C40
checksum verify failed on 1005305856 found 1BF2C6B2 wanted 47612155
checksum verify failed on 1005305856 found 1BF2C6B2 wanted 47612155
checksum verify failed on 1005322240 found 9D6E28D3 wanted 62A9226F
checksum verify failed on 1005322240 found 9D6E28D3 wanted 62A9226F
checksum verify failed on 1005338624 found 43C7415B wanted 0EA181CD
checksum verify failed on 1005338624 found 43C7415B wanted 0EA181CD
checksum verify failed on 1005371392 found 1C4E7E82 wanted 45E50CFA
checksum verify failed on 1005371392 found 1C4E7E82 wanted 45E50CFA
checksum verify failed on 1005633536 found 807C372E wanted 43C01363
checksum verify failed on 1005633536 found 807C372E wanted 43C01363
checksum verify failed on 1005666304 found EB0C7401 wanted B4F6D008
checksum verify failed on 1005666304 found EB0C7401 wanted B4F6D008
checksum verify failed on 1005682688 found AC3B9712 wanted 1929DF15
checksum verify failed on 1005682688 found AC3B9712 wanted 1929DF15
checksum verify failed on 1005699072 found 2D97416A wanted 9ED13B7A
checksum verify failed on 1005699072 found 2D97416A wanted 9ED13B7A
checksum verify failed on 1005977600 found 83FDF0D8 wanted E053CB4C
checksum verify failed on 1005977600 found 83FDF0D8 wanted E053CB4C
checksum verify failed on 1005961216 found 38C53268 wanted 498134D2
checksum verify failed on 1005961216 found 38C53268 wanted 498134D2
checksum verify failed on 1005993984 found FC14EAA1 wanted 77CC1138
checksum verify failed on 1005993984 found FC14EAA1 wanted 77CC1138
checksum verify failed on 739295232 found AB0CFE79 wanted E49CEF52
checksum verify failed on 739295232 found AB0CFE79 wanted E49CEF52
checksum verify failed on 1004716032 found 0D81ACC5 wanted 7D183AC3
checksum verify failed on 1004716032 found 0D81ACC5 wanted 7D183AC3
checksum verify failed on 5007628828672 found E310440B wanted B97786A9
checksum verify failed on 5007628828672 found E310440B wanted B97786A9
checksum verify failed on 5007634382848 found AB2C51FB wanted 652C2576
checksum verify failed on 5007634382848 found AB2C51FB wanted 652C2576
checksum verify failed on 5007630450688 found C36204E9 wanted F063A8D6
checksum verify failed on 5007630450688 found C36204E9 wanted F063A8D6
checksum verify failed on 5007630188544 found F13BA327 wanted 5BF425F0
checksum verify failed on 5007630188544 found F13BA327 wanted 5BF425F0
checksum verify failed on 5007629533184 found FFEFCC4E wanted BE0D95C5
checksum verify failed on 5007629533184 found FFEFCC4E wanted BE0D95C5
checksum verify failed on 5007631433728 found 422E6B77 wanted 7D492202
checksum verify failed on 5007631433728 found 422E6B77 wanted 7D492202
checking csums
checksum verify failed on 739295232 found AB0CFE79 wanted E49CEF52
checksum verify failed on 739295232 found AB0CFE79 wanted E49CEF52
checking root refs
found 5549203357696 bytes used, no error found
total csum bytes: 5349057632
total tree bytes: 70597869568
total fs tree bytes: 58616217600
total extent tree bytes: 5328896000
btree space waste bytes: 10798180295
file data blocks allocated: 7842832334848
 referenced 6186390810624

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
