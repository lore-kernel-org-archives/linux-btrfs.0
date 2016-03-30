Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55168 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753004AbcC3HAa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 03:00:30 -0400
Subject: Re: "bad metadata" not fixed by btrfs repair
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, <linux-btrfs@vger.kernel.org>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <56F98784.8090700@gmail.com> <20160329064351.GA28990@torres.zugschlus.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FB7983.2060608@cn.fujitsu.com>
Date: Wed, 30 Mar 2016 15:00:19 +0800
MIME-Version: 1.0
In-Reply-To: <20160329064351.GA28990@torres.zugschlus.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First of all.

The "crossing stripe boundary" error message itself is *HARMLESS* for 
recent kernels.

It only means, that metadata extent won't be checked by scrub on recent 
kernels.
Because scrub by its codes, has a limitation that, it can only check 
tree blocks which are inside a 64K block.

Old kernel won't have anything wrong, until that tree block is being 
scrubbed.
When scrubbed, old kernel just BUG_ON().

Now recent kernel will handle such limitation by checking extent 
allocation and avoid crossing boundary, so new created fs with new 
kernel won't cause such error message at all.

But for old created fs, the problem can't be avoided, but at least, new 
kernels will not BUG_ON() when you scrub these extents, they just get 
ignored (not that good, but at least no BUG_ON).

And new fsck will check such case, gives such warning.

Overall, you're OK if you are using recent kernels.

Marc Haber wrote on 2016/03/29 08:43 +0200:
> On Mon, Mar 28, 2016 at 03:35:32PM -0400, Austin S. Hemmelgarn wrote:
>> Did you convert this filesystem from ext4 (or ext3)?
>
> No.
>
>> You hadn't mentioned what version of btrfs-progs you're using, and that is
>> somewhat important for recovery.  I'm not sure if current versions of btrfs
>> check can fix this issue, but I know for a fact that older versions (prior
>> to at least 4.1) can not fix it.
>
> 4.1 for creation and btrfs check.

I assume that you have run older kernel on it, like v4.1 or v4.2.

In those old kernels, it lacks the check to avoid such extent allocation 
check.

>
>> As far as what the kernel is involved with, the easy way to check is if it's
>> operating on a mounted filesystem or not.  If it only operates on mounted
>> filesystems, it almost certainly goes through the kernel, if it only
>> operates on unmounted filesystems, it's almost certainly done in userspace
>> (except dev scan and technically fi show).
>
> Then btrfs check is a userspace-only matter, as it wants the fs
> unmounted, and it is irrelevant that I did btrfs check from a rescue
> system with an older kernel, 3.16 if I recall correctly.

Not recommended to use older kernel to RW mount or use older fsck to do 
repair.
As it's possible that older kernel/btrfsck may allocate extent that 
cross the 64K boundary.

>
>> 2. Regarding general support:  If you're using an enterprise distribution
>> (RHEL, SLES, CentOS, OEL, or something similar), you are almost certainly
>> going to get better support from your vendor than from the mailing list or
>> IRC.
>
> My "productive" desktops (fan is one of them) run Debian unstable with
> a current vanilla kernel. At the moment, I can't use 4.5 because it
> acts up with KVM.  When I need a rescue system, I use grml, which
> unfortunately hasn't released since November 2014 and is still with
> kernel 3.16

To fix your problem(make these error message just disappear, even they 
are harmless on recent kernels), the most easy one, is to balance your 
metadata.

As I explained, the bug only lies in metadata, and balance will allocate 
new tree blocks, then copy old data into new locations.

In the allocation process of recent kernel, it will avoid such cross 
boundary, and to fix your problem.

But if you are using old kernels, don't scrub your metadata.

Thanks,
Qu
>
> Greetings
> Marc
>


