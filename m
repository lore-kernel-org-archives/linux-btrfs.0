Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:56271 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754322AbdCMUA4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 16:00:56 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: Home storage with btrfs
To: Peter Becker <floyd.net@gmail.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: =?UTF-8?Q?H=c3=a9rikz_Nawarro?= <herikz.nawarro@gmail.com>,
        Juan Orti Alcaine <j.orti.alcaine@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAD6NJSwaqHD+6KFRhxwHCyc_N72KuHzzOJRf2g-fuDqZo7PHDA@mail.gmail.com>
 <CAC+fKQU7XAJ4QqzG3Ug4fwZb3N7hvYANnfjQa+nXDku2M1x8VQ@mail.gmail.com>
 <b7e7719c-ad05-a436-0e38-6c0a1dea36c5@gmail.com>
 <CAEtw4r3CajRmvQXnDkOR6LzP-CHn7-8=_dQPc5Yw7NUZqg4zww@mail.gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <a7a807c7-f8e2-af39-4b1b-11ad5c487d7b@dirtcellar.net>
Date: Mon, 13 Mar 2017 21:00:26 +0100
MIME-Version: 1.0
In-Reply-To: <CAEtw4r3CajRmvQXnDkOR6LzP-CHn7-8=_dQPc5Yw7NUZqg4zww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same here, Have been using BTRFS for a 'scratch' disk since about 2014.
The disk have had quite some abuse and no issues yet.
I don't use compression, snapshots or any fancy features.
I have recently moved all of the root filesystem to BTRFS with 5x SSD 
disks set up in RAID1 and everything is (still) working fine, and I have 
been shuffling large amounts of data on this volume. I bet the SSD's 
will break before BTRFS does, so the real test is yet to come I guess...
I am on Debian GNU/Linux with kernel 4.9.0-2-amd64 (Debian 4.9.13-1) - 
btrfs-progs 4.7.3

However, keep in mind that backups is winning the fight against binary 
related traumas :)

Peter Becker wrote:
> I can confirm this. I have also no generell issues since the past 2
> years with BTRFS in RAID1 and 6 Disks with different sizes and also no
> issues with the DUP profile on a single disk.
> Only some performance issues with deduplication and very large files.
> But i also recommand to use a newer kernel (4.4 or higher) or better
> the newest and build a newer version of btrfs progs form source.
> I use Ubuntu 16.04 and kernel 4.9 + btrfs progs 4.9 currently.
>
> 2017-03-13 13:02 GMT+01:00 Austin S. Hemmelgarn <ahferroin7@gmail.com>:
>> On 2017-03-13 07:52, Juan Orti Alcaine wrote:
>>> 2017-03-13 12:29 GMT+01:00 Hérikz Nawarro <herikz.nawarro@gmail.com>:
>>>> Hello everyone,
>>>>
>>>> Today is safe to use btrfs for home storage? No raid, just secure
>>>> storage for some files and create snapshots from it.
>>>>
>>> In my humble opinion, yes. I'm running a RAID1 btrfs at home for 5
>>> years and I feel the most serious bugs have been fixed, because in the
>>> last two years I have not experienced any issue.
>> In general, I'd agree.  I've not seen any issues resulting from BTRFS itself
>> for the past 2.5 years (although it's helped me find quite a lot of marginal
>> or failing hardware over that time), but I've also not used many of the less
>> stable features (raid56, qgroups, and a handful of other things).
>>
>> One piece of advice I will give though, try to keep the total number of
>> snapshots to a reasonably small three digit number (ideally less than 200,
>> absolutely less than 300), otherwise performance is going to be horrible.
>>>
>>> Anyway, keeping your kernel and btrfs-progs updated is a must, and of
>>> course, having good backups. I'm using Fedora and it's fine.
>> Also agreed, Fedora is one of the best options for a traditional distro
>> (they're very good about staying up to date and back-porting bug-fixes from
>> the upstream kernel).  The other two I'd recommend are Arch (they actually
>> use an almost upstream kernel and are generally the first distro to have new
>> versions of any arbitrary software) and Gentoo (similar to Arch, but more
>> maintenance intensive (although also more efficient (usually))).
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

