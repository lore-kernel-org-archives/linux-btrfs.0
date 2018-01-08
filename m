Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from a4-5.smtp-out.eu-west-1.amazonses.com ([54.240.4.5]:37082 "EHLO
        a4-5.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751761AbeAHU3U (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jan 2018 15:29:20 -0500
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
 <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
From: Martin Raiber <martin@urbackup.org>
Message-ID: <01020160d7768587-50a9392c-7250-4735-9d14-66ff03a161c9-000000@eu-west-1.amazonses.com>
Date: Mon, 8 Jan 2018 20:29:19 +0000
MIME-Version: 1.0
In-Reply-To: <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08.01.2018 19:34 Austin S. Hemmelgarn wrote:
> On 2018-01-08 13:17, Graham Cobb wrote:
>> On 08/01/18 16:34, Austin S. Hemmelgarn wrote:
>>> Ideally, I think it should be as generic as reasonably possible,
>>> possibly something along the lines of:
>>>
>>> A: While not strictly necessary, running regular filtered balances (for
>>> example `btrfs balance start -dusage=50 -dlimit=2 -musage=50
>>> -mlimit=4`,
>>> see `man btrfs-balance` for more info on what the options mean) can
>>> help
>>> keep a volume healthy by mitigating the things that typically cause
>>> ENOSPC errors.  Full balances by contrast are long and expensive
>>> operations, and should be done only as a last resort.
>>
>> That recommendation is similar to what I do and it works well for my use
>> case. I would recommend it to anyone with my usage, but cannot say how
>> well it would work for other uses. In my case, I run balances like that
>> once a week: some weeks nothing happens, other weeks 5 or 10 blocks may
>> get moved.
>
> In my own usage I've got a pretty varied mix of other stuff going on.
> All my systems are Gentoo, so system updates mean that I'm building
> software regularly (though on most of the systems that happens on
> tmpfs in RAM), I run a home server with a dozen low use QEMU VM's and
> a bunch of transient test VM's, all of which I'm currently storing
> disk images for raw on top of BTRFS (which is actually handling all of
> it pretty well, though that may be thanks to all the VM's using
> PV-SCSI for their disks), I run a BOINC client system that sees pretty
> heavy filesystem usage, and have a lot of personal files that get
> synced regularly across systems, and all of this is on raid1 with
> essentially no snapshots.  For me the balance command I mentioned
> above run daily seems to help, even if the balance doesn't move much
> most of the time on most filesystems, and the actual balance
> operations take at most a few seconds most of the time (I've got
> reasonably nice SSD's in everything).

There have been reports of (rare) corruption caused by balance (won't be
detected by a scrub) here on the mailing list. So I would stay a away
from btrfs balance unless it is absolutely needed (ENOSPC), and while it
is run I would try not to do anything else wrt. to writes simultaneously.

