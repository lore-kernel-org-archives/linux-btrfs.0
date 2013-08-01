Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab3HAPkd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 11:40:33 -0400
Date: Thu, 1 Aug 2013 17:40:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: Mike Audia <mikey_a@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: Is the checkpoint interval adjustable?
Message-ID: <20130801154032.GY24343@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130731221008.156770@gmx.com>
 <20130731225640.GO32145@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130731225640.GO32145@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 03:56:40PM -0700, Zach Brown wrote:
> >  I am NO programmer by any stretch.  Let's say I want them to be once
> > every 5 min (300 sec).  Is the attached patch sane to acheive this?
> 
> I think it's a reasonable patch to try, yeah.

There were a few requests to tune the interval. This finally made me to
finish the patch and will send it in a second.

> >  Are there any unforeseen and effects of doing this?  Thank you for
> > the consideration.
> 
> I don't *think* that there should be.  One way of looking at it is that
> both 30 and 300 seconds are an *eternity* for cpu, memory, and storage.
> Any trouble that you could get in to in 300 seconds some other machine
> could trivially get in to in 30 with beefier hardware.

That's a good point and lowers my worries a bit, though it would be
interesting to see in what way a beefy machine blows with 300 seconds
set.

david
