Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37854 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbcDRQSu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Apr 2016 12:18:50 -0400
Received: by mail-ig0-f182.google.com with SMTP id g8so84395725igr.0
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Apr 2016 09:18:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <571502B4.2050401@gmail.com>
References: <CALq5X_gB0YkRMZx7Af+gAYdYRhojiKSCV9r3g8YPG6_8YR+9DQ@mail.gmail.com>
	<5714D39B.90402@gmail.com>
	<CAJCQCtRQ_1-peN6QVd53P63xQUqxfvmth4aEbwXrpaCyjVds=Q@mail.gmail.com>
	<5714FA2F.6010207@gmail.com>
	<CAJCQCtTSdnD+n9UR7hWtqLdBzjb6WQXF71XKTgKJNgZPcdA3fg@mail.gmail.com>
	<571502B4.2050401@gmail.com>
Date: Mon, 18 Apr 2016 10:18:49 -0600
Message-ID: <CAJCQCtTNKh-qdUAhBPgwThqxzCBwTiOmqiMYr4zmDaTtm=yezg@mail.gmail.com>
Subject: Re: Install to or Recover RAID Array Subvolume Root?
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Alcorn <nroclaed@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 18, 2016 at 9:52 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-04-18 11:39, Chris Murphy wrote:
>>
>> On Mon, Apr 18, 2016 at 9:15 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>>
>>>>
>>> I don't know about the current state of the Debian installer, but I know
>>> back when I used Debian regularly and used the standard text based
>>> installer, as long as I didn't format things from the UI, I could
>>> provision
>>> the filesystems however the hell I wanted manually and point the
>>> installer
>>> at the appropriate ones for each mount point, and it worked.
>>
>>
>> No doubt this is a catch 22. I think it's reasonable for an installer
>> to have an aging logic that allows it to be more conservative than the
>> kernel's support for compat_ro_flags and incompat_flags, and refuse to
>> install if it's not recently formatted.
>>
>> Now that I go look for this, I'm not sure what either flags offset
>> 0x38 or compat_flags offset 0xac are about.
>>
>> Also, I didn't mention that Anaconda does require root fs to be in a
>> new subvolume. It won't install to either subvolid 5, or any other
>> existing subvolume.
>>
> I'm not certain about how Debian would handle it, but I think they'll assume
> that the user knows what they're doing and just do what they say (which can
> admittedly be a very dangerous assumption sometimes).
>
> Like I said in one of my earlier e-mails though, these kind of limitations
> are part of why I switched to Gentoo, there's no GUI installer, but you can
> put the system together however the hell you want (which is especially nice
> with BTRFS, because none of the installers out there will let you use BTRFS
> on top of LVM, which is useful for things like BTRFS raid1 on top of
> DM-RAID0).

In a GUI context, the OS installer should be point and shoot to a
volume. It shouldn't care how it was built. Partitioning is a separate
thing. But in Linux land, these things get conflated, and makes them
more complicated and buggy. The result is excessive resources
maintaining and fixing them all the time.


-- 
Chris Murphy
