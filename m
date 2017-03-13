Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33599 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdCMNJG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 09:09:06 -0400
Received: by mail-oi0-f44.google.com with SMTP id 2so76894673oif.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 06:09:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b7e7719c-ad05-a436-0e38-6c0a1dea36c5@gmail.com>
References: <CAD6NJSwaqHD+6KFRhxwHCyc_N72KuHzzOJRf2g-fuDqZo7PHDA@mail.gmail.com>
 <CAC+fKQU7XAJ4QqzG3Ug4fwZb3N7hvYANnfjQa+nXDku2M1x8VQ@mail.gmail.com> <b7e7719c-ad05-a436-0e38-6c0a1dea36c5@gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Mon, 13 Mar 2017 14:09:05 +0100
Message-ID: <CAEtw4r3CajRmvQXnDkOR6LzP-CHn7-8=_dQPc5Yw7NUZqg4zww@mail.gmail.com>
Subject: Re: Home storage with btrfs
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: =?UTF-8?Q?H=C3=A9rikz_Nawarro?= <herikz.nawarro@gmail.com>,
        Juan Orti Alcaine <j.orti.alcaine@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can confirm this. I have also no generell issues since the past 2
years with BTRFS in RAID1 and 6 Disks with different sizes and also no
issues with the DUP profile on a single disk.
Only some performance issues with deduplication and very large files.
But i also recommand to use a newer kernel (4.4 or higher) or better
the newest and build a newer version of btrfs progs form source.
I use Ubuntu 16.04 and kernel 4.9 + btrfs progs 4.9 currently.

2017-03-13 13:02 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
> On 2017-03-13 07:52, Juan Orti Alcaine wrote:
>>
>> 2017-03-13 12:29 GMT+01:00 Hérikz Nawarro <herikz.nawarro@gmail.com>:
>>>
>>> Hello everyone,
>>>
>>> Today is safe to use btrfs for home storage? No raid, just secure
>>> storage for some files and create snapshots from it.
>>>
>>
>> In my humble opinion, yes. I'm running a RAID1 btrfs at home for 5
>> years and I feel the most serious bugs have been fixed, because in the
>> last two years I have not experienced any issue.
>
> In general, I'd agree.  I've not seen any issues resulting from BTRFS itself
> for the past 2.5 years (although it's helped me find quite a lot of marginal
> or failing hardware over that time), but I've also not used many of the less
> stable features (raid56, qgroups, and a handful of other things).
>
> One piece of advice I will give though, try to keep the total number of
> snapshots to a reasonably small three digit number (ideally less than 200,
> absolutely less than 300), otherwise performance is going to be horrible.
>>
>>
>> Anyway, keeping your kernel and btrfs-progs updated is a must, and of
>> course, having good backups. I'm using Fedora and it's fine.
>
> Also agreed, Fedora is one of the best options for a traditional distro
> (they're very good about staying up to date and back-porting bug-fixes from
> the upstream kernel).  The other two I'd recommend are Arch (they actually
> use an almost upstream kernel and are generally the first distro to have new
> versions of any arbitrary software) and Gentoo (similar to Arch, but more
> maintenance intensive (although also more efficient (usually))).
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
