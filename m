Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34737 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbHNSMY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Aug 2015 14:12:24 -0400
Received: by igui7 with SMTP id i7so18086305igu.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Aug 2015 11:12:23 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Aug 2015 14:12:23 -0400
Message-ID: <CAK7bmU8hWWVn0KxyKLPsmar2EzSKO_V5fYm5gDor=QycqzrfPQ@mail.gmail.com>
Subject: Can't mount degraded. How to remove/add drives OFFLINE?
From: Timothy Normand Miller <theosib@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry about that empty email.  I hit a wrong key, and gmail decided to send.

Anyhow, my replacement drive is going to arrive this evening, and I
need to know how to add it to my btrfs array.  Here's the situation:

- I had a drive fail, so I removed it and mounted degraded.
- I hooked up a replacement drive, did an "add" on that one, and did a
"delete missing".
- During the rebalance, the replacement drive failed, there were OOPSes, etc.
- Now, although all of my data is there, I can't mount degraded,
because btrfs is complaining that too many devices are missing (3 are
there, but it sees 2 missing).

So I could use some help with cleaning up this mess.  All the data is
there, so I need to know how to either force it to mount degraded, or
add and remove devices offline.  Where do I begin?

Also, doesn't it seem a bit arbitrary that there are "too many
missing," when all of the data is there?  If I understand correctly,
all four drives in my RAID1 should all have copies of the metadata,
and of the remaining three good drives, there should be one or two
copies of every data block.  So it's all there, but btrfs has decided,
based on the NUMBER of missing devices, that it won't mount.
Shouldn't it refuse to mount if it knows there is data missing?  For
that matter, why should it even refuse in that case?  So some data
might missing, so it should throw some errors if you try to access
that missing data.  Right?

Thanks!

-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
