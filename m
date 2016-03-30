Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60523 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754472AbcC3IDZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 04:03:25 -0400
Subject: Re: "bad metadata" not fixed by btrfs repair
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, <linux-btrfs@vger.kernel.org>
References: <20160328143714.GZ10135@torres.zugschlus.de>
 <56F98784.8090700@gmail.com> <20160329064351.GA28990@torres.zugschlus.de>
 <56FB7983.2060608@cn.fujitsu.com> <20160330071812.GJ9342@torres.zugschlus.de>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FB8845.5040904@cn.fujitsu.com>
Date: Wed, 30 Mar 2016 16:03:17 +0800
MIME-Version: 1.0
In-Reply-To: <20160330071812.GJ9342@torres.zugschlus.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc Haber wrote on 2016/03/30 09:18 +0200:
> On Wed, Mar 30, 2016 at 03:00:19PM +0800, Qu Wenruo wrote:
>> Marc Haber wrote on 2016/03/29 08:43 +0200:
>>> On Mon, Mar 28, 2016 at 03:35:32PM -0400, Austin S. Hemmelgarn wrote:
>>>> Did you convert this filesystem from ext4 (or ext3)?
>>>
>>> No.
>>>
>>>> You hadn't mentioned what version of btrfs-progs you're using, and that is
>>>> somewhat important for recovery.  I'm not sure if current versions of btrfs
>>>> check can fix this issue, but I know for a fact that older versions (prior
>>>> to at least 4.1) can not fix it.
>>>
>>> 4.1 for creation and btrfs check.
>>
>> I assume that you have run older kernel on it, like v4.1 or v4.2.
>
> No, the productive system was always on a reasonably recent kernel. I
> guess that this instance of btrfs has never been mounted on anything
> older than 4.4.4. The rescue system I used to btrfs check (4.4-1 from
> Debian unstable, I updated btrfs-tools on the rescue system before
> going btrfs check) had kernel 3.16, but I have never actually mounted
> the btrfs there.
>
>>> Then btrfs check is a userspace-only matter, as it wants the fs
>>> unmounted, and it is irrelevant that I did btrfs check from a rescue
>>> system with an older kernel, 3.16 if I recall correctly.
>>
>> Not recommended to use older kernel to RW mount or use older fsck to do
>> repair.
>
> Oldest kernel that has mounted this btrfs is 4.4.4, fsck that touched
> the fs is 4.4. I'm trying to get hold of btrfs-tools 4.5.

Oh, I just forgot to ask for the btrfs-progs version.

The stripe crossing boundary output used to be false alert, as I forgot 
the to "-1" when checking the extent end position.

Didn't remember the exact version, but updating to 4.5 will never be a 
bad idea.
>
>>> My "productive" desktops (fan is one of them) run Debian unstable with
>>> a current vanilla kernel. At the moment, I can't use 4.5 because it
>>> acts up with KVM.  When I need a rescue system, I use grml, which
>>> unfortunately hasn't released since November 2014 and is still with
>>> kernel 3.16
>>
>> To fix your problem(make these error message just disappear, even they are
>> harmless on recent kernels), the most easy one, is to balance your metadata.
>
> This does not work on kernel 4.4.6 with tools 4.4. Truckloads of
> kernel traces, "WARNING: CPU: 5 PID: 31021 at
> fs/btrfs/extent-tree.c:7897 btrfs_alloc_tree_block+0xeb/0x3d6
> [btrfs]()", "BTRFS: block rsv returned -28", full trace is in this
> thread.

That's ENOSPC, seems to be another problem.

Did your btrfs have enough *unallocated* space?

Thanks,
Qu
>
> Greetings
> Marc
>


