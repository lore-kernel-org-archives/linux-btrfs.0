From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH] Btrfs: Remove useless condition
Date: Sun, 12 Sep 2010 10:28:25 -0700
Message-ID: <AANLkTikhp0HvT2=2m9U__tqSxZbJmrbSDX+7_ZOddddt@mail.gmail.com>
References: <1284289340.2650.2.camel@ht.satnam>
	<20100912122955.GA28839@cmpxchg.org>
	<AANLkTinPWd2bavC_44WkEL++KXirZ1CW3dTNK7G-Oag=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinPWd2bavC_44WkEL++KXirZ1CW3dTNK7G-Oag=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 12, 2010 at 6:56 AM, Jaswinder Singh Rajput
<jaswinderlinux@gmail.com> wrote:
> Hello,
>
> On Sun, Sep 12, 2010 at 5:59 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> On Sun, Sep 12, 2010 at 04:32:20PM +0530, Jaswinder Singh Rajput wrote:
>>>
>>> if (ret) is useless as it will be never NULL as in previous statement
>>> we are setting ret = prev for !ret
>>
>> If there is no match and no extent below the given file offset, `prev'
>> will be NULL as well, no?
>>
>> So the check is not useless, it prevents throwing out a cached success
>> in case of a lookup failure.
>>
>
> Got it !!
>

Wouldn't it be clearer and easier to read if prev was checked directly
instead of checking ret after it becomes the same as prev?
