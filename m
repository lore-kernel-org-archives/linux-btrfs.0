Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:33441 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966537AbdDSSKf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 14:10:35 -0400
Received: by mail-yb0-f173.google.com with SMTP id 81so11319727ybp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Apr 2017 11:10:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1af861c8-c4b6-5c8f-a7c1-d17f17f202b4@mendix.com>
References: <CAK5rZE4ko_xFr_Zv=bmZ4tR9X59jXaqFnTv16_ynEO0+E5uzeg@mail.gmail.com>
 <f5cb15a5-5566-b366-ebda-c3101fa96eec@gmail.com> <CAJCQCtS=xqcWMqiRxC_uoqTRUaW6aMwayoqjtMqq6XhcCJNVRg@mail.gmail.com>
 <8f046fa5-a458-9db8-b616-907afd34383b@gmail.com> <20170417232419.04474015@natsu>
 <CAK5rZE548XNECYL5PaEqT01-tvpKbnyfKvf0ZekpcLwqsZ_V6w@mail.gmail.com> <1af861c8-c4b6-5c8f-a7c1-d17f17f202b4@mendix.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 19 Apr 2017 12:10:33 -0600
Message-ID: <CAJCQCtR6U3yjkgwxNGL7G93cVtmPynYOJCixMxh88gBJ+4Z1Hg@mail.gmail.com>
Subject: Re: Btrfs/SSD
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 4:55 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> On 04/17/2017 09:22 PM, Imran Geriskovan wrote:
>> [...]
>>
>> Going over the thread following questions come to my mind:
>>
>> - What exactly does btrfs ssd option does relative to plain mode?
>
> There's quite an amount of information in the the very recent threads:
> - "About free space fragmentation, metadata write amplification and (no)ssd"
> - "BTRFS as a GlusterFS storage back-end, and what I've learned from
> using it as such."
> - "btrfs filesystem keeps allocating new chunks for no apparent reason"
> - ... and a few more
>
> I suspect there will be some "summary" mails at some point, but for now,
> I'd recommend crawling through these threads first.
>
> And now for your instant satisfaction, a short visual guide to the
> difference, which shows actual btrfs behaviour instead of our guesswork
> around it (taken from the second mail thread just mentioned):
>
> -o ssd:
>
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-01-19-noautodefrag-ichiban.mp4
>
> -o nossd:
>
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4

I'm uncertain from these if the option affects both metadata and data
writes, or just data. The latter makes some sense, if you think a
given data write event contains related files and thus increases the
chance when those files are deleted of having a mostly freed up erase
block. That way wear leveling is doing less work. For metadata writes
it makes less sense to me, and is inconsistent with what I've seen
from metadata chunk allocation. Pretty much anything means dozens or
more 16K nodes are being COWd. e.g. a 2KiB write to systemd journal,
even preallocated, means adding an EXTENT DATA item, one of maybe 200
per node, which means that whole node must be COWd, and whatever its
parent is must be written (ROOT ITEM I think) and then tree root, and
then super block. I see generally 30 16K nodes modified in about 4
minutes with average logging. Even if it's 1 change per 4 minutes, and
all 30 nodes get written to one 2MB block, and then that block isn't
ever written to again, the metadata chunk would be growing and I don't
see that. For weeks or months I see a 512MB metadata chunk and it
doesn't ever get bigger than this.

Anyway, I think ssd mount option still sounds plausibly useful. What
I'm skeptical of on SSD is defragmenting without compression, and also
nocow.


-- 
Chris Murphy
