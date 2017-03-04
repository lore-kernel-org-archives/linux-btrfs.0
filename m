Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:51830 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdCDKGJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Mar 2017 05:06:09 -0500
Reply-To: waxhead@dirtcellar.net
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net>
 <22712.48434.400550.346157@tree.ty.sabi.co.uk>
 <CAJCQCtSwBZKiZWA83dv_bvra1548eRtHJy7Gbqsbs_Hy56aSGw@mail.gmail.com>
 <bcb4b84b-2ae1-cf02-33e5-6ca17ae18840@cn.fujitsu.com>
 <CAJCQCtRJaNNFtE4Y7RAsgoD55F78HG_gyMxfkjVusrdYXFVDLw@mail.gmail.com>
 <CAJCQCtQujYXy39oXTCD4ZS-ALmyGZDbjJFkrmiKo2MDwTSgFPA@mail.gmail.com>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <6bbc2561-3db3-8d7c-b039-0521c7b9b9ab@dirtcellar.net>
Date: Sat, 4 Mar 2017 10:55:35 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQujYXy39oXTCD4ZS-ALmyGZDbjJFkrmiKo2MDwTSgFPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy wrote:
> On Thu, Mar 2, 2017 at 6:48 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>> Again, my data is fine. The problem I'm having is this:
>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/Documentation/filesystems/btrfs.txt?id=refs/tags/v4.10.1
>>
>> Which says in the first line, in part, "focusing on fault tolerance,
>> repair and easy administration" and quite frankly this sort of
>> enduring bug in this file system that's nearly 10 years old now, is
>> rendered misleading, and possibly dishonest. How do we describe this
>> file system as focusing on fault tolerance when, in the identical
>> scenario using mdadm or LVM raid, the user's data is not mishandled
>> like it is on Btrfs with multiple devices?
>
> I think until these problems are fixed, the Btrfs status page should
> describe RAID 1 and 10 as mostly OK, with this problem as the reason
> for it not being OK.
>
I took the liberty of changing the status page...
