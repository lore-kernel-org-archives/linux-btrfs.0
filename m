Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19449 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751383AbbLNAyT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Dec 2015 19:54:19 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Laurent Bonnaud <L.Bonnaud@laposte.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net> <5654F6BC.8020900@gmx.com>
 <565579DB.2040105@laposte.net> <56607848.5040705@laposte.net>
 <5660E2BD.3050000@cn.fujitsu.com> <566ADBF6.9090507@laposte.net>
CC: Lukas Pirl <btrfs@lukas-pirl.de>, <linux-btrfs@vger.kernel.org>,
        <calestyo@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566E130D.105@cn.fujitsu.com>
Date: Mon, 14 Dec 2015 08:53:33 +0800
MIME-Version: 1.0
In-Reply-To: <566ADBF6.9090507@laposte.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Laurent Bonnaud wrote on 2015/12/11 15:21 +0100:
> On 04/12/2015 01:47, Qu Wenruo wrote:
>
>> [run btrfsck]
>
> I did that, too with an old btrfsck version (4.0) and it found the following errors.
> Then I did a btrfsck --repair, and I have been able to complete my "du -s" test.
> The next step will we to run a "btrfs scrub" to check if data loss did happen...

Glad to hear that btrfsck --repair can fix it.
It seems to be space cache problem, and normally mount with -o 
clearcache should handle it.
But btrfsck --repair should also handle it well.

Thanks,
Qu

>
> # btrfsck /dev/sdb1
> Checking filesystem on /dev/sdb1
> UUID: f6d4db2e-962b-42db-87b1-35064a4d38e0
> checking extents
> checking free space cache
> block group 314635714560 has wrong amount of free spacefailed to load free space cache for block group 314635714560
> There is no free space entry for 353290420224-353290764288
> There is no free space entry for 353290420224-353827291136
> cache appears valid but isnt 353290420224
> There is no free space entry for 541732175872-541732208640
> There is no free space entry for 541732175872-542268981248
> cache appears valid but isnt 541732110336
> Wanted bytes 32768, found 262144 for off 1008273178624
> Wanted bytes 536625152, found 262144 for off 1008273178624
> cache appears valid but isnt 1008272932864
> block group 1475887497216 has wrong amount of free spacefailed to load free space cache for block group 1475887497216
> block group 1823242977280 has wrong amount of free spacefailed to load free space cache for block group 1823242977280
> There is no free space entry for 1827001073664-1827002810368
> There is no free space entry for 1827001073664-1827537944576
> cache appears valid but isnt 1827001073664
> There is no free space entry for 1969305501696-1969305518080
> There is no free space entry for 1969305501696-1969842290688
> cache appears valid but isnt 1969305419776
> There is no free space entry for 2021381947392-2021381963776
> There is no free space entry for 2021381947392-2021918769152
> cache appears valid but isnt 2021381898240
> There is no free space entry for 2027287478272-2027287724032
> There is no free space entry for 2027287478272-2027824349184
> cache appears valid but isnt 2027287478272
> There is no free space entry for 2143889227776-2143889244160
> There is no free space entry for 2143889227776-2144426000384
> cache appears valid but isnt 2143889129472
> found 1977224107644 bytes used err is -22
> total csum bytes: 1925245108
> total tree bytes: 5773115392
> total fs tree bytes: 3504685056
> total extent tree bytes: 156975104
> btree space waste bytes: 780048699
> file data blocks allocated: 1971884707840
>   referenced 1971875930112
> btrfs-progs v4.0
>


