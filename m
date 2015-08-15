Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36020 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbbHOAMB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 20:12:01 -0400
Received: by iodv127 with SMTP id v127so85034984iod.3
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 17:12:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CE7E94.7090102@oracle.com>
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
	<55CE7E94.7090102@oracle.com>
Date: Fri, 14 Aug 2015 20:12:00 -0400
Message-ID: <CAK7bmU8EXeYV=ESwzbgtb120Fs1dRgUcO_W0T-GQS8rQRnwmZw@mail.gmail.com>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
From: Timothy Normand Miller <theosib@gmail.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 7:49 PM, Anand Jain <anand.jain@oracle.com> wrote:
>

>>
>> - I had a drive fail, so I removed it and mounted degraded.
>
>
> that bit dangerous to do without the below patch. patch has more details
> why.

Just to be clear, I removed the drive (the original failed drive) when
the power was off, then powered up, and then mounted degraded.  That's
not dangerous that I know of.

>
>> - I hooked up a replacement drive, did an "add" on that one, and did a
>> "delete missing".
>> - During the rebalance, the replacement drive failed, there were OOPSes,
>> etc.
>> - Now, although all of my data is there, I can't mount degraded,
>> because btrfs is complaining that too many devices are missing (3 are
>> there, but it sees 2 missing).
>
>
>
> This is addressed in the patch
>
>   [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile
>

Where is this patch, and what kernel versions can this be applied to?



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
