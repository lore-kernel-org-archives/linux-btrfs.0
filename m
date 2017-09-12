Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38500 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbdILR1E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 13:27:04 -0400
Received: by mail-it0-f49.google.com with SMTP id c195so121069itb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Sep 2017 10:27:04 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id q18sm6463094ioe.55.2017.09.12.10.27.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Sep 2017 10:27:02 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: linux-btrfs@vger.kernel.org
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170912162843.GA32233@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <1e39d1a1-db3a-1925-2bee-629987b22d3a@gmail.com>
Date: Tue, 12 Sep 2017 13:27:00 -0400
MIME-Version: 1.0
In-Reply-To: <20170912162843.GA32233@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-12 12:28, Ulli Horlacher wrote:
> On Thu 2017-08-31 (09:05), Ulli Horlacher wrote:
>> When I do a
>> btrfs filesystem defragment -r /directory
>> does it defragment really all files in this directory tree, even if it
>> contains subvolumes?
>> The man page does not mention subvolumes on this topic.
> 
> No answer so far :-(
I hadn't seen your original mail, otherwise I probably would have 
responded.  Sorry about that.

On the note of the original question:
I'm pretty sure that it does recursively operate on nested subvolumes. 
The documentation doesn't say otherwise, and not doing so would be 
non-intuitive to people who don't know anything about subvolumes.
> 
> But I found another problem in the man-page:
> 
>    Defragmenting with Linux kernel versions < 3.9 or >= 3.14-rc2 as well as
>    with Linux stable kernel versions >= 3.10.31, >= 3.12.12 or >= 3.13.4
>    will break up the ref-links of COW data (for example files copied with
>    cp --reflink, snapshots or de-duplicated data). This may cause
>    considerable increase of space usage depending on the broken up
>    ref-links.
> 
> I am running Ubuntu 16.04 with Linux kernel 4.10 and I have several
> snapshots.
> Therefore, I better should avoid calling "btrfs filesystem defragment -r"?
> 
> What is the defragmenting best practice?
That really depends on what you're doing.

First, you need to understand that defrag won't break _all_ reflinks, 
just the particular instances you point it at.  So, if you have 
subvolume A, and snapshots S1 and S2 of that subvolume A, then running 
defrag on _just_ subvolume A will break the reflinks between it and the 
snapshots, but S1 and S2 will still share any data they were originally 
with each other.  If you then take a third snapshot of A, it will share 
data with A, but not with S1 or S2 (because A is no longer sharing data 
with S1 or S2).

Given this behavior, you have in turn three potential cases when talking 
about persistent snapshots:

1. You care about minimizing space used, but aren't as worried about 
performance.  In this case, the only option is to not run defrag at all.
2. You care about performance, but not space usage.  In this case, 
defragment everything.
3. You care about both space usage and performance.  In this case, I 
would personally suggest defragmenting only the source subvolume (so 
only subvolume A in the above explanation), and doing so on a schedule 
that coincides with snapshot rotation.  The idea is to defrag just 
before you take a snapshot, and at a frequency that gives a good balance 
between space usage and performance.  As a general rule, if you take 
this route, start by doing the defrag on either a monthly basis if 
you're doing daily or weekly snapshots, or with every fourth snapshot if 
not, and then adjust the interval based on how that impacts your space 
usage.

Additionally, you can compact free space without defragmenting data or 
breaking reflinks by running a full balance on the filesystem.

The tricky part though is that differing workloads are impacted 
differently by fragmentation.  Using just four generic examples:

* Mostly sequential write focused workloads (like security recording 
systems) tend to be impacted by free space fragmentation more than data 
fragmentation.  Balancing filesystems used for such workloads is likely 
to give a noticeable improvement, but defragmenting probably won't give 
much.
* Mostly sequential read focused workloads (like a streaming media 
server) tend to be the most impacted by data fragmentation, but aren't 
generally impacted by free space fragmentation.  As a result, defrag 
will help here a lot, but balance won't as much.
* Mostly random write focused workloads (like most database systems or 
virtual machines) are often impacted by both free space and data 
fragmentation, and are a pathological case for CoW filesystems.  Balance 
and defrag will help here, but they won't help for long.
* Mostly random read focused workloads (like most non-multimedia desktop 
usage) are not impacted much by either aspect, but if you're on a 
traditional hard drive they can be impacted significantly by how the 
data is spread across the disk.  Balance can help here, but only because 
it improves data locality, not because it compacts free space.
