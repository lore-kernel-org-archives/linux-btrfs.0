Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc4s6.hotmail.com ([65.55.111.145]:55209 "EHLO
        BLU004-OMC4S6.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbcJNXII (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 19:08:08 -0400
From: Alberto Bursi <alberto.bursi@outlook.it>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Copy BTRFS volume to another BTRFS volume including subvolumes
 and snapshots
Date: Fri, 14 Oct 2016 22:58:56 +0000
Message-ID: <AM3PR08MB0642BADAFC2420A8F54C670392DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
References: <AM3PR08MB06423820D86D1E408FFD766492DC0@AM3PR08MB0642.eurprd08.prod.outlook.com>
 <905eb030-f8d8-b7cc-dd27-2f55e0d812c5@gmail.com>
 <AM3PR08MB06421C9E387257BB6945837C92DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
 <CAJCQCtTnoHrY3ZwkDY1HN6wavfduFKxKa94F6iVQtaKtR2aJ-w@mail.gmail.com>
In-Reply-To: <CAJCQCtTnoHrY3ZwkDY1HN6wavfduFKxKa94F6iVQtaKtR2aJ-w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/15/2016 12:17 AM, Chris Murphy wrote:
> It should be -e can accept a listing of all the subvolumes you want to
> send at once. And possibly an -r flag, if it existed, could
> automatically populate -e. But the last time I tested -e I just got
> errors.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=111221
>
>

Not a problem (for me anyway), I can send all subvolumes already with my 
script (one after another, but still automatically).

What I can't do with btrfs commands is to send over the contents of a ro 
snapshot of / called for example "oldRootSnapshot", directly to 
"/tmp/newroot" (which is where I have mounted the other drive/volume).

The only thing I can do is send over the subvolume as a subvolume.
So I end up with /tmp/newroot/oldRootSnapshot and inside oldRootSnapshot 
I get my root, not what I wanted.

Only way I found so far is using rsync to move the contents of 
oldRootSnapshot in the /tmp/newroot by setting an exclusion list for all 
subvolumes, then run a deduplication with duperemove.

So, is there something I missed to do that?

-Alberto
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
