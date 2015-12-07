Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbbLGXGg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 18:06:36 -0500
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log
 replay
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5665B359.2050906@redhat.com> <2856934.1tulUexfpA@localhost.localdomain>
 <5665C1F2.8020407@redhat.com> <1449521684.6881.13.camel@scientia.net>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <566610FA.1080408@redhat.com>
Date: Mon, 7 Dec 2015 17:06:34 -0600
MIME-Version: 1.0
In-Reply-To: <1449521684.6881.13.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/7/15 2:54 PM, Christoph Anton Mitterer wrote:

...
 
> 2) a section that describes "ro" in btrfs-mount(5) which describes that
> normal "ro" alone may cause changes on the device and which then refers
> to hard-ro and/or the list of options (currently nologreplay) which are
> required right now to make it truly ro.
> 
> 
> I think this is important as an end-user probably expects "ro" to be
> truly ro,

Yeah, I don't know that this is true.  It hasn't been true for over a
decade (2?), with the most widely-used filesystem in linux history, i.e.
ext3.  So if btrfs wants to go on this re-education crusade, more power
to you, but I don't know that it's really a fight worth fighting.  ;)

> so if he looks it up in the documentation (2) he should find
> enough information that this isn't the case and what to do instead.
> Further, as one might expect that in the future, other places (than
> just the log) may cause changes to a device, even though mounted ro...
> I think it's better for the end user to also have a real "hard-ro" like
> option, than a possibly growing list of "noXYZ" where the end-user may
> have no clue that something else is now also required to get the truly
> read-only behaviour.

# blockdev --setro ...

-Eric



