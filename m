Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab3HAR7z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 13:59:55 -0400
Date: Thu, 1 Aug 2013 10:59:50 -0700
From: Zach Brown <zab@redhat.com>
To: dsterba@suse.cz, Mike Audia <mikey_a@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: Is the checkpoint interval adjustable?
Message-ID: <20130801175950.GC12314@lenny.home.zabbo.net>
References: <20130731221008.156770@gmx.com>
 <20130731225640.GO32145@lenny.home.zabbo.net>
 <20130801154032.GY24343@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130801154032.GY24343@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> There were a few requests to tune the interval. This finally made me to
> finish the patch and will send it in a second.

Great, thanks.

> That's a good point and lowers my worries a bit, though it would be
> interesting to see in what way a beefy machine blows with 300 seconds
> set.

Agreed.  Ideally the transaction machinery decides at some point that a
transaction is sufficiently huge that it'll saturate the storage
pipeline and kicks it off.

- z
