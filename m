Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40288 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750966AbaLOI3Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 03:29:16 -0500
Message-ID: <548E9B38.9080202@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 16:26:32 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Grzegorz Kowal <custos.mentis@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Btrfs: get more accurate output in df command.
References: <36be817396956bffe981a69ea0b8796c44153fa5.1418203063.git.yangds.fnst@cn.fujitsu.com>	<548B4117.1040007@inwind.it>	<CA+qeAOokzptsxMKJaQwtVSFe5UxYuZnx5E22iMjRqM4AsuN8bA@mail.gmail.com>	<CABmMA7tw9BDsBXGHLO4vjcO4gaYmZPb_BQV8w22griqFvCJpPA@mail.gmail.com> <CABmMA7vtHzUYAhnEfpnx3Fx93SJyx=Qqoaz-PyQcivo=51jKsA@mail.gmail.com> <548E377D.6030804@cn.fujitsu.com> <548E7A7A.90505@pobox.com> <548E929B.2090203@pobox.com>
In-Reply-To: <548E929B.2090203@pobox.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/15/2014 03:49 PM, Robert White wrote:
> On 12/14/2014 10:06 PM, Robert White wrote:
>> On 12/14/2014 05:21 PM, Dongsheng Yang wrote:
>>> Anyone have some suggestion about it?
>> (... strong advocacy for raw numbers...)

Hi Robert, thanx for your so detailed reply.

You are proposing to report the raw numbers in df command, right?

Let's compare the space information in FS level and Device level.

Example:
/dev/sda == 1TiB
/dev/sdb == 2TiB

mkfs.btrfs /dev/sda /dev/sdb -d raid1

(1). If we report the raw numbers in df command, we will get the result of
@size=3T, @used=0 @available=3T. It's not a bad idea until now, as you said
user can consider the raid when they are using the fs. Then if we fill 
1T data
into it. we will get @size=3, @used=2T, @avalable=1T. And at this moment, we
will get ENOSPC when writing any more data. It's unacceptable.  Why you
tell me there is 1T space available, but I can't write one byte into it?

(2). Actually, there was an elder btrfs_statfs(), it reported the raw 
numbers to user.
To solve the problem mentioned in (1), we need report the space 
information in the FS level.
Current btrfs_statfs() is designed like this, but not working in any cases.
My new btrfs_statfs() here is following this design and implementing it
to show a *better* output to user.

Thanx
Yang
>
> Concise Example to attempt to be clearer:
>
> /dev/sda == 1TiB
> /dev/sdb == 2TiB
> /dev/sdc == 3TiB
> /dev/sdd == 3TiB
>
> mkfs.btrfs /dev/sd{a..d} -d raid0
> mount /dev/sda /mnt
>
> Now compare ::
>
> #!/bin/bash
> dd if=/dev/urandom of=/mnt/example bs=1G
>
> vs
>
> #!/bin/bash
> typeset -i counter
> for ((counter=0;;counter++)); do
> dd if=/dev/urandom of=/mnt/example$conter bs=44 count=1
> done
>
> vs
>
> #!/bin/bash
> typeset -i counter
> for ((counter=0;;counter++)); do
> dd if=/dev/urandom of=/mnt/example$conter bs=44 count=1
> done &
> dd if=/dev/urandom of=/mnt/example bs=1G
>
> Now repeat the above 3 models for
> mkfs.btrfs /dev/sd{a..d} -d raid5
>
>
> ......
>
> As you watch these six examples evolve you can ponder the ultimate 
> futility of doing adaptive prediction within statfs().
>
> Then go back and change the metadata from the default of RAID1 to 
> RAID5 or RAID6 or RAID10.
>
> Then go back and try
>
> mkfs.btrfs /dev/sd{a..d} -d raid10
>
> then balance when the big file runs out of space, then resume the big 
> file with oflag=append
>
> ......
>
> Unlike _all_ our predecessors, we are active at both the semantic file 
> storage level _and_ the physical media management level.
>
> None of the prior filesystems match this new ground exactly.
>
> The only real option is to expose the raw numbers and then tell people 
> the corner cases.
>
> Absolutely unavailable blocks, such as the massive waste of 5TiB in 
> the above sized media if raid10 were selected for both data and 
> metadata would be subtracted from size if and only if it's 
> _impossible_ for it to be accessed by this sort of restriction. But 
> even in this case, the correct answer for size is 4TiB because that 
> exactly answers "how big is this filesystem".
>
> It might be worth having a "dev_item.bytes_excluded" or unusable or 
> whatever to account for the difference between total_bytes and 
> bytes_used and the implicit bytes available. This would account for 
> the 0,1,2,2 TiB that a raid10 of the example sizes could never reach 
> in the current geometry. I'm betting that this sort of number also 
> shows up as some number of sectors in any filesystem that has an odd 
> tidbit of size up at the top where no structure is ever gong to fit. 
> That's just a feature of the way disks use GB instead of GiB and msdos 
> style partitions love the number 63.
>
> So resize sets the size. Geometry limitations may reduce the effective 
> size by some, or a _lot_, but then the used-vs-available should _not_ 
> try to correct for whatever geometry is in use. Even when it might be 
> simple because if it does it well in the simple cases like 
> raid10/raid10, it would have to botch it up on the hard cases.
>
>
> .
>

