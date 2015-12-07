Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:45538 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191AbbLGCJk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Dec 2015 21:09:40 -0500
Subject: Re: Fixing recursive fault and parent transid verify failed
To: linux-btrfs@vger.kernel.org
References: <20151207015715.GA13954@alistair-xps13>
From: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: Alistair Grant <akgrant0710@gmail.com>
Message-ID: <5664EA5C.6050809@lukas-pirl.de>
Date: Mon, 7 Dec 2015 15:09:32 +1300
MIME-Version: 1.0
In-Reply-To: <20151207015715.GA13954@alistair-xps13>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/07/2015 02:57 PM, Alistair Grant wrote as excerpted:
> Fixing recursive fault, but reboot is needed

For the record:

I saw the same message (incl. hard lockup) when doing a balance on a
single-disk btrfs.

Besides that, the fs works flawlessly (~60GB, usage: no snapshots, ~15
lxc containers, low-load databases, few mails, a couple of Web servers).

As this is a production machine, I rather rebooted the machine instead
of investigating but the error is reproducible if that would be of
great interest.

> I've ran btrfs scrub and btrfsck on the drives, with the output
> included below.  Based on what I've found on the web, I assume that a
> btrfs-zero-log is required.
> 
> * Is this the recommended path?
> * Is there a way to find out which files will be affected by the loss of
>   the transactions?

> Kernel: Ubuntu 4.2.0-19-generic (which is based on mainline 4.2.6)

I used Debian Backports 4.2.6.

Cheers,

Lukas
