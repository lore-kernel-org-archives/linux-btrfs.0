Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:43869 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947286Ab3BHXKW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 18:10:22 -0500
Received: by mail-lb0-f176.google.com with SMTP id s4so3385176lbc.35
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 15:10:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM-0MpV83W7VeV07FLFVj-qTWXDBUROBwPHVFha38RftLOwoJQ@mail.gmail.com>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
	<CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
	<20130208213745.GC10931@localhost.localdomain>
	<CAM-0MpWoAXaCqcGLgXGE8s-zSn0fz7n4QUommSgqH0ayi=tJNA@mail.gmail.com>
	<CAM-0MpV83W7VeV07FLFVj-qTWXDBUROBwPHVFha38RftLOwoJQ@mail.gmail.com>
Date: Sat, 9 Feb 2013 00:10:20 +0100
Message-ID: <CAM-0MpVJER0evsOGpMFQXhNfgYtrT2CSreM6fazuAcZ0QYZUFw@mail.gmail.com>
Subject: Re: Fwd: Current State of BTRFS
From: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I just had another big freeze ... I could change to a terminal and
sysrq-triggering gave this: http://pastebin.com/F1jQqtUQ

2013/2/8 Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>:
> Oh ... I should have mentioned that btrfs is running on top of LUKS.
>
> 2013/2/8 Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>:
>> $ btrfs fi df /
>> Data: total=165.00GB, used=164.19GB
>> System, DUP: total=32.00MB, used=28.00KB
>> System: total=4.00MB, used=0.00
>> Metadata, DUP: total=2.00GB, used=1.40GB
>>
>> $ btrfs fi show
>> failed to read /dev/sr0
>> Label: none  uuid: b4ec0b14-2a42-47e3-a0cd-1257e789ed25
>> Total devices 1 FS bytes used 165.59GB
>> devid    1 size 600.35GB used 169.07GB path /dev/dm-0
>>
>> Btrfs Btrfs v0.19
>>
>> ---
>>
>> I just noticed that I can force 'it' by transferring a large file from
>> my NAS. I did the sysrq-trigger thing, but there is no suspicious
>> output in dmesg (http://pastebin.com/swrCdC3U).
>>
>> Anything else?
>>
>> 2013/2/8 Josef Bacik <jbacik@fusionio.com>:
>>> On Fri, Feb 08, 2013 at 02:30:04PM -0700, Florian Hofmann wrote:
>>>> Hi everybody,
>>>>
>>>> I am using btrfs as my main fs for some time now, but I am
>>>> experiencing severe performance drawbacks. I can't qualify the
>>>> circumstances, but sometimes during disc access the whole system
>>>> freezes for some time.
>>>>
>>>> Maybe somebody could suggest some general things I could try to search
>>>> for the problem?
>>>
>>> Can I see
>>>
>>> btrfs fi df /mnt/point
>>> btrfs fi show
>>>
>>> and then when you are having problems
>>>
>>> echo w > /proc/sysrq-trigger
>>>
>>> and capture dmesg.  Thanks,
>>>
>>> Josef
