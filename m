Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:35915 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbbGaFpy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 01:45:54 -0400
Received: by qgeh16 with SMTP id h16so39215046qge.3
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2015 22:45:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55BB0A39.1050208@cn.fujitsu.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
	<CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
	<55BAFEF9.1070107@cn.fujitsu.com>
	<CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
	<55BB0A39.1050208@cn.fujitsu.com>
Date: Thu, 30 Jul 2015 22:45:53 -0700
Message-ID: <CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: John Ettedgui <john.ettedgui@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 30, 2015 at 10:40 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>

>
> It seems that you're using Chromium while doing the dump. :)
>
Ooops I did not think that would be an issue :/
> If no CD drive, I'll recommend to use Archlinux installation iso to make a
> bootable USB stick and do the dump.
> (just download and dd would do the trick)
> As its kernel and tools is much newer than most distribution.
Sure that's the distribution I use anyway. :)
I should have some usb stick somewhere to try it.
>
> It's better to provide two trace.
> One is the function tracer one, with "btrfs:*" as set_event.
> The other is the function_graph one. with "btrfs_mount" as
> set_graph_function.
>
Oh I see, I will try that.
> Thanks for your patient to help improving btrfs.
Well, thank you for helping me out here!
> Although I may not be able to check the trace until next Monday... :(
>
Oh that's fine, I can live with a one extra minute reboot for a few more days.
> Thanks,
> Qu
>
>
Thanks!
John
