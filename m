Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f174.google.com ([74.125.82.174]:36028 "EHLO
        mail-ot0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934638AbdLSD01 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 22:26:27 -0500
Received: by mail-ot0-f174.google.com with SMTP id d5so15345353oti.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Dec 2017 19:26:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a076c7ff-87e3-b18c-c046-ff4912e277c4@cn.fujitsu.com>
References: <CAJCQCtScin-9AomqOwiSTwj=5rCeJW12jv8rv8taxwUq+AX5Lw@mail.gmail.com>
 <b580f4c4-3eb0-9203-75b5-c918f15d12cf@cn.fujitsu.com> <CAJCQCtRuaWb2_EHiiKzk7iWhMoLno6F-O+J42hqsgYif5AEVew@mail.gmail.com>
 <a076c7ff-87e3-b18c-c046-ff4912e277c4@cn.fujitsu.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 18 Dec 2017 20:26:26 -0700
Message-ID: <CAJCQCtSv4kCwOFHjbEdyuCbwBKdso4hLPJiejf7VsM5DwuyP6g@mail.gmail.com>
Subject: Re: btrfs check lowmem crash, backref.c:466: __add_missing_keys:
 Assertion `ref->root_id` failed
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 18, 2017 at 7:19 PM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:
>
>
> On 12/19/2017 09:34 AM, Chris Murphy wrote:
>>
>> On Sun, Dec 17, 2017 at 8:07 PM, Su Yue <suy.fnst@cn.fujitsu.com>
>> wrote:
>>>
>>> Hi,
>>>
>>> On 12/18/2017 10:50 AM, Chris Murphy wrote:
>>>>
>>>>
>>>> This is v4.14.
>>>>
>>>> I've filed a bug which contains the build steps, versions. It's crashing
>>>> on all volumes I try it on so far.
>>>>
>>>>
>>>
>>> It was fixed by Qu's patch btrfs-progs: backref: Allow backref walk
>>> to handle direct parent ref which is available on his github
>>> https://github.com/adam900710/btrfs-progs/tree/lowmem_fix
>>>
>> OK that fixed the crashing problem on all tested volumes. One volume so
>> far has a bunch of these:
>>
>> ERROR: data extent[1218774720512 167936] backref lost
>>
>
> Did you apply all patches on this branch?

Yes, I think so:

git


> If only the patch mentioned above is applied, you can try another
> patch named
>  btrfs-progs: lowmem check: Fix false backref lost warning for keyed
>     extent data ref
> which exists in same branch.
>
> Otherwise, it seems a bug of lowmem check. Would you please
> provide some dump of btrfs-debug-tree?
>
> # btrfs-debug-tree /$device  |\
>   grep -C10 1218774720512
>

There are two errors repeated many times:

ERROR: data extent[1214681899008 21139456] backref lost
ERROR: data extent[1218774720512 167936] backref lost

URLs for both:

https://drive.google.com/open?id=1hdgjYZg-QFeVbT_xVUxlZRC9Q0PP29eS
https://drive.google.com/open?id=1zomVGrtw6TX6ZNL5QmBn4nhgV4OgUI92


-- 
Chris Murphy
