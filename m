Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-05v.sys.comcast.net ([96.114.154.164]:37680 "EHLO
	resqmta-po-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbaLRFos (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 00:44:48 -0500
Message-ID: <549269CB.3010806@pobox.com>
Date: Wed, 17 Dec 2014 21:44:43 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] Print the summary
References: <1418673780-22000-1-git-send-email-kreijack@inwind.it> <1418673780-22000-7-git-send-email-kreijack@inwind.it> <pan$20861$ccededbf$bdcf87a3$8bcef8ae@cox.net> <548FAB3A.7060009@pobox.com> <20141216090540.GK1442@carfax.org.uk>
In-Reply-To: <20141216090540.GK1442@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/16/2014 01:05 AM, Hugo Mills wrote:
> On Mon, Dec 15, 2014 at 07:47:06PM -0800, Robert White wrote:
>> I prefer "slice", not that I am totally happy with that word either.
>> But by the time you get through loopback devices, memory map
>> devices, the "device files" that represent parts of "partitioned"
>> devices, logical "volumes", and god only knows what future
>> "thingies" we will end up dealing with... I like the terms that
>> remove false hints.
>
>     All this agreed, but "slice" will be largely viewed as a neologism
> by anyone who hasn't used (IIRC) BSD or Solaris. On the other hand,
> for all their other flaws, "device" is much better than "disk" here,
> as you could he talking about a partition, a flash memory card (which
> many people don't view as "disks"), or a network block device. You
> could refer to a "block device" to clarify, because that's really what
> we're talking about here, but it could get a bit cumbersome.

That's part of why I'm not perfectly happy with slice either.

But just last week I was trying to explain the whole thing of being out 
of raw space to allocate storage extents compared to being out of 
managed space to allocate file, um, extents...

And I'm currently going around in circles over whole "when is a sector 
free" as far as /bin/df is concerned...


we've got devices as we view them which are parts of devices as the ...

We've got storage extents and we are dealing with people who are used to 
seeing "extent" used as the name of contiguously stored sections of 
files, but our extents store segments of the devices.

We've also got those two-disk raid-5(s) which we've established are 
mathematically correct, but which will trip up everyone that is used to 
the three-or-more rule.

Then using the variable bytenr instead of byte_number (when all the rest 
of the variables are spelled out) and I'm not sure if thats in the 
logical view or the physical layout view, or both.

In short (too late) there is a huge lexicon problem to newcomers here 
because of noun-overloading (in the programmatic sense).
