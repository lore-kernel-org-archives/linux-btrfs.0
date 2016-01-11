Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38738 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760308AbcAKPwW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 10:52:22 -0500
Received: by mail-wm0-f53.google.com with SMTP id b14so275469433wmb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 07:52:22 -0800 (PST)
Date: Mon, 11 Jan 2016 06:49:56 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.cz>,
        jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20160111064956.573ec21b@gmail.com>
In-Reply-To: <1452527015.7801.1.camel@scientia.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net>
	<20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net>
	<20151228164333.2b8d8336@gmail.com>
	<1451360528.7094.7.camel@scientia.net>
	<20151228190336.59a3f440@gmail.com>
	<1451363188.7094.23.camel@scientia.net>
	<20151229180643.GD4227@twin.jikos.cz>
	<20160102065207.4eec760a@gmail.com>
	<56887B40.10105@gmx.com>
	<20160109221105.6b18fb8e@gmail.com>
	<1452527015.7801.1.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 11 Jan 2016 16:43:35 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> On Sat, 2016-01-09 at 22:11 -0500, Sanidhya Solanki wrote:
> > I have also left the option to use an un-conventional stripe size to
> > the
> > user, for e.g., 768, 3072, 6144, etc.
> 
> Not sure whether it's such a good idea to allow this,... at least not
> without requiring some --force option.
> This seems to provoke all kinds of alignment issues,... also, but
> probably not limited to, for any loopdevices created on top of a
> btrfs.

I considered that, but, if you read the specification of modern HDDs
carefully, it states that they are 4K or 512e sector size compatible,
hence the concession. Also, older drive users may find this preferable.
