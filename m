Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:35316 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751847AbeAENOy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Jan 2018 08:14:54 -0500
Received: by mail-vk0-f68.google.com with SMTP id o73so3448121vkd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Jan 2018 05:14:53 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAGqmi77fkjuk-cvV4M8nvDs-yhygcvM8=J_vq=-kq9WwMfYHSw@mail.gmail.com>
References: <20171228152804.4645-1-nefelim4ag@gmail.com> <CAL3q7H5dZ7P-8UaOEUQERKM9Oa=8WcPysqo=Vc5RQEPjiC858w@mail.gmail.com>
 <CAGqmi77fkjuk-cvV4M8nvDs-yhygcvM8=J_vq=-kq9WwMfYHSw@mail.gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Fri, 5 Jan 2018 13:14:52 +0000
Message-ID: <CAL3q7H7s9+=0BmnXodKkhdj_mC7F3nT65pVrYDBpuk8jfVBX7g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: replace raid56 stripe bubble sort with insert sort
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 3, 2018 at 3:39 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> 2018-01-03 14:40 GMT+03:00 Filipe Manana <fdmanana@gmail.com>:
>> On Thu, Dec 28, 2017 at 3:28 PM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
>>> Insert sort are generaly perform better then bubble sort,
>>> by have less iterations on avarage.
>>> That version also try place element to right position
>>> instead of raw swap.
>>>
>>> I'm not sure how many stripes per bio raid56,
>>> btrfs try to store (and try to sort).
>>
>> If you don't know it, besides unlikely to be doing the best possible
>> thing here, you might actually make things worse or not offering any
>> benefit. IOW, you should know it for sure before submitting such
>> changes.
>>
>> You should know if the number of elements to sort is big enough such
>> that an insertion sort is faster than a bubble sort, and more
>> importantly, measure it and mention it in the changelog.
>> As it is, you are showing lack of understanding of the code and
>> component you are touching, and leaving many open questions such as
>> how faster this is, why insertion sort and not a
>> quick/merge/heap/whatever sort, etc.
>> --
>> Filipe David Manana,
>>
>> “Whether you think you can, or you think you can't — you're right.”
>
> Sorry, you are right,
> I must do some tests and investigations before send a patch.
> (I just try believe in some magic math things).
>
> Input size depends on number of devs,
> so on small arrays, like 3-5 no meaningful difference.
>
> Example: raid6 (with 4 disks) produce many stripe line addresses like:
> 1. 4641783808 4641849344 4641914880 18446744073709551614
> 2. 4641652736 4641718272 18446744073709551614 4641587200
> 3. 18446744073709551614 4636475392 4636540928 4636606464
> 4. 4641521664 18446744073709551614 4641390592 4641456128
>
> For that count of elements any sorting algo will work fast enough.
>
> Let's, consider that addresses as random non-repeating numbers.
>
> We can use tool like Sound Of Sorting (SoS) to make some
> easy to interpret tests of algorithms.

Nack.
My point was about testing in the btrfs code and not somewhere else.
We can all get estimations from CS books, websites, etc for multiple
algorithms for different input sizes. And these are typically
comparing the average case, and while some algorithms perform better
than others in the average case, things can get reversed in the worst
case (heap sort vs quick sort iirc, better in worst case but usually
worse in the average case).
What matters is in the btrfs context - that where things have to be measured.


>
> (Sorry, no script to reproduce, as SoS not provide a cli,
> just hand made by run SoS with different params).
>
> Table (also in attach with source data points):
> Sort_algo |Disk_num       |3   |4    |6    |8    |10    |12    |14    |AVG
> Bubble    |Comparasions   |3   |6    |15   |28   |45    |66    |91
> |36,2857142857143
> Bubble    |Array_Accesses |7,8 |18,2 |45,8 |81,8 |133,4 |192   |268,6 |106,8
> Insertion |Comparasions   |2,8 |5    |11,6 |17   |28,6  |39,4  |55,2  |22,8
> Insertion |Array_Accesses |8,4 |13,6 |31   |48,8 |80,4  |109,6 |155,8
> |63,9428571428571
>
> i.e. on Size like 3-4 no much difference,
> Insertion sort will work faster on bigger arrays (up to 1.7x for 14 disk array).
>
> Does that make a sense?
> I think yes, i.e. in any case that are several dozen machine instructions.
> Which can be used elsewhere.
>
> P.S. For heap sort, which are also available in kernel by sort(),
> That will to much overhead on that small number of devices,
> i.e. heap sort will show a profit over insert sort at 16+ cells in array.
>
> /* Snob mode on */
> P.S.S.
> Heap sort & other like, need additional memory,

Yes... My point in listing the heap sort and other algorithms was not
meant to propose using any of them but rather for you to explain why
insertion sort and not something else.
And I think you are confusing heap sort with merge sort. Merge sort is
the one that requires extra memory.

> so that useless to compare in our case,
> but they will works faster, of course.
> /* Snob mode off */
>
> Thanks.
> --
> Have a nice day,
> Timofey.



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
