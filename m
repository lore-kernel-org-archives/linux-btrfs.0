Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38139 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbbK0UZT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 15:25:19 -0500
Received: by igbxm8 with SMTP id xm8so36554121igb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 12:25:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3E0A8132-7121-482F-BAAC-BAC6D18661AC@up4.com>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
	<5654C86C.9080800@gmail.com>
	<20151124203210.GR24333@carfax.org.uk>
	<B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com>
	<56566416.5000405@cn.fujitsu.com>
	<4EF3E931-9089-40FB-8E8E-1928539D39D4@up4.com>
	<3E0A8132-7121-482F-BAAC-BAC6D18661AC@up4.com>
Date: Fri, 27 Nov 2015 13:25:19 -0700
Message-ID: <CAJCQCtQ-0mA0fPL2EEupAcid++OA3xXavOPQT_80Dkm-yNy-BA@mail.gmail.com>
Subject: Re: btrfs check help
From: Chris Murphy <lists@colorremedies.com>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 27, 2015 at 4:25 AM, Vincent Olivier <vincent@up4.com> wrote:
>
> [root@3dcpc5 ~]# btrfs check --repair /dev/sdk
> enabling repair mode
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> reset nbytes for ino 1341670 root 5
> reset nbytes for ino 1341670 root 11406
> warning line 3653


I'm not sure what that last line means.



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


Except for the bytes used err is -22, I think this is just
acknowledging that the space caches are invalid, i.e. not a surprise.
It should get rebuilt at mount time, depending on the size of the file
system, it might take a while (?).


-- 
Chris Murphy
