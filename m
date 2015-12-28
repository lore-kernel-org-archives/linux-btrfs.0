Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33456 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbbL2BpR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 20:45:17 -0500
Received: by mail-wm0-f43.google.com with SMTP id f206so24445618wmf.0
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 17:45:17 -0800 (PST)
Date: Mon, 28 Dec 2015 16:43:33 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151228164333.2b8d8336@gmail.com>
In-Reply-To: <1451352069.7094.3.camel@scientia.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net>
	<20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Dec 2015 02:21:09 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> On Mon, 2015-12-28 at 15:38 -0500, Sanidhya Solanki wrote:
> > > Shouldn't that rather eventually become configurable per
> > > filesystem?
> > Don't know. It was in the BTRFS File todo list, hence the
> > BTRFS-specific patch.
> Uhm you misunderstood me =)
> 
> I meant, configurable per instance of a btrfs filesystem, i.e. at e.g.
> (btr)fs-creation time, rather than compiled into the kernel. =)
> 
> Cheers,
> Chris.

Apologies, it appears I did misunderstand. That should be possible,
though slightly complicated. I will try to get that done. But I am
leaving this patch open for acceptance and comments.

Thanks.
