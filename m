Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38594 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753675AbaDVSlr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 14:41:47 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Slow Write Performance w/ No Cache Enabled and Different Size Drives
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140422175619.GC30423@carfax.org.uk>
Date: Tue, 22 Apr 2014 12:41:45 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <49D06F0C-D88F-4ACD-9FCF-402B094EEB5E@colorremedies.com>
References: <53540367.4050707@aeb.io> <D954AF21-BC14-4ADC-9C62-254753AF1998@colorremedies.com> <5354A4EA.3000209@aeb.io> <pan$ced8d$1ee3475f$a3c53cfd$a3dfb247@cox.net> <BDB8ED64-0A92-4C22-A07D-C06D790410ED@colorremedies.com> <20140422175619.GC30423@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 22, 2014, at 11:56 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>   Also not helped by btrfs's co-option of the term "RAID-1" to mean
> something that's not traditional RAID-1, and (internally) "stripe" and
> "chunk" to mean things that don't match (I think) any of the
> definitions above…

Right. Although in btrfs's defense, if there's a single term that no one agrees on it's stripe. If any word ought to be deprecated as functionally useless beyond repair, it's that one.

But no, what SNIA did was deprecate chunk leaving it in some sense fair game for anyone to use a generic and otherwise meaningless term like btrfs does. Except for the fact that most everywhere else including md/mdadm it is very much in-use, means a very specific thing, and should not have been usurped for that reason alone.

I have an idea, let's have a gram and grame. Gram is gram, but grame is kilogram. The e will be silent, and makes the a change from a short sound to a long sound. And we'll make grame element equal to a gram, just in case people need a compound word when a single word for the base unit should be sufficient. And then we'll deprecate kilogram. Perfect! It's not confusing AT ALL! Everyone will love and adopt this right away instead of completely totally ignore it.

Truly, we are apes that just happen to wear pants.

Chris Murphy