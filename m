Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:33263 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbbHKUs5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 16:48:57 -0400
Received: by vkbc123 with SMTP id c123so26605012vkb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 13:48:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
	<CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
Date: Tue, 11 Aug 2015 14:48:56 -0600
Message-ID: <CAJCQCtSzYS=eDDLt_pMBbi8SY94wAXYnZCE_oppDtm8KEwqh1A@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 2:26 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> On Tue, Aug 11, 2015 at 3:47 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>>
>> Huh. I thought nodatacow applies to an entire volume only, not per
>> subvolume unless you use chattr +C (in which case it can be per
>> subvolume, directory or per file). I could be confused, but I think
>> you have mutually exclusive mount options.
>
> Well, at the time I set up this system, I asked on IRC, and people
> said it should work.  I've never seen any errors from this.

Error implies a mistake with some sort of reference. All Btrfs does is
inform you of conflicting options:
[    8.766903] BTRFS info (device sdc): setting nodatacow, compression disabled

Unfortunately that message should not reference just one device but a
volume label or UUID in my opinion.

When I test manual mount of subvolume first with -o compress, followed
by mount of another subvolume with -o nodatacow, this is the results
from mount:

/dev/sdb on /var/mnt/root type btrfs
(rw,relatime,seclabel,compress=zlib,space_cache)
/dev/sdb on /var/mnt/home type btrfs
(rw,relatime,seclabel,compress=zlib,space_cache)

When I do -o nodatacow first, followed by -o compress

/dev/sdb on /var/mnt/root type btrfs
(rw,relatime,seclabel,nodatasum,nodatacow,space_cache)
/dev/sdb on /var/mnt/home type btrfs
(rw,relatime,seclabel,nodatasum,nodatacow,space_cache)

The compress is ignored, and it looks like nodatasum and nodatacow
apply to everything. The nodatasum means no raid1 self-healing is
possible for any data on the entire volume. Metadata checksumming is
still enabled.


>>> [94312.091613] BTRFS info (device sdc): allowing degraded mounts
>>> [94312.091618] BTRFS info (device sdc): disk space caching is enabled
>>> [94312.194513] BTRFS: bdev (null) errs: wr 1724, rd 305, flush 45,
>>> corrupt 0, gen 2
>>> [94319.824563] BTRFS: checking UUID tree
>>
>> I don't see any mount failure message. It worked then?
>
> Yes and no.  It's mounted, but a scrub aborts silently:
>
> # btrfs scrub status /mnt/btrfs/
> scrub status for ecdff84d-b4a2-4286-a1c1-cd7e5396901c
> scrub started at Tue Aug 11 13:56:36 2015 and was aborted after 01:31:55
> total bytes scrubbed: 2.19TiB with 0 errors
>
> No new messages appeared in dmesg, so I can't tell why it aborted.
> It's also odd that it reports zero errors, given that it aborted.

Well I wouldn't expect a scrub to completely work in this, even though
it probably should fail more gracefully than this:
a.) you don't have a complete array I don't know what a scrub of a
degraded volume even means
b.) the data has no checksums so the only thing that can really be
scrubbed is metadata

So I'd say there are three UI/UX bugs here:
a.) The info message about nodatacow overriding compression should
refer to label and/or UUID not device.
b.) When degraded, a scrub should give more meaningful information on
the scope of what can and can't be done; or at the least say scrub
isn't possible on degraded volumes.
c.) When nodatacow, scrub should scrub metadata and inform user
metadata is scrubbed but data can't be scrubbed due to nodatacow.




-- 
Chris Murphy
