Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34130 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933124AbcJUNT5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 09:19:57 -0400
Received: by mail-qk0-f175.google.com with SMTP id f128so146432082qkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Oct 2016 06:19:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG6KGPTU0U1=WCA9cZgXrYtm=yDJFZDH+x2v7RtS=6RzmGzRTA@mail.gmail.com>
References: <CAG6KGPS8Gvy2zGCe22mMmk4uXrqVyRP8FHayhe0ph-8vC+kA4A@mail.gmail.com>
 <CAG6KGPSeR1zAuU0Xo9DrEpd-0QC9agB7p7z+Lb69hxS233_Cvg@mail.gmail.com>
 <20161010234227.69746d3f@natsu> <CAJCQCtQh2C95=ug3x7wT98CA-fRAVXxd5Ghz4suYkENFCf8jQg@mail.gmail.com>
 <CAG6KGPTU0U1=WCA9cZgXrYtm=yDJFZDH+x2v7RtS=6RzmGzRTA@mail.gmail.com>
From: Martin Dev <mrturtledev@gmail.com>
Date: Fri, 21 Oct 2016 14:19:55 +0100
Message-ID: <CAG6KGPRy4xisK_H2RZm-==xuBtsRyqdZ5O=8=UE_MF1434gDHQ@mail.gmail.com>
Subject: Re: csum failed during copy/compare
To: Chris Murphy <lists@colorremedies.com>
Cc: Roman Mamedov <rm@romanrm.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

SATA trace shows device behaving correctly.
btrfs repair --ignore-errors /dev/sda2 /tmp/ will yield files that are
not verifiable by FIO, and differ from the original files on the
internal drive that they were copied from at the failing offset.

On Wed, Oct 19, 2016 at 3:39 PM, Martin Dev <mrturtledev@gmail.com> wrote:
> Fails on Antergos Linux 4.8.2-1-ARCH #1 SMP PREEMPT Mon Oct 17
> 08:11:46 CEST 2016 x86_64 GNU/Linux
>
> btrfs-progs v4.8.1
>
> On Mon, Oct 10, 2016 at 10:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Mon, Oct 10, 2016 at 12:42 PM, Roman Mamedov <rm@romanrm.net> wrote:
>>> On Mon, 10 Oct 2016 10:44:39 +0100
>>> Martin Dev <mrturtledev@gmail.com> wrote:
>>>
>>>> I work for system verification of SSDs and we've recently come up
>>>> against an issue with BTRFS on Ubuntu 16.04
>>>
>>>> This seems to be a recent change
>>>
>>> ...well, a change in what?
>>>
>>> If you really didn't change anything on your machines and the used process,
>>> there is no reason for anything to start breaking, other than obvious hardware
>>> issues from age/etc (likely not what's happening here).
>>>
>>> So you most likely did change something yourself, and perhaps the change was
>>> upgrading OS version, kernel version(!!!), or versions of software in general.
>>>
>>> As such, the first suggestion would be go through the recent software updates
>>> history, maybe even restore an OS image you used three months ago (if
>>> available) and confirm that the problem doesn't occur there. After that it's a
>>> process called bisecting, there are tools for that, but likely you don't even
>>> need those yet, just carefully note when you got which upgrades, paying
>>> highest attention to the kernel version, and note at which point the
>>> corruptions start to occur.
>>
>>
>> There  have been various trim bugs, in Btrfs but also in the block
>> layer. And I don't remember all the different versions involved.  I'd
>> like to think 4.4.24 should behave the same as 4.8.1, so I would
>> retest with those two, using something without ubuntu specific
>> backports (i.e. something as close to the kernel.org trees of those
>> versions as possible). I have no idea what Ubuntu generic 4.4.0-21
>> translates into. Because of the 0, it makes me think it's literally
>> 4.4.0 with 21 sets of various backports, from some unknown time frame
>> without going and looking it up. If that's really 4.4.21, then it's
>> weirdly named, I don't know why any distro would do that.
>>
>> In any case I would compare 4.8.1 and 4.4.24 because those two should
>> work and if not it's a bug that needs to get fixed. Independently,
>> check the SSD firmware. There have been bugs there also.
>>
>> --
>> Chris Murphy
