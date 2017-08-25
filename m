Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33370 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756334AbdHYLpu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 07:45:50 -0400
Received: by mail-io0-f172.google.com with SMTP id s101so6912043ioe.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 04:45:50 -0700 (PDT)
Subject: Re: number of subvolumes
To: Ferry Toth <ftoth@telfort.nl>, linux-btrfs@vger.kernel.org
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
 <20170822142451.GI14804@rus.uni-stuttgart.de> <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822204811.GO14804@rus.uni-stuttgart.de>
 <20170823071821.GA28319@rus.uni-stuttgart.de>
 <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>
 <BD7091A7-DE7F-4A86-9BDE-8BA63060CBAF@rqc.ru> <onni1n$bic$2@blaine.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2828ac64-8b68-8b1c-554c-489bda3b70d1@gmail.com>
Date: Fri, 25 Aug 2017 07:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <onni1n$bic$2@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-24 17:56, Ferry Toth wrote:
> Op Thu, 24 Aug 2017 22:40:54 +0300, schreef Marat Khalili:
> 
>>> We find that typically apt is very slow on a machine with 50 or so
>>> snapshots and raid10. Slow as in probably 10x slower as doing the same
>>> update on a machine with 'single' and no snapshots.
>>>
>>> Other operations seem to be the same speed, especially disk benchmarks
>>> do not seem to indicate any performance degradation.
>>
>> For meaningful discussion it is important to take into account the fact
> 
> Doing daily updates on a desktop is not uncommon and when 3 minutes
> become 30 then many would call that meaningful.
I think the more meaningful aspect here is that it's 30 minutes where 
persistent storage is liable to be unusable, not necessarily that it's 
30 minutes.
> 
> Similar for a single office server, which is upgraded twice a year, where
> an upgrade normally would take an hour or 2, but now more than a working
> day. In the meantime, take samba and postgresql offline, preventing
> people to work for a few hours.
That should only be the case if:
1. You don't have your data set properly segregated from the rest of 
your system (it should not be part of the upgrade snapshot, but an 
independent snapshot taken separately).
2. You are updating the main system, instead of updating the snapshot 
you took.

The ideal method of handling an upgrade in this case is:
1. Snapshot the system, but not the data set.
2. Run your updates on the snapshot of the system.
3. Rename the snapshot and the root subvolume so that you boot into the 
snapshot.
4. During the next maintenance window (or overnight), shutdown the 
system services, snapshot the data set (so you can roll back if the 
update screws up the database).
5. Reboot.

That provides minimal downtime, and removes the need to roll-back if the 
upgrade fails part way through (you just nuke the snapshot and start 
over, instead of having to manually switch to the snapshot and reboot).
> 
> My point is: fsync is not targeted specifically in many common disk bench
> marks (phoronix?), it might be posible that there is no trigger to spend
> much time on optimizations in that area. That doesn't make it meaningless.
> 
>> that dpkg infamously calls fsync after changing every bit of
>> information, so basically you're measuring fsync speed. Which is slow on
>> btrfs (compared to simpler filesystems), but unrelated to normal work.
> 
> OTOH it would be nice if dpkg would at last start making use btrfs
> snapshot features and abandon these unnecssary fsyncs completely, instead
> restoring a failed install from a snapshot. This would probably result in
> a performance improve compared to ext4.
Not dpkg, apt-get and wherever other frontedd you use (although all the 
other dpkg frontends I know of are actually apt-get frontends).  Take a 
look at how SUSE actually does this integration, it's done through 
Zypper/YaST2, not RPM.  If you do it through dpkg, or RPM, or whatever 
other low-level package tool, you need to do a snapshot per package so 
that it works reliably, while what you really need is a snapshot per 
high-level transaction.

FWIW, if you can guarantee that the system won't crash during an update 
(or are actually able to roll back by hand easily if it won't boot), you 
can install libeatmydata and LD_PRELOAD it for the apt-get (or aptitude, 
or synaptic, or whatever else) call, then call sync afterwards and 
probably see a significant perofrmance improvement.  The library itself 
overloads *sync() calls to be no-ops, so it's not safe to use when you 
don't have good fallback options, but it tends to severely improve 
performance for stuff like dpkg.
