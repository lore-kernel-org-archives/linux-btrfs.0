Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:35888 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbbK0QcI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 11:32:08 -0500
Received: by lfs39 with SMTP id 39so132010326lfs.3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 08:32:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3E0A8132-7121-482F-BAAC-BAC6D18661AC@up4.com>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
	<5654C86C.9080800@gmail.com>
	<20151124203210.GR24333@carfax.org.uk>
	<B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com>
	<56566416.5000405@cn.fujitsu.com>
	<4EF3E931-9089-40FB-8E8E-1928539D39D4@up4.com>
	<3E0A8132-7121-482F-BAAC-BAC6D18661AC@up4.com>
Date: Fri, 27 Nov 2015 17:32:06 +0100
Message-ID: <CAPmG0jbkRVHx=Z4RjQDaGJ72XmEUJY=n1BZuaE4k1wFBE8V_5g@mail.gmail.com>
Subject: Re: btrfs check help
From: Henk Slager <eye1tm@gmail.com>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My experience/interpretation of the 2 checks is that it is OK, see
some more comments inserted below. Hopefully a developer of
btrfs-progs can comment in more detail.

> [root@3dcpc5 ~]# btrfs check --repair /dev/sdk
> enabling repair mode
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
This might be there because of the crash earlier, but a cache
invalidation should not be a problem.
> checking fs roots
> reset nbytes for ino 1341670 root 5
> reset nbytes for ino 1341670 root 11406
At least the nbytes error seems to be fixed.
> warning line 3653
> checking csums
> checking root refs
> found 19343374874998 bytes used err is 0
> total csum bytes: 18863243900
> total tree bytes: 27413118976
> total fs tree bytes: 4455694336
> total extent tree bytes: 3077373952
> btree space waste bytes: 2882193883
> file data blocks allocated: 19461564538880
>  referenced 20155355832320

The second readonly check partly can't deal with the just invalidated
space cache I think (I assume you haven't mounted and/or/ used
read-write the filesystem in between), but even if the space cache
wouldn't be touched in the --repair check, my experience is that those
errors, like in dmesg on my system:
[38018.645187] BTRFS info (device sdi): The free space cache file
(6258971115520) is invalid. skip it
   will disappear over time when the filesystem is filled/used.
This particular error is from a backup fs where one disk had gone bad.
A btrfs replace still worked and just after that, I saw many of those
errors, but now after a few weeks they are mostly gone. I did not
explicitly unmount or check--repair the fs, I just had to reboot the
system for another reason.
Your kernel+tools is new enough, you probably want to have a look at
the 'Space cache control' options on the wiki:
https://btrfs.wiki.kernel.org/index.php/Mount_options
  before you decide what to do.

> root@3dcpc5 ~]# btrfs check /dev/sdk
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents
> checking free space cache
> block group 53328591454208 has wrong amount of free space
> failed to load free space cache for block group 53328591454208
> block group 53329665196032 has wrong amount of free space
> failed to load free space cache for block group 53329665196032
> Wanted offset 58836887044096, found 58836887011328
> Wanted offset 58836887044096, found 58836887011328
> cache appears valid but isnt 58836887011328
> Wanted offset 60505481887744, found 60505481805824
> Wanted offset 60505481887744, found 60505481805824
> cache appears valid but isnt 60505481805824
> Wanted bytes 16384, found 81920 for off 60979001966592
> Wanted bytes 1073725440, found 81920 for off 60979001966592
> cache appears valid but isnt 60979001950208
> Wanted offset 61297908056064, found 61297908006912
> Wanted offset 61297908056064, found 61297908006912
> cache appears valid but isnt 61297903271936
> Wanted bytes 32768, found 16384 for off 61711301296128
> Wanted bytes 1066319872, found 16384 for off 61711301296128
> cache appears valid but isnt 61711293874176
> There is no free space entry for 62691824041984-62691824058368
> There is no free space entry for 62691824041984-62692693901312
> cache appears valid but isnt 62691620159488
> There is no free space entry for 63723505205248-63723505221632
> There is no free space entry for 63723505205248-63724559794176
> cache appears valid but isnt 63723486052352
> Wanted bytes 32768, found 16384 for off 64746920902656
> Wanted bytes 914849792, found 16384 for off 64746920902656
> cache appears valid but isnt 64746762010624
> There is no free space entry for 65770368401408-65770368434176
> There is no free space entry for 65770368401408-65771111710720
> cache appears valid but isnt 65770037968896
> Wanted offset 66758954270720, found 66758954221568
> Wanted offset 66758954270720, found 66758954221568
> cache appears valid but isnt 66758954188800
> block group 70204591702016 has wrong amount of free space
> failed to load free space cache for block group 70204591702016
> block group 70205665443840 has wrong amount of free space
> failed to load free space cache for block group 70205665443840
> block group 70206739185664 has wrong amount of free space
> failed to load free space cache for block group 70206739185664
> Wanted offset 70216543715328, found 70216543698944
> Wanted offset 70216543715328, found 70216543698944
> cache appears valid but isnt 70216537079808
> Wanted offset 71025067474944, found 71025067409408
> Wanted offset 71025067474944, found 71025067409408
> cache appears valid but isnt 71025064673280
> Wanted offset 71455641354240, found 71455641337856
> Wanted offset 71455641354240, found 71455641337856
> cache appears valid but isnt 71455635144704
> block group 71662867316736 has wrong amount of free space
> failed to load free space cache for block group 71662867316736
> block group 71663941058560 has wrong amount of free space
> failed to load free space cache for block group 71663941058560
> There is no free space entry for 72725872967680-72725872984064
> There is no free space entry for 72725872967680-72726945464320
> cache appears valid but isnt 72725871722496
> block group 73207981801472 has wrong amount of free space
> failed to load free space cache for block group 73207981801472
> found 19343374940534 bytes used err is -22
> total csum bytes: 18863243900
> total tree bytes: 27413184512
> total fs tree bytes: 4455727104
> total extent tree bytes: 3077406720
> btree space waste bytes: 2882234096
> file data blocks allocated: 19461573357568
>  referenced 20155367563264
