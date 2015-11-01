Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36065 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbKAOHK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Nov 2015 09:07:10 -0500
Received: by lbjm5 with SMTP id m5so73213127lbj.3
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Nov 2015 06:07:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151101184844.0d67e5e2@natsu>
References: <CAAvdE8So0SeT5q1bH5v2Awzm458Gi3CiSWqhVudg=vC-=Bqqtg@mail.gmail.com>
	<20151101184844.0d67e5e2@natsu>
Date: Sun, 1 Nov 2015 09:07:08 -0500
Message-ID: <CAAvdE8T8AzeENxgYDvTTCN7H2RsBZg07mv+KsuPDG7AdLixCxA@mail.gmail.com>
Subject: Re: trying to balance, filesystem keeps going read-only.
From: Ken Long <kelargo1000@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes, the one drive is that Seagate 8TB drive..

Smart tools doesn't show anything outrageous or obvious in hardware.

Is there any other info I can provide to isolate, troubleshoot further?

I'm not sure how to correlate the dmesg message to a specific drive,
SATA cable etc..



On Sun, Nov 1, 2015 at 8:48 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Sun, 1 Nov 2015 06:24:53 -0500
> Ken Long <kelargo1000@gmail.com> wrote:
>
>> Well, one drive is 8TB with a 5TB partition.
>
> Is this by any chance a Seagate "SMR" drive? From what I remember seeing on
> the list, those do not work well with Btrfs currently, with symptoms very
> similar to what you're seeing.
>
> --
> With respect,
> Roman
