Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:34952 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdCDEqL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2017 23:46:11 -0500
Received: by mail-yw0-f177.google.com with SMTP id v198so7307380ywc.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Mar 2017 20:45:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRJaNNFtE4Y7RAsgoD55F78HG_gyMxfkjVusrdYXFVDLw@mail.gmail.com>
References: <CAJCQCtQByC_pTnZhFFfHmxktN-Ga4W0TZ8wVRPxe_b18G+Kajw@mail.gmail.com>
 <pan$a4f49$5a6ddd0a$2183c48a$5df333ac@cox.net> <22712.48434.400550.346157@tree.ty.sabi.co.uk>
 <CAJCQCtSwBZKiZWA83dv_bvra1548eRtHJy7Gbqsbs_Hy56aSGw@mail.gmail.com>
 <bcb4b84b-2ae1-cf02-33e5-6ca17ae18840@cn.fujitsu.com> <CAJCQCtRJaNNFtE4Y7RAsgoD55F78HG_gyMxfkjVusrdYXFVDLw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 3 Mar 2017 21:38:32 -0700
Message-ID: <CAJCQCtQujYXy39oXTCD4ZS-ALmyGZDbjJFkrmiKo2MDwTSgFPA@mail.gmail.com>
Subject: Re: raid1 degraded mount still produce single chunks, writeable mount
 not allowed
To: Chris Murphy <lists@colorremedies.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 2, 2017 at 6:48 PM, Chris Murphy <lists@colorremedies.com> wrote:

>
> Again, my data is fine. The problem I'm having is this:
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/Documentation/filesystems/btrfs.txt?id=refs/tags/v4.10.1
>
> Which says in the first line, in part, "focusing on fault tolerance,
> repair and easy administration" and quite frankly this sort of
> enduring bug in this file system that's nearly 10 years old now, is
> rendered misleading, and possibly dishonest. How do we describe this
> file system as focusing on fault tolerance when, in the identical
> scenario using mdadm or LVM raid, the user's data is not mishandled
> like it is on Btrfs with multiple devices?


I think until these problems are fixed, the Btrfs status page should
describe RAID 1 and 10 as mostly OK, with this problem as the reason
for it not being OK.

-- 
Chris Murphy
