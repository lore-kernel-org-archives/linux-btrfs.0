Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35241 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbbHNXtp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 19:49:45 -0400
Message-ID: <55CE7E94.7090102@oracle.com>
Date: Sat, 15 Aug 2015 07:49:40 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Can't mount degraded. How to remove/add drives OFFLINE?
References: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
In-Reply-To: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/15/2015 02:12 AM, Timothy Normand Miller wrote:
> Sorry about that empty email.  I hit a wrong key, and gmail decided to send.
>
> Anyhow, my replacement drive is going to arrive this evening, and I
> need to know how to add it to my btrfs array.  Here's the situation:
>
> - I had a drive fail, so I removed it and mounted degraded.

that bit dangerous to do without the below patch. patch has more details 
why.

> - I hooked up a replacement drive, did an "add" on that one, and did a
> "delete missing".
> - During the rebalance, the replacement drive failed, there were OOPSes, etc.
> - Now, although all of my data is there, I can't mount degraded,
> because btrfs is complaining that too many devices are missing (3 are
> there, but it sees 2 missing).


This is addressed in the patch

   [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile


Thanks, Anand


> So I could use some help with cleaning up this mess.  All the data is
> there, so I need to know how to either force it to mount degraded, or
> add and remove devices offline.  Where do I begin?
>
> Also, doesn't it seem a bit arbitrary that there are "too many
> missing," when all of the data is there?  If I understand correctly,
> all four drives in my RAID1 should all have copies of the metadata,
> and of the remaining three good drives, there should be one or two
> copies of every data block.  So it's all there, but btrfs has decided,
> based on the NUMBER of missing devices, that it won't mount.
> Shouldn't it refuse to mount if it knows there is data missing?  For
> that matter, why should it even refuse in that case?  So some data
> might missing, so it should throw some errors if you try to access
> that missing data.  Right?
>
> Thanks!
>
