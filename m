Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:58424 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaLDOZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 09:25:24 -0500
Received: by mail-qc0-f170.google.com with SMTP id x3so12879867qcv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 06:25:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54806C19.4090503@gmail.com>
References: <CAH-HCWUp0yOZRsW2p2kDjw=eeK4_BQ9DgtKCM2MEC4G=9QtM3w@mail.gmail.com>
 <54806C19.4090503@gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Thu, 4 Dec 2014 19:55:03 +0530
Message-ID: <CAH-HCWXXerTeeXGoQhpj-eXO78H45f6rDje4Oh2CDuZDS8-cww@mail.gmail.com>
Subject: Re: System/single + Metadata/single as leftover cruft of mkfs?
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 4, 2014 at 7:43 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> SuSE may have an old version of btrfs-progs then (which wouldn't surprise
> me, it is an 'enterprise' distribution after all), because I haven't seen
> this on anything since 3.16.

Well OK I kinda like the "old" name SuSE since that was the name I was
using back when I was on 9.3, but actually I'm running openSUSE
Tumbleweed. See:

$ btrfs --version
Btrfs v3.17+20141103

I suppose Tumbleweed should be short and clear enough for my future usage.

> Also, for future reference, you can use the switch -mprofiles=single to just
> balance out those chunks.

Wow, thanks, that returned quickly. (Thankfully I did btrfs bal from a
separate terminal can rather than ^C.)

BTW I thought you had unintentionally (for brevity) omitted the
-sprofiles=single and I gave it but it complained saying:

Refusing to explicitly operate on system chunks.
Pass --force if you really want to do that.

So I did give --force. (Is it the same as -f?)

I hope that was OK?

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
