From: Liuwenyi <qingshenlwy@gmail.com>
Subject: Re: [PATCH] Avoid a NULL pointer in btrfs
Date: Thu, 20 Jan 2011 20:26:15 +0800
Message-ID: <4D3829E7.9050305@gmail.com>
References: <4D36F04D.70505@gmail.com> <20110119141334.GA2544@localhost.localdomain> <1295452288-sup-8924@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Josef Bacik <josef@redhat.com>, strongzgy <strongzgy@gmail.com>,
	onlyflyer <onlyflyer@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	ak <ak@linux.intel.com>, akpm <akpm@linux-foundation.org>,
	miaox <miaox@cn.fujitsu.com>,
	Yang Ruirui <ruirui.r.yang@tieto.com>,
	meego-kernel <meego-kernel@meego.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295452288-sup-8924@think>
List-ID: <linux-btrfs.vger.kernel.org>

=E4=BA=8E 2011-1-19 23:52, Chris Mason =E5=86=99=E9=81=93:
> Excerpts from Josef Bacik's message of 2011-01-19 09:14:02 -0500:
>> On Wed, Jan 19, 2011 at 10:08:13PM +0800, Liuwenyi wrote:
>>> In Yang Ruirui's mail, the btrfs will create a oops. This is caused=
 by a
>>> null pointer in test_range_bit() while lock the spinlock.
>>>
>>> So, It is necessary to add a pointer check into test_range_bit()
>>>
>>
>> NAK, the tree shouldn't be null coming into this function, something=
 else is
>> going wrong.  What oops is this?  Thanks,
The mail is here http://lkml.org/lkml/2011/1/19/24

another mesg is here http://www.aei.mpg.de/~crmafra/dmesg-2.6.35.3.txt
> What was your metadata blocksize for this oops?  This call should nev=
er
> happen.
It is rare and hard to reproduced. So, I update this patch, just avoid =
a=20
null pointer calling.
> I think there is a larger problem, probably in the IO error handling
> code since the trace had io errors beforehand.
Yes, I agree. This situation is too strange to happen.
> -chris
---
Best Regards,
Liu Wenyi
