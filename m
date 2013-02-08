Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41222 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947176Ab3BHXMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 18:12:19 -0500
Received: by mail-lb0-f180.google.com with SMTP id q12so3383907lbc.11
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Feb 2013 15:12:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvjh8jF5U4gWbYOw0_x1pYQ6p2MDU_W4kcp4oeP9T4wu5Q@mail.gmail.com>
References: <CAM-0MpVDJ+TGC6x9JHd+wG5dsACdN4Y+JFgksQCsiwzGQYNanA@mail.gmail.com>
	<CAM-0MpXTU5KUAy0tEcMu_eh5Fa75kEkUiuY8NBV-RpWp1GtypQ@mail.gmail.com>
	<20130208213745.GC10931@localhost.localdomain>
	<CAM-0MpWoAXaCqcGLgXGE8s-zSn0fz7n4QUommSgqH0ayi=tJNA@mail.gmail.com>
	<CAM-0MpV83W7VeV07FLFVj-qTWXDBUROBwPHVFha38RftLOwoJQ@mail.gmail.com>
	<CAE5mzvjh8jF5U4gWbYOw0_x1pYQ6p2MDU_W4kcp4oeP9T4wu5Q@mail.gmail.com>
Date: Sat, 9 Feb 2013 00:12:17 +0100
Message-ID: <CAM-0MpUD-9j4zS58xCp5qu6e1SLMR9jHbQM95k9hhKbxK3FifA@mail.gmail.com>
Subject: Re: Fwd: Current State of BTRFS
From: Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>
To: cwillu <cwillu@cwillu.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I ran it as root. The first times there was no output whatsoever. This
time triggering gave the SysRq : Show Blocked State line. Strange

2013/2/9 cwillu <cwillu@cwillu.com>:
> On Fri, Feb 8, 2013 at 4:56 PM, Florian Hofmann
> <fhofmann@techfak.uni-bielefeld.de> wrote:
>> Oh ... I should have mentioned that btrfs is running on top of LUKS.
>>
>> 2013/2/8 Florian Hofmann <fhofmann@techfak.uni-bielefeld.de>:
>>> $ btrfs fi df /
>>> Data: total=165.00GB, used=164.19GB
>>> System, DUP: total=32.00MB, used=28.00KB
>>> System: total=4.00MB, used=0.00
>>> Metadata, DUP: total=2.00GB, used=1.40GB
>>>
>>> $ btrfs fi show
>>> failed to read /dev/sr0
>>> Label: none  uuid: b4ec0b14-2a42-47e3-a0cd-1257e789ed25
>>> Total devices 1 FS bytes used 165.59GB
>>> devid    1 size 600.35GB used 169.07GB path /dev/dm-0
>>>
>>> Btrfs Btrfs v0.19
>>>
>>> ---
>>>
>>> I just noticed that I can force 'it' by transferring a large file from
>>> my NAS. I did the sysrq-trigger thing, but there is no suspicious
>>> output in dmesg (http://pastebin.com/swrCdC3U).
>>>
>>> Anything else?
>
> The pastebin didn't include any output from sysrq-w; even if there's
> nothing to report there would still be a dozen lines or so per cpu; at
> the absolute minimum there should be a line for each time you ran it:
>
> [4477369.680307] SysRq : Show Blocked State
>
> Note that you need to echo as root, or use the keyboard combo
> alt-sysrq-w to trigger.
