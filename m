Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34697 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcC1Tgb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 15:36:31 -0400
Received: by mail-qk0-f173.google.com with SMTP id x64so86132496qkd.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 12:36:31 -0700 (PDT)
Subject: Re: "bad metadata" not fixed by btrfs repair
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, linux-btrfs@vger.kernel.org
References: <20160328143714.GZ10135@torres.zugschlus.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56F98784.8090700@gmail.com>
Date: Mon, 28 Mar 2016 15:35:32 -0400
MIME-Version: 1.0
In-Reply-To: <20160328143714.GZ10135@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-28 10:37, Marc Haber wrote:
> Hi,
>
> I have a btrfs which btrfs check --repair doesn't fix:
>
> # btrfs check --repair /dev/mapper/fanbtr
> bad metadata [4425377054720, 4425377071104) crossing stripe boundary
> bad metadata [4425380134912, 4425380151296) crossing stripe boundary
> bad metadata [4427532795904, 4427532812288) crossing stripe boundary
> bad metadata [4568321753088, 4568321769472) crossing stripe boundary
> bad metadata [4568489656320, 4568489672704) crossing stripe boundary
> bad metadata [4571474493440, 4571474509824) crossing stripe boundary
> bad metadata [4571946811392, 4571946827776) crossing stripe boundary
> bad metadata [4572782919680, 4572782936064) crossing stripe boundary
> bad metadata [4573086351360, 4573086367744) crossing stripe boundary
> bad metadata [4574221041664, 4574221058048) crossing stripe boundary
> bad metadata [4574373412864, 4574373429248) crossing stripe boundary
> bad metadata [4574958649344, 4574958665728) crossing stripe boundary
> bad metadata [4575996018688, 4575996035072) crossing stripe boundary
> bad metadata [4580376772608, 4580376788992) crossing stripe boundary
> repaired damaged extent references
> Fixed 0 roots.
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> enabling repair mode
> Checking filesystem on /dev/mapper/fanbtr
> UUID: 90f8d728-6bae-4fca-8cda-b368ba2c008e
> cache and super generation don't match, space cache will be invalidated
> found 97171628230 bytes used err is 0
> total csum bytes: 91734220
> total tree bytes: 3021848576
> total fs tree bytes: 2762784768
> total extent tree bytes: 148570112
> btree space waste bytes: 545440822
> file data blocks allocated: 308328280064
>   referenced 177314340864
> # btrfs check --repair /dev/mapper/fanbtr
> checking extents
> bad metadata [4425377054720, 4425377071104) crossing stripe boundary
> bad metadata [4425380134912, 4425380151296) crossing stripe boundary
> bad metadata [4427532795904, 4427532812288) crossing stripe boundary
> bad metadata [4568321753088, 4568321769472) crossing stripe boundary
> bad metadata [4568489656320, 4568489672704) crossing stripe boundary
> bad metadata [4571474493440, 4571474509824) crossing stripe boundary
> bad metadata [4571946811392, 4571946827776) crossing stripe boundary
> bad metadata [4572782919680, 4572782936064) crossing stripe boundary
> bad metadata [4573086351360, 4573086367744) crossing stripe boundary
> bad metadata [4574221041664, 4574221058048) crossing stripe boundary
> bad metadata [4574373412864, 4574373429248) crossing stripe boundary
> bad metadata [4574958649344, 4574958665728) crossing stripe boundary
> bad metadata [4575996018688, 4575996035072) crossing stripe boundary
> bad metadata [4580376772608, 4580376788992) crossing stripe boundary
> repaired damaged extent references
> Fixed 0 roots.
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> enabling repair mode
> Checking filesystem on /dev/mapper/fanbtr
> UUID: 90f8d728-6bae-4fca-8cda-b368ba2c008e
> cache and super generation don't match, space cache will be invalidated
> found 97171628230 bytes used err is 0
> total csum bytes: 91734220
> total tree bytes: 3021848576
> total fs tree bytes: 2762784768
> total extent tree bytes: 148570112
> btree space waste bytes: 545440822
> file data blocks allocated: 308328280064
>   referenced 177314340864
>
> How do I fix this?
>
> Does the kernel play a role in btrfs check --repair, or is this all a
> userspace matter?
>
> Greetings
> Marc
>
I had been hoping somebody with a bit more knowledge of this would 
answer, but seeing as that hasn't happened...

Did you convert this filesystem from ext4 (or ext3)?  If so, then you 
appear to have done so with a faulty version of btrfs-convert (I don't 
remember when btrfs-convert started having issues, but I'm relatively 
certain it's not completely fixed yet).  If that is the case, that's 
probably the ultimate cause of the 'bad metadata (xxxxxxxx, xxxxxxxx) 
crossing stripe boundary' thing.

You hadn't mentioned what version of btrfs-progs you're using, and that 
is somewhat important for recovery.  I'm not sure if current versions of 
btrfs check can fix this issue, but I know for a fact that older 
versions (prior to at least 4.1) can not fix it.

As far as what the kernel is involved with, the easy way to check is if 
it's operating on a mounted filesystem or not.  If it only operates on 
mounted filesystems, it almost certainly goes through the kernel, if it 
only operates on unmounted filesystems, it's almost certainly done in 
userspace (except dev scan and technically fi show).  The typical advice 
is that you worry about kernel version for normal operation, and 
userspace version for initial setup (mkfs), and recovery (check, 
restore, recover, etc).

Now, slightly higher level discussion:
1. If you converted this filesystem using an old version of 
btrfs-convert, I would suggest recreating it from backup if possible. 
convert often results in sub-optimal data layout, and converted 
filesystems have (from what I've seen on the list at least) historically 
been more prone to bugs than ones created normally.
2. Regarding general support:  If you're using an enterprise 
distribution (RHEL, SLES, CentOS, OEL, or something similar), you are 
almost certainly going to get better support from your vendor than from 
the mailing list or IRC.  They do crazy things with kernel versioning, 
and it's pretty much impossible to know what patches have been 
back-ported to their kernels, which means we can't know what known bugs 
may be present.  The same somewhat applies for Ubuntu (they have a very 
bad habit recently of picking kernel versions without long-term support 
upstream, which means they back-port all kinds of things too), although 
to nowhere near the same degree.  In both cases, they're essentially 
promising to support their own versions, so they should provide support 
for BTRFS on them too (if they include it officially).
3. Regarding versioning: If 2 doesn't apply to you, then it is advised 
to stay on the most recent stable upstream kernel version (currently 
4.5), or at least something close to it or marked by kernel.org for long 
term support (4.4 and 4.1 are the most recent LTS versions IIRC).  It 
isn't imperative that you run the same userspace version as a kernel 
version, but keeping the tools up to date will usually help with 
recovery (and let you use newer features as well).
