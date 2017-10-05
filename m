Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:48367 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbdJEA5g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Oct 2017 20:57:36 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 90924AC03CF
        for <linux-btrfs@vger.kernel.org>; Thu,  5 Oct 2017 09:57:33 +0900 (JST)
Subject: Re: [PATCH v2] btrfs-progs: subvol: change subvol set-default to also
 accept subvol path
To: <dsterba@suse.cz>, Hugo Mills <hugo@carfax.org.uk>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5008967a-9da9-ad91-65e9-bcfbfb07feb0@jp.fujitsu.com>
 <CAA91j0WQ35e5KaZAEe_amwuDMazuAa6Mx1y3P18Y7EGvpxmAHQ@mail.gmail.com>
 <20171002090129.GB3293@carfax.org.uk>
 <45a84df9-fd06-ca72-3379-4594fceb4b5a@jp.fujitsu.com>
 <20171004180710.GF3521@twin.jikos.cz>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <22943aba-b9c5-b16b-755f-d0c795280d51@jp.fujitsu.com>
Date: Thu, 5 Oct 2017 09:57:25 +0900
MIME-Version: 1.0
In-Reply-To: <20171004180710.GF3521@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/10/05 3:07, David Sterba wrote:
> On Tue, Oct 03, 2017 at 08:57:52AM +0900, Misono, Tomohiro wrote:
>> On 2017/10/02 18:01, Hugo Mills wrote:
>>> On Mon, Oct 02, 2017 at 11:39:05AM +0300, Andrei Borzenkov wrote:
>>>> On Mon, Oct 2, 2017 at 11:19 AM, Misono, Tomohiro
>>>> <misono.tomohiro@jp.fujitsu.com> wrote:
>>>>> This patch changes "subvol set-default" to also accept the subvolume path
>>>>> for convenience.
>>>>>
>>>>> This is the one of the issue on github:
>>>>> https://github.com/kdave/btrfs-progs/issues/35
>>>>>
>>>>> If there are two args, they are assumed as subvol id and path to the fs
>>>>> (the same as current behavior), and if there is only one arg, it is assumed
>>>>> as the path to the subvolume. Therefore there is no ambiguity between subvol
>>>>> id and subvol name, which is mentioned in the above issue page.
>>>>>
>>>>> Only the absolute path to the subvolume is allowed, for the safety when
>>>>> multiple filesystems are used.
>>>>>
>>>>> subvol id is resolved by get_subvol_info() which is used by "subvol show".
>>>>>
>>>>> change to v2:
>>>>> restrict the path to only allow absolute path.
>>>>
>>>> This is absolutely arbitrary restriction. Why we can do "btrfs
>>>> subvolume create ./relative/path" but cannot do "btrfs subvolume
>>>> set-default ./relative/path"?
>>>
>>>    Indeed. In fact, it's precisely the _opposite_ of the way that
>>> every other command works -- you provide the path to the subvolume in
>>> the *current namespace*.
>>>
>>>    This approach would be just a major misfeature at this point.
>> Ok, I understood the point and want to revert this.
>> Please review the first version if possible:
>> https://mail-archive.com/linux-btrfs@vger.kernel.org/msg68486.html
> 
> I agree with Andrei and Hugo. We need to check that the subvolume path
> belongs to the filesystem anyway. I don't see that in the first version,
> so please fix it.
> 

I'm a bit confusing, but what is the meaning of "We need to check that the subvolume
path belongs to the filesystem"? Do you mean we should check whether the fs of current
directory and the fs of the subvolume specified are the same or not? However, current 
"set-default <id> <path>" does not check the <path> belong the same fs or not either.
Also, what if the subvolume is specified by absolute path?

