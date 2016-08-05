Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38082 "EHLO
	mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655AbcHEMNJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 08:13:09 -0400
Received: by mail-it0-f43.google.com with SMTP id j124so22496990ith.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Aug 2016 05:13:08 -0700 (PDT)
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: Lutz Vieweg <lvml@5t9.de>, linux-btrfs@vger.kernel.org
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
 <5693A8B3.2090508@gmail.com>
 <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com>
 <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com>
 <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com>
 <57A372F3.5090400@5t9.de>
 <CAJCQCtSFcJd+ac+Awfwuzdhuf8xjf8EgMQNwq_aV3udaZmZ=5A@mail.gmail.com>
 <57A470C7.2080304@5t9.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f64a719e-fdca-54d8-7636-9e5ba44e0aef@gmail.com>
Date: Fri, 5 Aug 2016 08:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <57A470C7.2080304@5t9.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-05 06:56, Lutz Vieweg wrote:
> On 08/04/2016 10:30 PM, Chris Murphy wrote:
>> Keep in mind the list is rather self-selecting for problems. People
>> who aren't having problems are unlikely to post their non-problems to
>> the list.
>
> True, but the number of people inclined to post a bug report to
> the list is also a lot smaller than the number of people who
> experienced problems.
>
> Personally, I know at least 2 Linux users who happened to
> get a btrfs filesystem as part of upgrading to a newer Suse
> distribution on their PC, and both of them experienced
> trouble with their filesystems that caused them to re-install
> without using btrfs. They weren't interested in what filesystem
> they use enough to bother investigating what happened
> in detail or to issue bug-reports.
>
> I'm afraid that btrfs' reputation has already taken damage
> from the combination of "early deployment as a root filesystem
> to unsuspecting users" and "being at a development stage where
> users are likely to experience trouble at some time".
FWIW, the 'early deployment' thing is an issue of the distributions 
themselves, and most people who have come to me personally complaining 
about BTRFS have understood this after I explained it to them.

As far as the rest, it's hit or miss whether you have issues.  I've been 
using BTRFS on all my personal systems since about 3.14, and have had 
zero issues with data loss or filesystem corruption (or horrible 
performance) since about 3.18 that were actually BTRFS issues (it's 
helped me ID a lot of marginal hardware though), and in fact, I had more 
issues trying to use ZFS for a year than I've had in the now multiple 
years of using BTRFS, and in the case of BTRFS, I was actually able to 
fix things.  I know quite a few people (and a number of big companies 
for that matter) who have been running BTRFS for longer and had fewer 
issues too.  The biggest issue is that the risks involved aren't well 
characterized, although most filesystems have that same issue.

If you stick to single disk or raid1 mode, don't use quota groups (which 
at least SUSE does by default now), stick to reasonably sized 
filesystems (not more than a few TB), and avoid a couple of specific 
unconventional storage configurations below it, BTRFS works fine.  The 
whole issue with databases is often a non-issue for desktop users in my 
experience, and if you think VM image performance is bad, you should 
really be looking at using real block storage instead of a file 
(seriously, this will usually get you a bigger performance boost than 
using ext4 or XFS over BTRFS as an underlying filesystem will).
>
>> c. Take some risk and use 4.8 rc1 once it's out. Just make sure to
>> keep backups.
>
> We sure do - actually, the possibility to "run daily backups from a
> snapshot while write performance remains acceptable" is the one and
> only reason for me to use btrfs rather than xfs for those $HOME dirs.
> In every other aspect (stability, performance, suitability for
> storing VM-images or database-files) xfs wins for me.
> And the btrfs advantage "file system based snapshot being more
> performant than block device based snapshot" may fade away
> with the replacement of magnetic disks with SSDs in the long run.
I'm going to respond to the two parts of this separately:
1. As far as snapshot performance, you'd be surprised. I've got pretty 
good consumer grade SSD's that can do a sustained 250MB/s write speed, 
which means that to be as fast as a snapshot, the data set would have to 
be less than 25MB (and that's being generous, snapshots usually take 
less than 0.1s to create on my system).  Where the turnover point occurs 
varies of course based on storage bandwidth, but I don't see it being 
very likely that SSD's will obsolete snapshotting any time soon.  Even 
if disks suddenly get the ability to run at full bandwidth of the link 
they're on, a SAS3 disk (12Gbit/s signaling, practical bandwidth of 
about 1GB/s) would have a turn over point of about 100MB, and a NVMe 
device on a PCIe 4.0 X16 link (3.151GB/s theoretical bandwidth) would 
have a turn over point of 3.1GB.  In theory, a high-end NVDIMM might be 
able to do better than a snapshot, but it probably couldn't get much 
faster right now than twice the speed of a PCIe 4.0 X16 link, which 
means that it would likely have a turn over point of about 6.2GB.  In 
comparison, it's not unusual to need a snapshot of a data set in excess 
of a terabyte in size.
2. As far as snapshots being the only advantage of BTRFS, that's just 
bogus. XFS does have metadata checksumming now, but that provides no 
protection for data, just metadata.  XFS also doesn't have transparent 
compression support, filesystems can't be shrunk, and it stores no 
backups of any metadata except super-blocks.  While the compression and 
filesystem shrinking may not be needed in your use case, the data 
integrity features are almost certainly an advantage.
