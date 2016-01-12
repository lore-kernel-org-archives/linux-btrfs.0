Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:33095 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbcALQJm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 11:09:42 -0500
Received: by mail-wm0-f44.google.com with SMTP id f206so260379941wmf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jan 2016 08:09:42 -0800 (PST)
Date: Tue, 12 Jan 2016 07:07:30 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>, David Sterba <dsterba@suse.cz>,
        jbacik@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20160112070730.7c8c91e2@gmail.com>
In-Reply-To: <5694F025.1000800@gmail.com>
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
	<20160111064956.573ec21b@gmail.com>
	<1452527868.7801.2.camel@scientia.net>
	<5694F025.1000800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 12 Jan 2016 07:23:01 -0500
"Austin S. Hemmelgarn" <ahferroin7@gmail.com> wrote:

> 768 I don't know, the other two though would provide proper 
> stripe-alignment on a 8 or 14 disk hardware RAID6 setup using 512
> byte sectors (that is, one stripe in BTRFS would span the full array).
> 
> I personally think it should be restricted to multiples of 512, as
> that is the smallest sector size on any disk drive that is
> realistically usable with BTRFS.  That would also provide 4k support,
> and beyond that 64k (which is where the really big drives are headed
> anyway), and also provide the ability to get proper stripe alignment
> on almost any hardware RAID configuration.

Alright, I guess that makes the implementation slightly easier. I will
implement it as only multiples of 512.

Thanks for you input everyone.
