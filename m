Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:47216 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933349AbdKBLVw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 07:21:52 -0400
Received: by mail-io0-f173.google.com with SMTP id h70so13118159ioi.4
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 04:21:52 -0700 (PDT)
Subject: =?UTF-8?Q?Re:_Parity-based_redundancy_=28RAID5/6/triple_parity_and_?=
 =?UTF-8?Q?beyond=29_on_BTRFS_and_MDADM_=28Dec_2014=29_=e2=80=93_Ronny_Egner?=
 =?UTF-8?Q?s_Blog?=
To: ronnie sahlberg <ronniesahlberg@gmail.com>, Dave <davestechshop@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAH=dxU4vj_+_K9dE3hqMf42oC9wEJKXTPRDr6QyOjrQfEXmXXA@mail.gmail.com>
 <CAN05THRy7tnmY__obtgjkT76kKcR-_YWHcfDgdwLDf1A2qY0+w@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2560b19a-3a1d-6ea5-fd83-f5b154200b50@gmail.com>
Date: Thu, 2 Nov 2017 07:21:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAN05THRy7tnmY__obtgjkT76kKcR-_YWHcfDgdwLDf1A2qY0+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-02 03:29, ronnie sahlberg wrote:
> I think it is just a matter of lack of resources.
> The very few paid resources to work on btrfs probably does not have
> priority to work on parity raid.
> (And honestly, parity raid is probably much better implemented below
> the filesystem in any case, i.e. in say the md driver or the array
> itself).
More specifically, they likely don't have incentive to work on higher 
order parity raid.  The common case for most of the paid developers 
companies is running large scale storage using BTRFS as a back-end.  In 
such a situation, it makes more sense to use smaller BTRFS volumes in 
raid5 or raid6 mode (or even raid1 or raid10), and handle striping at 
the cluster level instead of the node level.
> 
> Also, until at least about a year ago, RAID56 was known to be
> completely broken in btrfs and would destroy all your data.
> Not a question of when, but if.
> 
> So, considering the state of parity raid in btrfs it is understandable
> if the few resources available would not work on Andrea's 6 parity
> raid code.
> I don't follow the parity raid code in btrfs closely, it might be
> fixed by now or it might still be pathologically broken. I don't know.
> I assume it is still deadly to use btrfs raid5/6.
AFAIK, it's better than it was, but it's still broken.>
> That said, that the MDADM folks did not pick up on Andrea's work is a tragedy.
> While it is really just Reed-Solomon coding, his breakthrough was that
> he found a 6 parity Reed-Solomon encoding  where the first two
> parities
> were identical to the RAID5/6 parities.
> I.e. you could add a third parity to a normal RAID6 and thus create a
> 3-parity system without having to recompute the first and second
> parity.
> 
> 
> 
> 
> On Thu, Nov 2, 2017 at 12:45 PM, Dave <davestechshop@gmail.com> wrote:
>> Has this been discussed here? Has anything changed since it was written?
>>
>> Parity-based redundancy (RAID5/6/triple parity and beyond) on BTRFS
>> and MDADM (Dec 2014) – Ronny Egners Blog
>> http://blog.ronnyegner-consulting.de/2014/12/10/parity-based-redundancy-raid56triple-parity-and-beyond-on-btrfs-and-mdadm-dec-2014/comment-page-1/
>>
>> TL;DR: There are patches to extend the linux kernel to support up to 6
>> parity disks but BTRFS does not want them because it does not fit
>> their “business case” and MDADM would want them but somebody needs to
>> develop patches for the MDADM component. The kernel raid
>> implementation is ready and usable. If someone volunteers to do this
>> kind of work I would support with equipment and myself as a test
>> resource.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

