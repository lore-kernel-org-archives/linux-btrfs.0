Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50804 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3KXWbn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 17:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <52927343.9000203@hardwarefreak.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<20131123181208.5103bee4@notabene.brown>
	<52917AA8.1040300@hardwarefreak.com>
	<201311241619.08668.russell@coker.com.au>
	<52927343.9000203@hardwarefreak.com>
Date: Sun, 24 Nov 2013 14:31:42 -0800
Message-ID: <CAK2H+ec12DV6=XXrQMCRoa+kwZs+wafwwvuNweCwaEo5gSReJQ@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Mark Knecht <markknecht@gmail.com>
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: russell@coker.com.au, Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 24, 2013 at 1:44 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
<SNIP>
>> Are you suggesting that it would be a common case that people just write data
>> to an array and never read it or do an array scrub?  I hope that it will
>> become standard practice to have a cron job scrubbing all filesystems.
>
> Given the frequency of RAID5 double drive failure "save me!" help
> requests we see on a very regular basis here, it seems pretty clear this
> is exactly what many users do.

Thank you for reminding me to set this up. Sunday afternoons at 2:30
is now my scrub time.

Cheers,
Mark
