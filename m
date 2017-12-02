Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:36550 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751271AbdLBJdD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 2 Dec 2017 04:33:03 -0500
Date: Sat, 2 Dec 2017 10:33:01 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: exclusive subvolume space missing
Message-ID: <20171202093301.GA28256@polanet.pl>
References: <20171201161555.GA11892@polanet.pl>
 <55036341-2e8e-41dc-535f-f68d8e74d43f@gmx.com>
 <20171202012324.GB20205@polanet.pl>
 <0d3cd6f5-04ad-b080-6e62-7f25824860f1@gmx.com>
 <20171202022153.GA7727@polanet.pl>
 <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <af4ba078-8dc9-3f5d-b28c-7d72e0390294@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK, I seriously need to address that, as during the night I lost
3 GB again:

On Sat, Dec 02, 2017 at 10:35:12 +0800, Qu Wenruo wrote:

>> #  btrfs fi sh /
>> Label: none  uuid: 17a3de25-6e26-4b0b-9665-ac267f6f6c4a
>>         Total devices 2 FS bytes used 44.10GiB
           Total devices 2 FS bytes used 47.28GiB

>> #  btrfs fi usage /
>> Overall:
>>     Used:                         88.19GiB
       Used:                         94.58GiB
>>     Free (estimated):             18.75GiB      (min: 18.75GiB)
       Free (estimated):             15.56GiB      (min: 15.56GiB)
>> 
>> #  btrfs dev usage /
- output not changed

>> #  btrfs fi df /    
>> Data, RAID1: total=51.97GiB, used=43.22GiB
   Data, RAID1: total=51.97GiB, used=46.42GiB
>> System, RAID1: total=32.00MiB, used=16.00KiB
>> Metadata, RAID1: total=2.00GiB, used=895.69MiB
>> GlobalReserve, single: total=131.14MiB, used=0.00B
   GlobalReserve, single: total=135.50MiB, used=0.00B
>> 
>> # df
>> /dev/sda2        64G   45G   19G  71% /
   /dev/sda2        64G   48G   16G  76% /
>> However the difference is on active root fs:
>> 
>> -0/291        24.29GiB      9.77GiB
>> +0/291        15.99GiB     76.00MiB
    0/291        19.19GiB      3.28GiB
> 
> Since you have already showed the size of the snapshots, which hardly
> goes beyond 1G, it may be possible that extent booking is the cause.
> 
> And considering it's all exclusive, defrag may help in this case.

I'm going to try defrag here, but have a bunch of questions before;
as defrag would break CoW, I don't want to defrag files that span
multiple snapshots, unless they have huge overhead:
1. is there any switch resulting in 'defrag only exclusive data'?
2. is there any switch resulting in 'defrag only extents fragmented more than X'
   or 'defrag only fragments that would be possibly freed'?
3. I guess there aren't, so how could I accomplish my target, i.e.
   reclaiming space that was lost due to fragmentation, without breaking
   spanshoted CoW where it would be not only pointless, but actually harmful?
4. How can I prevent this from happening again? All the files, that are
   written constantly (stats collector here, PostgreSQL database and
   logs on other machines), are marked with nocow (+C); maybe some new
   attribute to mark file as autodefrag? +t?

For example, the largest file from stats collector:
     Total   Exclusive  Set shared  Filename
 432.00KiB   176.00KiB   256.00KiB  load/load.rrd

but most of them has 'Set shared'==0.

5. The stats collector is running from the beginning, according to the
quota output was not the issue since something happened. If the problem
was triggered by (guessing) low space condition, and it results in even
more space lost, there is positive feedback that is dangerous, as makes
any filesystem unstable ("once you run out of space, you won't recover").
Does it mean btrfs is simply not suitable (yet?) for frequent updates usage
pattern, like RRD files?

6. Or maybe some extra steps just before taking snapshot should be taken?
I guess 'defrag exclusive' would be perfect here - reclaiming space
before it is being locked inside snapshot.
Rationale behind this is obvious: since the snapshot-aware defrag was
removed, allow to defrag snapshot exclusive data only.
This would of course result in partial file defragmentation, but that
should be enough for pathological cases like mine.

-- 
Tomasz Pala <gotar@pld-linux.org>
