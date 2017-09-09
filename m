Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:37178 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757293AbdIILNp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Sep 2017 07:13:45 -0400
Subject: Re: generic name for volume and subvolume root?
To: Hugo Mills <hugo@carfax.org.uk>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, framstag@rus.uni-stuttgart.de
References: <20170909083551.GC22060@rus.uni-stuttgart.de>
 <48008a58-a82e-d9f7-327e-eeb905e18aa1@gmx.com>
 <20170909104845.GW12642@rus.uni-stuttgart.de>
 <9911ae20-6181-5ce2-0374-e601a1034c4a@gmx.com>
 <20170909110632.GG23980@carfax.org.uk>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <ba9271bc-ab4a-59eb-623c-dbfe6018d987@mendix.com>
Date: Sat, 9 Sep 2017 13:13:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170909110632.GG23980@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2017 01:06 PM, Hugo Mills wrote:
> On Sat, Sep 09, 2017 at 06:58:38PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年09月09日 18:48, Ulli Horlacher wrote:
>>> On Sat 2017-09-09 (18:40), Qu Wenruo wrote:
>>>
>>>>> Is there a generic name for both volume and subvolume root?
>>>>
>>>> Nope, subvolume (including snapshot) is not distinguished by its
>>>> filename/path/directory name.
>>>>
>>>> And you can only do snapshot on subvolume (snapshot is one kind of
>>>> subvolume) boundary.
>>>
>>> So, I can name a btrfs root volume also btrfs subvolume?
>>
>> Yes, root volume is also a subvolume, so just call "btrfs root volume"
>> a "subvolume".
> 
>    I find it's best to avoid the word "root" entirely, as it's got
> several meanings, and it tends to get confusing in conversation.
> Instead, we have:
> 
>  - "the top level" (subvolid=5)
>  - "/"             (what you see at / in your running system)
>  - "<top-level>/@" or similar names
>                    (the subvolume that's mounted at /)
> 
>>> I am talking about documentation, not coding!
>>>
>>> I just want yo use the correct terms.
>>
>> If you're referring to the term, I think subvolume is good enough.
>> Which represents your original term, "directories one can snapshot".
>>
>>
>> For the whole btrfs "volume", I would just call it "filesystem" to
>> avoid the name "volume" or "subvolume" at all.
> 
>    Yes, it's a filesystem. (Although that does occasionally cause
> confusion between "the conceptual filesystem implemented by btrfs.ko"
> and "the concrete filesystem stored on /dev/sda1", but it's generally
> far less confusing than the overloading of "root").

Yes, because every subvolume is a filesystem root! :-D

https://i.imgur.com/2VzmC.gif

-- 
Hans van Kranenburg
