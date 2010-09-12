From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH] Btrfs: Remove useless condition
Date: Sun, 12 Sep 2010 19:26:10 +0530
Message-ID: <AANLkTinPWd2bavC_44WkEL++KXirZ1CW3dTNK7G-Oag=@mail.gmail.com>
References: <1284289340.2650.2.camel@ht.satnam>
	<20100912122955.GA28839@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100912122955.GA28839@cmpxchg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On Sun, Sep 12, 2010 at 5:59 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Sun, Sep 12, 2010 at 04:32:20PM +0530, Jaswinder Singh Rajput wrote:
>>
>> if (ret) is useless as it will be never NULL as in previous statement
>> we are setting ret = prev for !ret
>
> If there is no match and no extent below the given file offset, `prev'
> will be NULL as well, no?
>
> So the check is not useless, it prevents throwing out a cached success
> in case of a lookup failure.
>

Got it !!

Thanks,
--
Jaswinder Singh.
