Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:40381 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaLDBUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Dec 2014 20:20:39 -0500
Received: by mail-yh0-f44.google.com with SMTP id c41so7718398yho.17
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Dec 2014 17:20:38 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 3 Dec 2014 20:20:38 -0500
Message-ID: <CAPs0BigJG7_Z34iZXdjSQjSkMGi6SOMnbf60_DjYTotrmqYJ8w@mail.gmail.com>
Subject: If btrfs-find-root doesn't find tree roots is the filesystem lost?
From: Sandy McArthur Jr <sandymac@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a many-disk btrfs filesystem that I cannot access after a
crash. When I run btrfs-find-root I get lots of "Well block [#] seems
great [...]" lines but zero "Generation: [...]" lines.
Is this filesystem lost?


Context info below. I'll upgrade to a 3.17.4 kernel soon and try again
just in case.

mcplex src # uname -a
Linux mcplex 3.16.5-gentoo #1 SMP Mon Dec 1 22:03:39 EST 2014 x86_64
Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz GenuineIntel GNU/Linux

mcplex src #   btrfs --version
Btrfs v3.17.2

mcplex src #   btrfs fi show
parent transid verify failed on 18948425080832 wanted 720141 found 720122
parent transid verify failed on 18948425080832 wanted 720141 found 720122
parent transid verify failed on 18948425080832 wanted 720141 found 720122
parent transid verify failed on 18948425080832 wanted 720141 found 720122
Ignoring transid failure
Couldn't setup extent tree
Couldn't setup device tree
Label: 'mcmedia'  uuid: 94b3345e-2589-423c-a228-d569bf94ab58
Total devices 10 FS bytes used 11.38TiB
devid    1 size 2.73TiB used 2.27TiB path /dev/sdb1
devid    2 size 2.73TiB used 2.27TiB path /dev/sdc1
devid    3 size 2.73TiB used 2.27TiB path /dev/sdd1
devid    5 size 2.73TiB used 2.27TiB path /dev/sde1
devid    6 size 2.73TiB used 2.27TiB path /dev/sdf1
devid    7 size 2.73TiB used 2.27TiB path /dev/sdg1
devid    8 size 3.64TiB used 3.18TiB path /dev/sdh1
devid    9 size 3.64TiB used 3.18TiB path /dev/sdi1
devid   10 size 3.64TiB used 1.40TiB path /dev/sdj1
devid   11 size 3.64TiB used 1.40TiB path /dev/sdk1

Btrfs v3.17.2

[Note: devid #4 isn't there because it was cleanly removed months ago.]

The relevent dmesg output from attempting to access the filesystem
[85870.630827] BTRFS info (device sdc1): enabling auto recovery
[85870.630832] BTRFS info (device sdc1): disk space caching is enabled
[85870.848351] parent transid verify failed on 18948425080832 wanted
720141 found 720122
[85870.848848] parent transid verify failed on 18948425080832 wanted
720141 found 720122
[85870.848852] BTRFS: failed to read tree root on sdc1
[85870.849365] parent transid verify failed on 18948425080832 wanted
720141 found 720122
[85870.849974] parent transid verify failed on 18948425080832 wanted
720141 found 720122
[85870.849976] BTRFS: failed to read tree root on sdc1
[85870.850602] parent transid verify failed on 18948423397376 wanted
720140 found 720113
[85870.851228] parent transid verify failed on 18948423397376 wanted
720140 found 720113
[85870.851230] BTRFS: failed to read tree root on sdc1
[85870.851857] parent transid verify failed on 18948466679808 wanted
720139 found 720091
[85870.852482] parent transid verify failed on 18948466679808 wanted
720139 found 720091
[85870.852485] BTRFS: failed to read tree root on sdc1
[85870.853120] parent transid verify failed on 18948421505024 wanted
720138 found 720122
[85870.853731] parent transid verify failed on 18948421505024 wanted
720138 found 720122
[85870.853734] BTRFS: failed to read tree root on sdc1
[85870.985258] BTRFS: open_ctree failed

mcplex src # btrfs-find-root /dev/sdh1
Super think's the tree root is at 18948425080832, chunk root 22179840
Well block 31789056 seems great, but generation doesn't match,
have=720011, want=720141 level 0
[many lines similar to the above repeated a lot but no Generation lines]

-- 
Sandy McArthur
