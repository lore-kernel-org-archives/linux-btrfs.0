Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33823 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbcCaS2K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 14:28:10 -0400
Received: by mail-lf0-f49.google.com with SMTP id c62so65514556lfc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Mar 2016 11:28:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FC8A28.7070601@cn.fujitsu.com>
References: <20160328143714.GZ10135@torres.zugschlus.de>
	<56F98784.8090700@gmail.com>
	<20160329064351.GA28990@torres.zugschlus.de>
	<56FB7983.2060608@cn.fujitsu.com>
	<CAPmG0jZ8hFfnO2NR9xbx3_W_Ot7QOCkN-J0ttn3Y=PsqzfN4KA@mail.gmail.com>
	<56FC8A28.7070601@cn.fujitsu.com>
Date: Thu, 31 Mar 2016 20:28:08 +0200
Message-ID: <CAPmG0jbA_uEGx+gcGqYJy0N4SYqMmQurg5p19VtmD_ifyTvxQw@mail.gmail.com>
Subject: Re: "bad metadata" not fixed by btrfs repair
From: Henk Slager <eye1tm@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Marc Haber <mh+linux-btrfs@zugschlus.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 31, 2016 at 4:23 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Henk Slager wrote on 2016/03/30 16:03 +0200:
>>
>> On Wed, Mar 30, 2016 at 9:00 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> First of all.
>>>
>>> The "crossing stripe boundary" error message itself is *HARMLESS* for
>>> recent
>>> kernels.
>>>
>>> It only means, that metadata extent won't be checked by scrub on recent
>>> kernels.
>>> Because scrub by its codes, has a limitation that, it can only check tree
>>> blocks which are inside a 64K block.
>>>
>>> Old kernel won't have anything wrong, until that tree block is being
>>> scrubbed.
>>> When scrubbed, old kernel just BUG_ON().
>>>
>>> Now recent kernel will handle such limitation by checking extent
>>> allocation
>>> and avoid crossing boundary, so new created fs with new kernel won't
>>> cause
>>> such error message at all.
>>>
>>> But for old created fs, the problem can't be avoided, but at least, new
>>> kernels will not BUG_ON() when you scrub these extents, they just get
>>> ignored (not that good, but at least no BUG_ON).
>>>
>>> And new fsck will check such case, gives such warning.
>>>
>>> Overall, you're OK if you are using recent kernels.
>>>
>>> Marc Haber wrote on 2016/03/29 08:43 +0200:
>>>>
>>>>
>>>> On Mon, Mar 28, 2016 at 03:35:32PM -0400, Austin S. Hemmelgarn wrote:
>>>>>
>>>>>
>>>>> Did you convert this filesystem from ext4 (or ext3)?
>>>>
>>>>
>>>>
>>>> No.
>>>>
>>>>> You hadn't mentioned what version of btrfs-progs you're using, and that
>>>>> is
>>>>> somewhat important for recovery.  I'm not sure if current versions of
>>>>> btrfs
>>>>> check can fix this issue, but I know for a fact that older versions
>>>>> (prior
>>>>> to at least 4.1) can not fix it.
>>>>
>>>>
>>>>
>>>> 4.1 for creation and btrfs check.
>>>
>>>
>>>
>>> I assume that you have run older kernel on it, like v4.1 or v4.2.
>>>
>>> In those old kernels, it lacks the check to avoid such extent allocation
>>> check.
>>>
>>>>
>>>>> As far as what the kernel is involved with, the easy way to check is if
>>>>> it's
>>>>> operating on a mounted filesystem or not.  If it only operates on
>>>>> mounted
>>>>> filesystems, it almost certainly goes through the kernel, if it only
>>>>> operates on unmounted filesystems, it's almost certainly done in
>>>>> userspace
>>>>> (except dev scan and technically fi show).
>>>>
>>>>
>>>>
>>>> Then btrfs check is a userspace-only matter, as it wants the fs
>>>> unmounted, and it is irrelevant that I did btrfs check from a rescue
>>>> system with an older kernel, 3.16 if I recall correctly.
>>>
>>>
>>>
>>> Not recommended to use older kernel to RW mount or use older fsck to do
>>> repair.
>>> As it's possible that older kernel/btrfsck may allocate extent that cross
>>> the 64K boundary.
>>>
>>>>
>>>>> 2. Regarding general support:  If you're using an enterprise
>>>>> distribution
>>>>> (RHEL, SLES, CentOS, OEL, or something similar), you are almost
>>>>> certainly
>>>>> going to get better support from your vendor than from the mailing list
>>>>> or
>>>>> IRC.
>>>>
>>>>
>>>>
>>>> My "productive" desktops (fan is one of them) run Debian unstable with
>>>> a current vanilla kernel. At the moment, I can't use 4.5 because it
>>>> acts up with KVM.  When I need a rescue system, I use grml, which
>>>> unfortunately hasn't released since November 2014 and is still with
>>>> kernel 3.16
>>>
>>>
>>>
>>> To fix your problem(make these error message just disappear, even they
>>> are
>>> harmless on recent kernels), the most easy one, is to balance your
>>> metadata.
>>
>>
>> I did a balance with filter -musage=100  (kernel/tools 4.5/4.5) of the
>> filesystem mentioned in here:
>> http://www.spinics.net/lists/linux-btrfs/msg51405.html
>>
>> but still   bad metadata [ ),  crossing stripe boundary   messages,
>> double amount compared to 2 months ago
>>
>> Kernel operating this fs has always been maximum 1 month behind
>> 'Latest Stable Kernel' (kernel.org terminology)
>
>
> Would you please try the following patch?
> https://patchwork.kernel.org/patch/8706891/
>
> It is based on v4.5 and I think it should fix the false alert.

I have applied the patch to 4.5 and ran  btrfs check  again and now no
    bad metadata [ ),  crossing stripe boundary   messages anymore
(and also no other errors).
Thanks.

> Thanks,
> Qu
>
>
>>
>>> As I explained, the bug only lies in metadata, and balance will allocate
>>> new
>>> tree blocks, then copy old data into new locations.
>>>
>>> In the allocation process of recent kernel, it will avoid such cross
>>> boundary, and to fix your problem.
>>>
>>> But if you are using old kernels, don't scrub your metadata.
>>>
>>> Thanks,
>>> Qu
>>>>
>>>>
>>>>
>>>> Greetings
>>>> Marc
>>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>
>
