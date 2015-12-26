Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34532 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbLZEen (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 23:34:43 -0500
Received: by mail-ig0-f177.google.com with SMTP id m11so97717657igk.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 20:34:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151226070004.461eebaf@natsu>
References: <20151226070004.461eebaf@natsu>
Date: Fri, 25 Dec 2015 21:34:43 -0700
Message-ID: <CAJCQCtRTNgUFnjGyF6wBeiX2LzMjO8Avc8xGb9NAFLnvgGyM3Q@mail.gmail.com>
Subject: Re: Deadlock after upgrade to 4.1
From: Chris Murphy <lists@colorremedies.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This could be an unintended regression, I'm not finding much related
at all in recent history in the traces. I'd say reproduce and get a
sysrq+w captured. Most of the traces are actually from rdiff-backup,
but the first one is a kworker. So something happens and then due to
the ensuing congestion it all just gets worse. Maybe it would have
eventually recovered but once it's this congested it might have taken
a really long time.

I would then also try to reproduce with 4.2.8 or 4.3.3 because those
have ~ 25% backports than made it to 4.1.15, so there's an off chance
it's fixed there. But even better to just go straight to 4.4.rc6 if
you can, because an unintended regression that's not known will likely
happen in 4.4 and would need to be fixed now before it'd get
backported anyway. *shrug*


Chris Murphy
