Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:55080 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751671AbcHZUBA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Aug 2016 16:01:00 -0400
Received: from durkon.lan ([37.201.97.218]) by mrelayeu.kundenserver.de
 (mreue001) with ESMTPSA (Nemesis) id 0MUxAq-1bcLWM02lI-00YC2Z for
 <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 21:53:58 +0200
Received: from haley.lan (haley.lan [192.168.2.21])
        by durkon.lan (Postfix) with ESMTPSA id 37EA81744
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Aug 2016 21:53:56 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 26 Aug 2016 21:53:55 +0200
From: Gert Menke <gert@menke.ac>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Switch raid mode without rebalance?
In-Reply-To: <456dc4ab-f6ae-48d6-94d6-782e56e284e0@gmail.com>
References: <efe09b37f04cbc7754f6c6d84c9070f0@durkon.lan>
 <CANhjow-uihWAQ-MREsT9oAHWoFSHgqi=bXJwV8FJOStyMpC6sw@mail.gmail.com>
 <0981faee57e9de5b29a7150dc89c4092@durkon.lan>
 <456dc4ab-f6ae-48d6-94d6-782e56e284e0@gmail.com>
Message-ID: <adffdbf3b833f464a36a0e38a27d4608@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2016-08-26 13:52, Austin S. Hemmelgarn wrote:

> Regular 'df' isn't to be trusted when dealing with BTRFS, the only
> reason we report anything there is because many things break horribly
> if we don't.
Yeah, I noticed. Seems to produce a reasonable guess, though.

> Additionally, while running with multiple profiles while not balancing
> should work, it's pretty much untested, and any number of things may
> break.
Oh. Good to know.

> Assuming your two disks have similar latency and transfer
> speed, you're almost certainly better off just converting completely
> to single mode (which works like raid0, just at the chunk level
> instead of the block level).
Okay, I see.

> On a slightly separate note, if your doing backups more frequently
> than once a week, your probably better off just leaving the disks
> connected and running.  Regular load/unload cycles are generally
> harder on the mechanical components in modern disks than just leaving
> them running 24/7.
True. A bit of context: I first want to make a full backup locally, then 
use the disks off-site for nightly incremental backups via internet.

Cheers
Gert
