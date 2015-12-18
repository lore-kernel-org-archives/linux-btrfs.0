Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:34584 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbbLRMIT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Dec 2015 07:08:19 -0500
Received: by mail-lb0-f196.google.com with SMTP id l5so5907445lbs.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Dec 2015 04:08:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450423394@msgid.manchmal.in-ulm.de>
References: <1450423394@msgid.manchmal.in-ulm.de>
Date: Fri, 18 Dec 2015 13:08:18 +0100
Message-ID: <CAPmG0jZYidy-ra-R-C5GQNQhUZeVSB6anCg7N9sFSY5NrrO61w@mail.gmail.com>
Subject: Re: ERROR: scrubbing <dev> failed for device id 1: ret=-1, errno=28
 (No space left on device)
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello  Christoph,

you need to do some balancing, as I think that the free space is too
fragmented and the system fails to allocate extra metadata space
needed for scrub doing writes into metadata.

# btrfs balance start -dusage=<number>
with number somewhere between 5 and 50; first start with lower number
and repeat and increase until the 5.17GiB gets closer down to the
3.75GiB

Same for metadata:
# btrfs balance start -musage=<number>

or maybe scrub already succeeds by just the data balancing. You can do
it also at once:
# btrfs balance start -musage=<number> -dusage=<number>

The issue is that for for a filesystem of this size (6.5GiB), it would
have been better to have mixed data/metadata allocation. See help of
mkfs.btrfs. So maybe you want to recreate the fs like that, otherwise
you might easily hit this problem again if you don't monitor free
space / balance regularly.

/Henk

On Fri, Dec 18, 2015 at 8:28 AM, Christoph Biedl
<linux-kernel.bfrz@manchmal.in-ulm.de> wrote:
> Hello,
>
> checking all my btr file systems after seeing a lot of trouble on a
> particular installation, I came across this:
>
> # btrfs scrub start -B -c3 /mnt/schroot/
> ERROR: scrubbing /mnt/schroot/ failed for device id 1: ret=-1, errno=28 (No space left on device)
> scrub canceled for 89a02165-5975-46c7-8565-1247874531a2
>         scrub started at Fri Dec 18 08:20:27 2015 and was aborted after 00:00:01
>         total bytes scrubbed: 7.70MiB with 0 errors
>
> btrfsck shows a *lot* of the "bad extent [458797056, 458801152), type
> mismatch with chunk" messages that have been discussed here but
> otherwise exits zero.
>
> df shows 75% usage (4.4 of 6.5 Gibyte used)).
>
> # btrfs fi df /mnt/schroot/
> Data, single: total=5.17GiB, used=3.75GiB
> System, DUP: total=8.00MiB, used=4.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=409.56MiB, used=143.44MiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=48.00MiB, used=0.00B
>
> This is btrfs-progs v4.3 running on kernel 4.3.3
>
> Any idea how to proceed?
>
>     Christoph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
