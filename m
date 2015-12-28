Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34537 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbbL1Bgs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:36:48 -0500
Received: by mail-ig0-f171.google.com with SMTP id m11so111260734igk.1
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Dec 2015 17:36:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1451265937.6320.26.camel@scientia.net>
References: <1451187536.6446.14.camel@scientia.net>
	<pan$bcf44$1632328c$31564c06$c04774a8@cox.net>
	<1451265688.6320.22.camel@scientia.net>
	<1451265937.6320.26.camel@scientia.net>
Date: Sun, 27 Dec 2015 18:36:47 -0700
Message-ID: <CAJCQCtTbJnRMnymXhOVdPtHph3bGOj2H8fPwy=UTyz6WRhyb4A@mail.gmail.com>
Subject: Re: [BUG?] btrfs scrub -d doesn't scan all devices
From: Chris Murphy <lists@colorremedies.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 27, 2015 at 6:25 PM, Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
> Hey.
>
> Just noted, mine says this:
>>Start a scrub on all devices of the filesystem identified by <path>
>>or on a single <device>. If a scrub is already running, the new one
>>fails.
> still not the text you quoted,... but there it is.
>
> Anyway... it still contradicts the main description which implies that
> a scrub always scrubs everything,... so I'd still call that a
> documentation bug.
>
>
> Further,...
> - Eithr btrfs start allows multiple devices to be specified (which
>   isn't documented either,
> - or it should allow that.
> - or using -d makes no sense when the scrub is launched on a device
>   (instead of a mount point) and should thus fail or give at least a
>   warning.


https://bugzilla.kernel.org/show_bug.cgi?id=110051


-- 
Chris Murphy
