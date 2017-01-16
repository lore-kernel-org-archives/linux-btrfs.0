Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:48628 "EHLO
        smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdAPPmh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jan 2017 10:42:37 -0500
From: Christoph Groth <christoph@grothesque.org>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unocorrectable errors with RAID1
References: <87o9z7dzvd.fsf@grothesque.org>
        <85a62769-0607-4be5-3c5b-5091bebea07e@gmail.com>
Date: Mon, 16 Jan 2017 16:42:31 +0100
In-Reply-To: <85a62769-0607-4be5-3c5b-5091bebea07e@gmail.com> (Austin
        S. Hemmelgarn's message of "Mon, 16 Jan 2017 08:24:37 -0500")
Message-ID: <87fukjdna0.fsf@grothesque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn wrote:
> On 2017-01-16 06:10, Christoph Groth wrote:

>> root@mim:~# btrfs fi df /
>> Data, RAID1: total=417.00GiB, used=344.62GiB
>> Data, single: total=8.00MiB, used=0.00B
>> System, RAID1: total=40.00MiB, used=68.00KiB
>> System, single: total=4.00MiB, used=0.00B
>> Metadata, RAID1: total=3.00GiB, used=1.35GiB
>> Metadata, single: total=8.00MiB, used=0.00B
>> GlobalReserve, single: total=464.00MiB, used=0.00B

> Just a general comment on this, you might want to consider 
> running a full balance on this filesystem, you've got a huge 
> amount of slack space in the data chunks (over 70GiB), and 
> significant space in the Metadata chunks that isn't accounted 
> for by the GlobalReserve, as well as a handful of empty single 
> profile chunks which are artifacts from some old versions of 
> mkfs.  This isn't of course essential, but keeping ahead of such 
> things does help sometimes when you have issues.

Thanks!  So slack is the difference between "total" and "used"?  I 
saw that the manpage of "btrfs balance" explains this a bit in its 
"examples" section.  Are you aware of any more in-depth 
documentation?  Or one has to look at the source at this level?

I ran

btrfs balance start -dconvert=raid1,soft -mconvert=raid1,soft /
btrfs balance start -dusage=25 -musage=25 /

This resulted in

root@mim:~# btrfs fi df /
Data, RAID1: total=365.00GiB, used=344.61GiB
System, RAID1: total=32.00MiB, used=64.00KiB
Metadata, RAID1: total=2.00GiB, used=1.35GiB
GlobalReserve, single: total=460.00MiB, used=0.00B

I hope that one day there will be a daemon that silently performs 
all the necessary btrfs maintenance in the background when system 
load is low!

>> * So scrubbing is not enough to check the health of a btrfs 
>> file system?  It’s also necessary to read all the files?

> Scrubbing checks data integrity, but not the state of the data. 
> IOW, you're checking that the data and metadata match with the 
> checksums, but not necessarily that the filesystem itself is 
> valid.

I see, but what should one then do to detect problems such as mine 
as soon as possible?  Periodically calculate hashes for all files? 
I’ve never seen a recommendation to do that for btrfs.

> There are a few things you can do to mitigate the risk of not 
> using ECC RAM though:
> * Reboot regularly, at least weekly, and possibly more 
> frequently.
> * Keep the system cool, warmer components are more likely to 
> have transient errors.
> * Prefer fewer numbers of memory modules when possible.  Fewer 
> modules means less total area that could be hit by cosmic rays 
> or other high-energy radiation (the main cause of most transient 
> errors).

Thanks for the advice, I think I buy the regular reboots.

As a consequence of my problem I think I’ll stop using RAID1 on 
the file server, since this only protects against dead disks, 
which evidently is only part of the problem.  Instead, I’ll make 
sure that the laptop that syncs with the server has a SSD that is 
big enough to hold all the data that is on the server as well (1 
TB SSDs are affordable now).  This way, instead of disk-level 
redundancy, I’ll have machine-level redundancy.  When something 
like the current problem hits one of the two machines, I should 
still have a usable second machine with all the data on it.
