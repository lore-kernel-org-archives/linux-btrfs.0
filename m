Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38542 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753587AbdBGPGk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 10:06:40 -0500
Received: by mail-it0-f50.google.com with SMTP id c7so81094077itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 07:06:39 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: Peter Zaitsev <pz@percona.com>, linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4e91cc08-19a4-5433-c1d3-60918906b022@gmail.com>
Date: Tue, 7 Feb 2017 10:06:34 -0500
MIME-Version: 1.0
In-Reply-To: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 08:53, Peter Zaitsev wrote:
> Hi,
>
> I have tried BTRFS from Ubuntu 16.04 LTS   for write intensive OLTP MySQL
> Workload.
>
> It did not go very well ranging from multi-seconds stalls where no
> transactions are completed to the finally kernel OOPS with "no space left
> on device" error message and filesystem going read only.
How much spare space did you have allocated in the filesystem?  At a 
minimum, you want at least a few GB beyond what you expect to be the 
maximum size of your data-set times the number of snapshots you plan to 
keep around at any given time.
>
> I'm complete newbie in BTRFS so  I assume  I'm doing something wrong.
Not exactly wrong, but getting this to work efficiently is more art than 
engineering.
>
> Do you have any advice on how BTRFS should be tuned for OLTP workload
> (large files having a lot of random writes)  ?    Or is this the case where
> one should simply stay away from BTRFS and use something else ?
The general recommendation is usually to avoid BTRFS for such things. 
There are however a number of things you can do to improve performance:
1. Use a backing storage format that has the minimal amount of 
complexity.  The more data structures that get updated when a record 
changes, the worse the performance will be.  I don't have enough 
experience with MySQL to give a specific recommendation on what backing 
storage format to use, but someone else might.
2. Avoid large numbers of small transactions.  The smaller the 
transaction, the worse it will fragment things.
3. Use autodefrag.  This will increase write load on the storage device, 
but it should improve performance for reads.
4. Try using in-line compression.  This can actually significantly 
improve performance, especially if you have slow storage devices and a 
really nice CPU.
5. If you're running raid10 mode for BTRFS, run raid1 on top of two LVM 
or MD RAID0 devices instead.  This sounds stupid, but it actually will 
hugely improve both read and write performance without sacrificing any 
data safety.
6. Look at I/O scheduler tuning.  This can have a huge impact, 
especially considering that most of the defaults for the various 
schedulers are somewhat poor for most modern systems.  I won't go into 
the details here, since there are a huge number of online resources 
about this.
>
> One item recommended in some places is "nodatacow"  this however defeats
> the main purpose I'm looking at BTRFS -  I am interested in "free"
> snapshots which look very attractive to use for database recovery scenarios
> allow instant rollback to the previous state.
Snapshots aren't free.  They are quick, but they aren't free by any 
means.  If you're going to be using snapshots, keep them to a minimum, 
performance scales inversely proportionate to the number of snapshots, 
and this has a much bigger impact the more you're trying to do on the 
filesystem.  Also, consider whether or not you _actually_ need 
filesystem level snapshots.  I don't know about your full software 
stack, but most good OLTP software supports rollback segments (or an 
equivalent with a different name), and those are probably what you want 
to use, not filesystem snapshots.
