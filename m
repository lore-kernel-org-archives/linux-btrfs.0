Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35863 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbbKAOdf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 09:33:35 -0500
Received: by lbjm5 with SMTP id m5so73419492lbj.3
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 06:33:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151101191730.298dcff4@natsu>
References: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
	<20151101184844.0d67e5e2@natsu>
	<CAAvdE8T8AzeENxgYDvTTCN7H2RsBZg07mv+KsuPDG7AdLixCxA@mail.gmail.com>
	<20151101191730.298dcff4@natsu>
Date: Sun, 1 Nov 2015 09:33:34 -0500
Message-ID: <CAAvdE8QrXGnGeDC+w8PY7Cx1Q7uF9xLWcF+ASLVi59sL_aKd2w@mail.gmail.com>
Subject: Re: trying to balance, filesystem keeps going read-only.
From: Ken Long <kelargo1000@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I get a similar read-only status when I try to remove the drive from the array..

Too bad the utility's function can not be slowed down.. to avoid
triggering this error... ?

I had some success putting data *onto* the drive by croning sync every
two seconds in a different terminal.

Doesn't seem to be fixed yet..
https://bugzilla.kernel.org/show_bug.cgi?id=93581


On Sun, Nov 1, 2015 at 9:17 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Sun, 1 Nov 2015 09:07:08 -0500
> Ken Long <kelargo1000@gmail.com> wrote:
>
>> Yes, the one drive is that Seagate 8TB drive..
>>
>> Smart tools doesn't show anything outrageous or obvious in hardware.
>>
>> Is there any other info I can provide to isolate, troubleshoot further?
>>
>> I'm not sure how to correlate the dmesg message to a specific drive,
>> SATA cable etc..
>
> See this discussion: http://www.spinics.net/lists/linux-btrfs/msg48054.html
>
> My guess is these drives need to do a lot of housekeeping internally,
> especially during heavy write load or random writes, and do not reply to the
> host machine in time, which translates into those "frozen [...] failed
> command: WRITE FPDMA QUEUED" failures.
>
> I did not follow the issue closely enough to know if there's a solution yet, or
> even if this is specific to Btrfs or to GNU/Linux in general. Maybe your best
> bet would be to avoid using that drive in your Btrfs array altogether for the
> time being.
>
> --
> With respect,
> Roman
