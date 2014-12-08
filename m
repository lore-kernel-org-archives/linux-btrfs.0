Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:48466 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaLHISX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 03:18:23 -0500
Received: by mail-yk0-f181.google.com with SMTP id 142so2033939ykq.12
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 00:18:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
	<44320137.fRRuR6EFMP@merkaba>
	<5484A83A.5090109@inwind.it>
	<6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>
Date: Mon, 8 Dec 2014 01:18:22 -0700
Message-ID: <CAJCQCtSz=pkKr5s-11=siUTpJRZGH8bqdHCyVZ+=omQVOjvFww@mail.gmail.com>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: Chris Murphy <lists@colorremedies.com>
To: ashford@whisperpc.com
Cc: kreijack@inwind.it, Shriramana Sharma <samjnaa@gmail.com>,
        Martin Steigerwald <martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 7, 2014 at 1:32 PM,  <ashford@whisperpc.com> wrote:
>
> I disagree.  My experiences with other file-systems, including ZFS, show
> that the most common solution is to just deliver to the user the actual
> amount of unused disk space.  Anything else changes this known value into
> a guess or prediction.

What is the "actual amount of unused disk space" in a 2x 8GB drives
mirror? Very literally, it's 16GB. It's a convenience subtracting the
space used for replication (the n mirror copies, or parity). This is
in fact how df reported Btrfs volumes with kernel 3.16 and older.

A ZFS mirror vdev doesn't work this way, it reports available space as
8GB. The level of replication and number of devices is a function of
the vdev, and is fixed. It can't be changed. With Btrfs there isn't a
zpool vs vdev type of distinction, and replication level isn't a
function of volume but rather that of chunks. At some future point
there will be a way to supply a hint (per subvolume, maybe per
directory or per file) for the allocator to put the file in a
particular chunk which has a particular level of replication and
number of devices. And that means "available space" isn't knowable.


-- 
Chris Murphy
