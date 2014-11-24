Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47548 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaKXMft (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 07:35:49 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so5482801wiv.6
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 04:35:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>
	<20141122222606.GO8916@merlins.org>
	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>
	<20141123000503.GQ32735@carfax.org.uk>
	<20141123010742.GA16599@merlins.org>
	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>
	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>
	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>
Date: Mon, 24 Nov 2014 13:35:47 +0100
Message-ID: <CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 November 2014 at 05:23, Duncan <1i5t5.duncan@cox.net> wrote:
> Patrik Lundquist posted on Sun, 23 Nov 2014 16:12:54 +0100 as excerpted:
>
>> The balance run now finishes without errors with usage=99 and I think
>> I'll leave it at that. No RAID yet but will convert to RAID1.
>
> Converting between raid modes is done with a balance, so if you can't get
> that last bit to balance, you can't do a full conversion to raid1.

Good point! It slipped my mind. I'll report back if incremental
balances eventually solves the balance after conversion ENOSPC
problem.
