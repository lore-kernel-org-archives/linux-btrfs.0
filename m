Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33487 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbcCMVbF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 17:31:05 -0400
Received: by mail-io0-f173.google.com with SMTP id n190so202528622iof.0
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 14:31:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160313205026.GU2334@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160312195746.GJ2334@torres.zugschlus.de>
	<CAJCQCtSmHAs_zMt3kHdCL9Nd+aAMW-2nDSNYXhizwan8OL3mGw@mail.gmail.com>
	<20160313205026.GU2334@torres.zugschlus.de>
Date: Sun, 13 Mar 2016 15:31:03 -0600
Message-ID: <CAJCQCtQQghWgM8fikyrFGfJhBgJ-N7Mni0pAvp-LMFpzCQ=NfQ@mail.gmail.com>
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2016 at 2:50 PM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Sun, Mar 13, 2016 at 01:43:50PM -0600, Chris Murphy wrote:
>> On Sat, Mar 12, 2016 at 12:57 PM, Marc Haber
>> <mh+linux-btrfs@zugschlus.de> wrote:
>> > On Sat, Mar 05, 2016 at 12:34:09PM -0700, Chris Murphy wrote:
>> >> Something is happening with the usage of this file system that's out
>> >> of the ordinary. This is the first time I've seen such a large amount
>> >> of unused metadata allocation. And then for it not only fail to
>> >> balance, but for the allocation amount to increase is a first. So
>> >> understanding the usage is important to figuring out what's happening.
>> >> I'd file a bug and include as much information on how the fs got into
>> >> this state as possible. And also if possible make a btrfs-image using
>> >> the proper flags to blot out the filenames for privacy. And what
>> >> btrfs-progs tools were used to create this file system. Etc.
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=114451
>> >
>> > Please advise if there is something missing.
>>
>> No enospc_debug mount option used for kernel messages.
>
> I apologize for not having this mentioned, but why do you think that
> it wasn't active?

No additional information in the log attached to the bug. So I guess
this particular problem doesn't trigger any enospc debug options and
hence the patch.


>
> |[28/527]mh@fan:~$ grep enospc /proc/mounts
> |/dev/mapper/fanbtr / btrfs rw,noatime,nodiratime,ssd,space_cache,enospc_debug,subvolid=257,subvol=/fan-root 0 0
> |/dev/mapper/fanbtr /mnt/snapshots/fanbtr btrfs rw,noatime,nodiratime,ssd,space_cache,enospc_debug,subvolid=266,subvol=/snapshots 0 0
> |[29/528]mh@fan:~$
>
>>  And no indication you applied Qu's patch mentioned on March 1 to get
>>  more info with enospc_debug mount:
>>
>> >Oh, I'm sorry that the output is not necessary, it's better to use the newer patch:
>> >https://patchwork.kernel.org/patch/8462881/
>> >With the newer patch, you will need to use enospc_debug mount option to get the debug information.
>
> That one didn't make it in 4.4.5 yet?

I got no indication it was even going to make it into mainline
actually, I was thinking it was a one off patch. But if it does, it'll
need to be in 4.5.0 before it'd be backported to 4.4.x. Maybe Qu can
clarify?

-- 
Chris Murphy
