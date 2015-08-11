Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:36575 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964890AbbHKOUN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 10:20:13 -0400
Received: by lagz9 with SMTP id z9so71834822lag.3
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 07:20:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55C9F68B.9070309@gmail.com>
References: <CAC+fKQUhwxYkMcCtmnh__EMAh0CjmmM7XE0+roegBCL9=vOuiA@mail.gmail.com>
	<55C9F68B.9070309@gmail.com>
Date: Tue, 11 Aug 2015 16:20:11 +0200
Message-ID: <CAC+fKQUDmh+1S3Nf_o47nsL0C2Ts1G7SUwMicRWO_qXq9imN_Q@mail.gmail.com>
Subject: Re: Usage of new added disk not updated while doing a balance
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-08-11 15:20 GMT+02:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
> How much slack space was allocated by BTRFS before running the balance (ie,
> how big a difference was there between the allocated and used space), and
> did the balance run to completion?  If you had a lot of mostly empty chunks
> and stopped the balance part way through, then this is what I would expect
> to happen (balance back-fills partial chunks before it starts allocating new
> ones).
>
> If that is not the case however, then this is very much _not_ normal, and is
> almost certainly a bug, in which case you should make sure any important
> data on the filesystem is backed up before doing anything further with it
> (including unmounting it or rebooting the system).
>

I don't have the usage numbers before running the balance, but I have
around 1000 readonly snapshots, so maybe that's a factor.

It keeps running and using both CPU and IO, so I'll wait to see what happens.

Thank you.

-- 
Juan Orti
https://miceliux.com
