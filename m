Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:32889 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbGMN0P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 09:26:15 -0400
Received: by oiyy130 with SMTP id y130so253565066oiy.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2015 06:26:15 -0700 (PDT)
MIME-Version: 1.0
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Mon, 13 Jul 2015 08:25:55 -0500
Message-ID: <CAC=t97C-L0OecX8DVWSZ7dZwPo5hRAbtRg3D5dvc3cVAbfa91g@mail.gmail.com>
Subject: kernel crash - btrfs check shows "extent buffer leak"; Suggestions?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last time something happened and I poked at it myself I ended up
ruining the pool so I thought I'd ask here before doing anything.

I'm not sure if this really indicates that anything needs doing or
not.  The filesystem will mount like normal.

It doesn't look like the core dump was written anywhere but I've never
actually looked for it before.  I'm still Googling where it might be.

[root@san01 ~]# btrfs check /dev/sdi
Checking filesystem on /dev/sdi
UUID: 6848df32-bd2a-49b8-b3b9-40038f98ef8a
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
checking quota groups
Counts for qgroup id: 352 are different
our:            referenced 699122253824 referenced compressed 699122253824
disk:           referenced 699151855616 referenced compressed 699151855616
diff:           referenced -29601792 referenced compressed -29601792
our:            exclusive 1279471616 exclusive compressed 1279471616
disk:           exclusive 1279471616 exclusive compressed 1279471616
Counts for qgroup id: 844 are different
our:            referenced 699130273792 referenced compressed 699130273792
disk:           referenced 699159875584 referenced compressed 699159875584
diff:           referenced -29601792 referenced compressed -29601792
our:            exclusive 81920 exclusive compressed 81920
disk:           exclusive 81920 exclusive compressed 81920
found 875663138891 bytes used err is 0
total csum bytes: 790806028
total tree bytes: 1950498816
total fs tree bytes: 436994048
total extent tree bytes: 526237696
btree space waste bytes: 439941098
file data blocks allocated: 981391929344
 referenced 1086835916800
btrfs-progs v4.1
extent buffer leak: start 3338550263808 len 16384
extent buffer leak: start 3338550165504 len 16384
extent buffer leak: start 3100998254592 len 16384
extent buffer leak: start 3100998270976 len 16384
extent buffer leak: start 3100998287360 len 16384
extent buffer leak: start 3100998303744 len 16384
extent buffer leak: start 3100998320128 len 16384
extent buffer leak: start 3100998336512 len 16384
extent buffer leak: start 3100998352896 len 16384
extent buffer leak: start 3100998369280 len 16384
extent buffer leak: start 3338550149120 len 16384
extent buffer leak: start 3338550132736 len 16384
extent buffer leak: start 2756246339584 len 16384
extent buffer leak: start 2756284366848 len 16384
extent buffer leak: start 3339485298688 len 16384
extent buffer leak: start 3339485347840 len 16384
extent buffer leak: start 3339485429760 len 16384
extent buffer leak: start 3339485446144 len 16384
extent buffer leak: start 3339485462528 len 16384
extent buffer leak: start 3339485528064 len 16384
extent buffer leak: start 3339485544448 len 16384
extent buffer leak: start 3339485560832 len 16384
extent buffer leak: start 3339488018432 len 16384
extent buffer leak: start 3339489361920 len 16384
extent buffer leak: start 3339504140288 len 16384
extent buffer leak: start 3339504156672 len 16384
extent buffer leak: start 3339504435200 len 16384
extent buffer leak: start 3339504467968 len 16384
extent buffer leak: start 3339504484352 len 16384
extent buffer leak: start 3339505778688 len 16384
extent buffer leak: start 3339505811456 len 16384
extent buffer leak: start 3339507105792 len 16384
extent buffer leak: start 3339507187712 len 16384
extent buffer leak: start 3339507204096 len 16384
extent buffer leak: start 3339518394368 len 16384
