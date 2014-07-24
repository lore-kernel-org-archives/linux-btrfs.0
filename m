Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:61312 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbaGXWvR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 18:51:17 -0400
Received: by mail-ig0-f173.google.com with SMTP id h18so64501igc.12
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 15:51:17 -0700 (PDT)
Message-ID: <53D18DE3.5080605@gmail.com>
Date: Thu, 24 Jul 2014 17:51:15 -0500
From: Kevin Brandstatter <icarusthecow@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>, Chris Mason <clm@fb.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] "Quota Ignored On write" problem still exist with 3.16-rc5
References: <53C8DEB0.1060404@jp.fujitsu.com> <53C8F720.4040803@cn.fujitsu.com> <53CF077D.4000106@jp.fujitsu.com> <53CFB74B.8080607@fb.com>
In-Reply-To: <53CFB74B.8080607@fb.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 07/23/2014 08:23 AM, Josef Bacik wrote:
> On 07/22/2014 08:53 PM, Satoru Takeuchi wrote:
>> Hi Wang,
>>
>> (2014/07/18 19:29), Wang Shilong wrote:
>>> On 07/18/2014 04:45 PM, Satoru Takeuchi wrote:
>>>> Hi Josef, Chris,
>>>>
>>>> I found "Quota Ignored On write" problem still exist with 3.16-rc5,
>>>> which Kevin reported before.
>>>>
>>>> Kevin's report:
>>>> https://urldefense.proofpoint.com/v1/url?u=https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg35292.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=HiJFypfWVhg2Jy2US%2BNG1tF8q4%2BYUryNKec6yPkYJM4%3D%0A&s=9d1740f5e1701e4906fc04b77d9117052e84d6e16c30971b261d1acf41c10910
>>>>
>>>> The result of bisect:
>>>> https://urldefense.proofpoint.com/v1/url?u=https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg35304.html&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=HiJFypfWVhg2Jy2US%2BNG1tF8q4%2BYUryNKec6yPkYJM4%3D%0A&s=75ca6ce24c6d8e64fccdb8f61e519c59b1c6d027140c4f0f5eac24942a53a55d
>>> I guess this is because Josef's patch delayed qgroup accounting, it will
>>> cause @refer and @excl updating very late...
>>>
>>> The patch maybe optimize to merge some delayed refs(for example), but
>>> it updates qgroup accounting when commiting transaction which will be
>>> very late,
>>> we may have accumulated many data..
>> Thank you for your comment. I know of the code logic which caused
>> this problem. However, what I want to say here is that this
>> problem should be fixed as soon as possible. It is a important
>> regression problem and we've already know the root cause.
>>
>> If it's impossible to fix it by releasing 3.16, I consider this
>> patch should be reverted.
>>
> That's not happening.  Qgroups have always been broken in one way or
> another, now with my stuff the accounting is always correct and we don't
> have a huge performance impact with or without qgroups.  We'll fix it
> but there's no way we're reverting this work.  Thanks,
>
> Josef
>
How/when does the accounting happen? Obviously we want the accounting to
be correct, but the overrun seems to indicate that the accounting isn't
happening early enough. From briefly looking at the patches, it looks to
be that the intent is to account when a new extent is allocated, but it
seems that this isn't happening if its still allowed to allocate post
quota, or is the accounting postponed till after a specified time, etc?

-Kevin
