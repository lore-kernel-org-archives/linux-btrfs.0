Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33031 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbDPEZx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 00:25:53 -0400
Received: by iecrt8 with SMTP id rt8so30909165iec.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2015 21:25:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150416014135.6FB5841C60@mx.anathoth.net>
References: <20150416014135.6FB5841C60@mx.anathoth.net>
Date: Wed, 15 Apr 2015 22:25:52 -0600
Message-ID: <CAJCQCtSXEmktk7kCEftAGoen5P2Lq3C2SNdhSLEbTF89XgpTog@mail.gmail.com>
Subject: Re: Btrfs-cleaner FS DoS issues
From: Chris Murphy <lists@colorremedies.com>
To: Matt Grant <matt@mattgrant.net.nz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 15, 2015 at 7:41 PM, Matt Grant <matt@mattgrant.net.nz> wrote:
> Hi!
>
> When ever I delete a large snapshot this stalls all the processes on my system for 30 minutes plus, kernel v19.2. Btrfs-cleaner is taking 100% CPU when completely stalled. Every few minutes its say 99.8% and satall abates and  processes/io happen.
>
> About to lodge a kernel bug about this as it is serious issue.
>
> Could some one look at making the clean up process more sensitive to when the system is idle? MD Raid is very good at this, and it should be possible to set this up.

I suggest reproducing with 4.0.0, and issuing sysrq+t during the hang
if it's just sluggish, or use sysrq+w if you get blocked task
messages, and then attach to a bug report. Then reply to this thread
with the bug URL.



-- 
Chris Murphy
