Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58474 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbcBPBia (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 20:38:30 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: =?UTF-8?Q?=c3=81ngel_Gonz=c3=a1lez?= <angel@fs.16bits.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1447365063.7045.7.camel@scientia.net>
 <1455581697.6951.9.camel@fs.16bits.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56C27D8F.2000006@cn.fujitsu.com>
Date: Tue, 16 Feb 2016 09:38:23 +0800
MIME-Version: 1.0
In-Reply-To: <1455581697.6951.9.camel@fs.16bits.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Ángel González wrote on 2016/02/16 01:14 +0100:
> Hello everybody
>
> I have a btrfs filesystem [probably] created with btrfs-progs 4.3.1
> that is also spewing some hundred of thousand «bad extent [x, y), type
> mismatch with chunk» messages on btrfsck.

In fact, there is not only one false alert.

One related to 64K sector size one is fixed before 4.3.1.
But I assume that's not the case for you as only PPC64 and AArch64 may 
use 64K page size.

The latest false alert is fixed just after 4.3.1.

commit b08a740d7b797d870cbc3691b1291290d0815998
Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date:   Wed Nov 25 14:19:06 2015 +0800

     btrfs-progs: fsck: Fix a false alert where extent record has wrong 
metadata flag


So you may need to try v4.4 if your filesystem is created with 
non-skinny metadata.

>
> The data seems to be fine, so I expect it to be some kind of false
> positive. Still, there seems to be disagreement on the list on whether
> running btrfs --repair or not, plus I don't know if you may be
> interested in getting more information of this.

btrfs --repair won't help on this case, no matter if it is a false alert.

>
> Which should be my next steps?
>

Try btrfs-progs 4.4 to see if all these false alert goes a way.

Thanks,
Qu

>
> Kind regards
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


