Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:55114 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752690AbeAHSRQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 13:17:16 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 269889CF90
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 18:17:14 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id EDC165FC07
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Jan 2018 18:17:13 +0000 (GMT)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
Date: Mon, 8 Jan 2018 18:17:13 +0000
MIME-Version: 1.0
In-Reply-To: <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/18 16:34, Austin S. Hemmelgarn wrote:
> Ideally, I think it should be as generic as reasonably possible,
> possibly something along the lines of:
> 
> A: While not strictly necessary, running regular filtered balances (for
> example `btrfs balance start -dusage=50 -dlimit=2 -musage=50 -mlimit=4`,
> see `man btrfs-balance` for more info on what the options mean) can help
> keep a volume healthy by mitigating the things that typically cause
> ENOSPC errors.  Full balances by contrast are long and expensive
> operations, and should be done only as a last resort.

That recommendation is similar to what I do and it works well for my use
case. I would recommend it to anyone with my usage, but cannot say how
well it would work for other uses. In my case, I run balances like that
once a week: some weeks nothing happens, other weeks 5 or 10 blocks may
get moved.

For reference, my use case is for two separate btrfs filesystems each on
a single large disk (so no RAID) -- the disks are 6TB and 12TB, both
around 80% used -- one is my main personal data disk, the other is my
main online backup disk.

The data disk receives all email delivery (so lots of small files,
coming and going), stores TV programs as PVR storage (many GB sized
files, each one written once, which typically stick around for a while
and eventually get deleted) and is where I do my software development
(sources and build objects). No (significant) database usage. I am
guessing this is pretty typical personal user usage (although it doesn't
store any operating system files). The only unusual thing is that I have
it set up as about 20 subvolumes, and each one has frequent snapshots
(maybe 200 or so subvolumes in total at any time).

The online backup disk receives backups from all my systems in three
main forms: btrfs snapshots (send/receive), rsnapshot copies (rsync),
and DAR archives. Most get updated daily. It contains several hundred
snapshots (most received from the data disk).

It would be interesting to hear if similar balancing is seen as useful
for other very different cases (RAID use, databases or VM disks, etc).

Graham
