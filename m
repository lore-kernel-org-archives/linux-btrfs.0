Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35940 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbL2EFV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Dec 2015 23:05:21 -0500
Received: by mail-wm0-f47.google.com with SMTP id l65so21927821wmf.1
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 20:05:21 -0800 (PST)
Date: Mon, 28 Dec 2015 19:03:36 -0500
From: Sanidhya Solanki <jpage.lkml@gmail.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
Message-ID: <20151228190336.59a3f440@gmail.com>
In-Reply-To: <1451360528.7094.7.camel@scientia.net>
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
	<1451341195.7094.0.camel@scientia.net>
	<20151228153801.6561feff@gmail.com>
	<1451352069.7094.3.camel@scientia.net>
	<20151228164333.2b8d8336@gmail.com>
	<1451360528.7094.7.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 29 Dec 2015 04:42:08 +0100
Christoph Anton Mitterer <calestyo@scientia.net> wrote:

> On Mon, 2015-12-28 at 16:43 -0500, Sanidhya Solanki wrote:
> May get even much more complicated, if reshaping (i.e. conversion from
> one chunk size to another) should get implemented as well...

That sounds like an absolutely ghastly idea. Lots of potential for
mistakes and potential data loss. I take up the offer to implement
such a feature. 
Only question is should it be in-place replacement or replace out to
another disk or storage type. Will wait for comments on that question
before implementing. 

> Sure :)
> Being able to set the RAID chunk size makes AFAIU sense for every RAID
> level, depending which IO patterns one has (i.e. even for RAID1).

I do not understand this part. Is the stripe size not independent of
the RAID type? To me it would seem that the filesystem just treats the
RAID type as a means of duplicating (if in the case of a redundant
RAID) or parallelizing data (in case of "R"AID 0), as opposed to the
Stripe length, which is a measure of each logical block for the
filesystem.

Thanks.
