Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:42916 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbeA2R6Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 12:58:24 -0500
Received: by mail-lf0-f45.google.com with SMTP id q17so11274278lfa.9
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 09:58:23 -0800 (PST)
Subject: Re: degraded permanent mount option
To: Adam Borowski <kilobyte@angband.pl>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <pan$49d38$869e8d62$c0063169$584b8866@cox.net>
 <20180128003910.GA31699@polanet.pl>
 <CAJCQCtSo12iFeyg3DSWNmOwtXHHk_sdg_MDJUrAM+Q1oaOJcAA@mail.gmail.com>
 <20180128223946.GA26726@polanet.pl>
 <CAJCQCtQi+Lks6SxrGkyQ1xF-_mJM2bDYMiBnQXt6hk7qikuwWA@mail.gmail.com>
 <20180129085404.GA2500@polanet.pl>
 <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <dd2863d2-6f50-47b4-06a9-f34e7b341f2f@gmail.com>
Date: Mon, 29 Jan 2018 20:58:20 +0300
MIME-Version: 1.0
In-Reply-To: <20180129112456.r7ksq5mwp3ie6gmg@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

29.01.2018 14:24, Adam Borowski пишет:
...
> 
> So any event (the user's request) has already happened.  A rc system, of
> which systemd is one, knows whether we reached the "want root filesystem" or
> "want secondary filesystems" stage.  Once you're there, you can issue the
> mount() call and let the kernel do the work.
> 
>> It is a btrfs choice to not expose compound device as separate one (like
>> every other device manager does)
> 
> Btrfs is not a device manager, it's a filesystem.
> 
>> it is a btrfs drawback that doesn't provice anything else except for this
>> IOCTL with it's logic
> 
> How can it provide you with something it doesn't yet have?  If you want the
> information, call mount().  And as others in this thread have mentioned,
> what, pray tell, would you want to know "would a mount succeed?" for if you
> don't want to mount?
> 
>> it is a btrfs drawback that there is nothing to push assembling into "OK,
>> going degraded" state
> 
> The way to do so is to timeout, then retry with -o degraded.
> 

That's possible way to solve it. This likely requires support from
mount.btrfs (or btrfs.ko) to return proper indication that filesystem is
incomplete so caller can decide whether to retry or to try degraded mount.

Or may be mount.btrfs should implement this logic internally. This would
really be the most simple way to make it acceptable to the other side by
not needing to accept anything :)
