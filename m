Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33841 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbbL2Ajm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 19:39:42 -0500
Received: by mail-wm0-f65.google.com with SMTP id l126so51389089wml.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 16:39:41 -0800 (PST)
Date: Mon, 28 Dec 2015 15:38:01 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151228153801.6561feff@gmail.com>
In-Reply-To: <1451341195.7094.0.camel@scientia.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 28 Dec 2015 23:19:55 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> On Mon, 2015-12-28 at 07:24 -0500, Sanidhya Solanki wrote:
> > An option to select the RAID Stripe size is made
> > available in the BTRFS Filesystem, via an option
> > in the BTRFS Config setup
> Shouldn't that rather eventually become configurable per filesystem?
> 
> Cheers,
> Chris.

Don't know. It was in the BTRFS File todo list, hence the
BTRFS-specific patch.

Thanks
