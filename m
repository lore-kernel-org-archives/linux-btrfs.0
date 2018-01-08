Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:33601 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755783AbeAHSfC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 13:35:02 -0500
Received: by mail-it0-f42.google.com with SMTP id c102so4881273itd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Jan 2018 10:35:01 -0800 (PST)
Subject: Re: Recommendations for balancing as part of regular maintenance?
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e370d8c9-4ff0-9ba5-2ae0-69524152c772@gmail.com>
 <5A539A3A.10107@gmail.com> <b3020ddf-5820-dd8b-ecde-51a5f7026cad@gmail.com>
 <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <796ad87c-852f-c6a0-7366-5e888d51fc5c@gmail.com>
Date: Mon, 8 Jan 2018 13:34:58 -0500
MIME-Version: 1.0
In-Reply-To: <811ff9be-d155-dae0-8841-0c1b20c18843@cobb.uk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-01-08 13:17, Graham Cobb wrote:
> On 08/01/18 16:34, Austin S. Hemmelgarn wrote:
>> Ideally, I think it should be as generic as reasonably possible,
>> possibly something along the lines of:
>>
>> A: While not strictly necessary, running regular filtered balances (for
>> example `btrfs balance start -dusage=50 -dlimit=2 -musage=50 -mlimit=4`,
>> see `man btrfs-balance` for more info on what the options mean) can help
>> keep a volume healthy by mitigating the things that typically cause
>> ENOSPC errors.  Full balances by contrast are long and expensive
>> operations, and should be done only as a last resort.
> 
> That recommendation is similar to what I do and it works well for my use
> case. I would recommend it to anyone with my usage, but cannot say how
> well it would work for other uses. In my case, I run balances like that
> once a week: some weeks nothing happens, other weeks 5 or 10 blocks may
> get moved.
> 
> For reference, my use case is for two separate btrfs filesystems each on
> a single large disk (so no RAID) -- the disks are 6TB and 12TB, both
> around 80% used -- one is my main personal data disk, the other is my
> main online backup disk.
> 
> The data disk receives all email delivery (so lots of small files,
> coming and going), stores TV programs as PVR storage (many GB sized
> files, each one written once, which typically stick around for a while
> and eventually get deleted) and is where I do my software development
> (sources and build objects). No (significant) database usage. I am
> guessing this is pretty typical personal user usage (although it doesn't
> store any operating system files). The only unusual thing is that I have
> it set up as about 20 subvolumes, and each one has frequent snapshots
> (maybe 200 or so subvolumes in total at any time).
> 
> The online backup disk receives backups from all my systems in three
> main forms: btrfs snapshots (send/receive), rsnapshot copies (rsync),
> and DAR archives. Most get updated daily. It contains several hundred
> snapshots (most received from the data disk).
> 
> It would be interesting to hear if similar balancing is seen as useful
> for other very different cases (RAID use, databases or VM disks, etc).

In my own usage I've got a pretty varied mix of other stuff going on. 
All my systems are Gentoo, so system updates mean that I'm building 
software regularly (though on most of the systems that happens on tmpfs 
in RAM), I run a home server with a dozen low use QEMU VM's and a bunch 
of transient test VM's, all of which I'm currently storing disk images 
for raw on top of BTRFS (which is actually handling all of it pretty 
well, though that may be thanks to all the VM's using PV-SCSI for their 
disks), I run a BOINC client system that sees pretty heavy filesystem 
usage, and have a lot of personal files that get synced regularly across 
systems, and all of this is on raid1 with essentially no snapshots.  For 
me the balance command I mentioned above run daily seems to help, even 
if the balance doesn't move much most of the time on most filesystems, 
and the actual balance operations take at most a few seconds most of the 
time (I've got reasonably nice SSD's in everything).
