Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43038 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaCGKSn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 05:18:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WLrrV-0007Mi-GK
	for linux-btrfs@vger.kernel.org; Fri, 07 Mar 2014 11:18:41 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 11:18:41 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Mar 2014 11:18:41 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC errors during raid1 rebalance
Date: Fri, 7 Mar 2014 10:18:17 +0000 (UTC)
Message-ID: <pan$1c266$c782ec3d$ca8afa67$2f440bea@cox.net>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>
	<20140303183911.GL13899@carfax.org.uk>
	<DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
	<73124688-5EDF-4DB5-AC9E-9F365397DD28@colorremedies.com>
	<loom.20140305T190503-404@post.gmane.org>
	<pan$23ceb$3bedfe62$bfb976de$e16d8fde@cox.net>
	<loom.20140307T021006-737@post.gmane.org>
	<20140307080213.GC6318@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Fri, 07 Mar 2014 08:02:13 +0000 as excerpted:

> On Fri, Mar 07, 2014 at 01:13:53AM +0000, Michael Russo wrote:
>> Duncan <1i5t5.duncan <at> cox.net> writes:
>> 
>> > But if you're not using compression, /that/ can't explain it...
>> > 
>> > 
>> Ha! Well while that was an interesting discussion of fragmentation, I
>> am only using the default mount options here and so no compression.
> 
>    I _think_ the problem here is that there may have been some extents
> created during the conversion which were over 1 GiB in size (or at least
> which run across two or more chunks). This causes problems, because
> there's nowhere that they can be written to by the balance --
> which preserves extents -- because none of the allocation units (chunks)
> are big enough.
> 
>    The defrag operation, by its nature, _doesn't_ preserve extents,
> and thus can act to break up the large extents, making it possible to
> balance the chunks that the offending extents live on.

Now /that/ would explain the issue, or at least all I've read of it from 
here.  Nice job! =:^)

Obviously >1 GB files break/fragment on 1-gig data-chunk lines when 
(re)written on btrfs, since that's the biggest allocation unit btrfs has, 
and at least once the filesystem has been (near) full once, btrfs is 
extremely unlikely to be able to place those gig-chunks contiguously, 
thus triggering the issue.

Meanwhile, the move-to-tmpfs-and-back should indeed break up those >1-gig 
blocks too, since the that would force a rewrite and thus a reallocation, 
which would then follow btrfs 1-gig-chunk rules.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

