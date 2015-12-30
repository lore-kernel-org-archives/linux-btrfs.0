Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35921 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbbLaBVF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 20:21:05 -0500
Date: Wed, 30 Dec 2015 16:19:09 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, calestyo@scientia.net, clm@fb.com,
        jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151230161909.34bfc832@gmail.com>
In-Reply-To: <20151230155805.GE4227@twin.jikos.cz>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<20151229133907.GA4227@suse.cz>
	<20151229061512.79a41f31@gmail.com>
	<20151229170611.GB4227@suse.cz>
	<20151230013946.7c1f0e12@gmail.com>
	<5683C714.4040705@gmx.com>
	<20151230045449.7a6c14db@gmail.com>
	<5683E5E4.5010006@gmx.com>
	<20151230061523.1d442f54@gmail.com>
	<20151230155805.GE4227@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 30 Dec 2015 16:58:05 +0100
David Sterba <dsterba@suse.cz> wrote:

> On Wed, Dec 30, 2015 at 06:15:23AM -0500, Sanidhya Solanki wrote:

> > - Implement a way to do an in-place Stripe Length change.
>
> How are you going to implement that? I've suggested the balance filter
> style of conversion, which is not in-place so I'm curious what do you
> mean by in-place.

As CAM suggested, it would basically be a CoW, with a checksum
comparison at the end to make sure no data has been corrupted.

In-place: Without taking the drives or filesystem offline or unmounting
them. Doing the conversion while the rest of the RAID is in use.
Risky, slow, but possible, given enough time for large data sets.

Thanks.
