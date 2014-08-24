Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:39935 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaHXP6F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 11:58:05 -0400
Received: by mail-qc0-f178.google.com with SMTP id x3so12583210qcv.23
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 08:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$36b2f$b7fa7666$7edd97f3$7ace6746@cox.net>
References: <CAGQ70evg4N0dU1-hycjQYbUDUwfnH_akTEcNTtAf=2rjtDU7NA@mail.gmail.com>
	<pan$36b2f$b7fa7666$7edd97f3$7ace6746@cox.net>
Date: Sun, 24 Aug 2014 23:58:04 +0800
Message-ID: <CAGQ70euehc2=Q9rRJ1zk7HzobDsbBg8QnVi=-2t3Zhn35xLRzA@mail.gmail.com>
Subject: Re: 6+ MiB/s constant usage on a btrfs volume with kernel 3.16
From: Oon-Ee Ng <ngoonee.talk@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 24, 2014 at 8:57 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Oon-Ee Ng posted on Sun, 24 Aug 2014 17:55:32 +0800 as excerpted:
>
>> I'm using 64-bit Arch Linux. Since update to kernel versions 3.16 and
>> 3.16.1 I'm getting a constant 6+ MiB/s write on my root. Root does not
>> seem to fill up though. Has run for 2 hours straight, and obviously
>> slows everything else down to a crawl.
>>
>> Downgrading to 3.15.8 (last working version for me) solves the symptoms.
>> I'm unsure how to check for root causes, and my distro's mailing list
>> suggested starting here.
>
> I've seen that a couple of times here, but it always goes away when I
> reboot (and / is ro by default here, so it'd be on one of the other btrfs
> partitions, probably /home or /var/log).

Happens a 100% of the time here, annoyingly. As mentioned, 3.15 was
working for me, and still does. Multiple reboots and it happens
immediately on boot even before gdm comes up.
>
> Meanwhile, if you use the compress mount option, you might wish to return
> to 3.14.x temporarily.  There's a bug that can trigger lockups on 3.15+,
> altho a fix should make it to a later 3.16 stable and to 3.17.  The bug
> was a regression for 3.15 so doesn't affect 3.14, and is only a problem
> if you're using (AFAIK or have used) compression.  It's also not as big
> an issue here (on fast ssds with smaller than usual partitions) as it is
> on some people's systems, tho I'm not sure why and I think it has it me a
> time or two, but I've not bothered downgrading as it hasn't been that big
> an issue, here.

I have never used compression and haven't experienced any lockups.
