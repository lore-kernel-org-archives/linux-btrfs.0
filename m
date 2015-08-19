Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55466 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750923AbbHSCtC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 22:49:02 -0400
Subject: Re: btrfs-image gets stuck, using 100%, looping on bad file
 descriptor
To: Timothy Normand Miller <theosib@gmail.com>
References: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
 <55D3DCA5.9070607@cn.fujitsu.com>
 <CAK7bmU_=JcjNT-tqcHmCTQNdFJdGqiCKptypC2c949eG_aAVqA@mail.gmail.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D3EE99.2000702@cn.fujitsu.com>
Date: Wed, 19 Aug 2015 10:48:57 +0800
MIME-Version: 1.0
In-Reply-To: <CAK7bmU_=JcjNT-tqcHmCTQNdFJdGqiCKptypC2c949eG_aAVqA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Timothy Normand Miller wrote on 2015/08/18 22:46 -0400:
> On Tue, Aug 18, 2015 at 9:32 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Hi Timothy,
>>
>> Although I have replied to the bugzilla, IMHO it's more appropriate to
>> discuss it in mail list, as it's not a kernel bug.
>>
>
> All four devices were online.  The "missing" one was a drive that
> died, which was replaced by a new one, but btrfs wouldn't finish the
> deletion of the missing device.
>
By replaced, did you mean "btrfs replace"? Or just change the physical 
disk without using "btrfs replace"?

Thanks,
Qu
