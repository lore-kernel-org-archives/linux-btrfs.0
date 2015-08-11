Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:32777 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbbHKU0j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 16:26:39 -0400
Received: by igbpg9 with SMTP id pg9so99066530igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 13:26:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
Date: Tue, 11 Aug 2015 16:26:38 -0400
Message-ID: <CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 3:47 PM, Chris Murphy <lists@colorremedies.com> wrote:

>
> Huh. I thought nodatacow applies to an entire volume only, not per
> subvolume unless you use chattr +C (in which case it can be per
> subvolume, directory or per file). I could be confused, but I think
> you have mutually exclusive mount options.

Well, at the time I set up this system, I asked on IRC, and people
said it should work.  I've never seen any errors from this.


>>
>> [94312.091613] BTRFS info (device sdc): allowing degraded mounts
>> [94312.091618] BTRFS info (device sdc): disk space caching is enabled
>> [94312.194513] BTRFS: bdev (null) errs: wr 1724, rd 305, flush 45,
>> corrupt 0, gen 2
>> [94319.824563] BTRFS: checking UUID tree
>
> I don't see any mount failure message. It worked then?

Yes and no.  It's mounted, but a scrub aborts silently:

# btrfs scrub status /mnt/btrfs/
scrub status for ecdff84d-b4a2-4286-a1c1-cd7e5396901c
scrub started at Tue Aug 11 13:56:36 2015 and was aborted after 01:31:55
total bytes scrubbed: 2.19TiB with 0 errors

No new messages appeared in dmesg, so I can't tell why it aborted.
It's also odd that it reports zero errors, given that it aborted.



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
