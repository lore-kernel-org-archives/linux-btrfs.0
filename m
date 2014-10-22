Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:54608 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932328AbaJVUhT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 16:37:19 -0400
Message-ID: <5448157B.8030102@pobox.com>
Date: Wed, 22 Oct 2014 13:37:15 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 5 _thousand_ snapshots? even 160? (was: device balance times)
References: <9cf38edae6c01b900d4ea0068d2dcfdd@admin.virtall.com> <pan$66073$b8603a2$c915bfb9$cd573e99@cox.net> <20141022200812.GA17395@hungrycats.org>
In-Reply-To: <20141022200812.GA17395@hungrycats.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/22/2014 01:08 PM, Zygo Blaxell wrote:
> I have datasets where I record 14000+ snapshots of filesystem directory
> trees scraped from test machines and aggregated onto a single server
> for deduplication...but I store each snapshot as a git commit, not as
> a btrfs snapshot or even subvolume.
>
> We do sometimes run queries like "in the last two years, how many times
> did $CONDITION occur?" which will scan a handful files in all of the
> snapshots.  The use case itself isn't unreasonable, although using the
> filesystem instead of a more domain-specific tool to achieve it may be.
>

Okay, sure. And as stated by others, there _are_ use cases that are 
exceptional.

But such an archival system most likely does not _need_ to be balanced 
etc with any frequency, or likely ever because it isn't experiencing 
churn from dynamic use.

In the world of trade-offs, trade-offs happen.

The guy who cited the 5000 snapshots said they were hourly and taken 
because he might remove an important file or something. This is _way_ 
more action than the feared condition.

ASIDE: While fixing someone's document archive RAID device (a Sun 
hardware device the size of a fridge) back in 1997 or so I discovered 
that they'd disabled _all_ the hardware cache features. When asked I was 
told that "the procedure for replacing a failed drive required the cache 
device to be cleared by pressing the red button" and they were afraid 
that, should that day come, someone would forget to press that button... 
so they'd turned off the feature entirely. This is a form of 
unreasonable paranoia. They were afraid that someone in the future would 
not follow the directions would be printed on both the machine and the 
new drive (these were _not_ commodity parts).

When an over-abundance of caution passes beyond reasonable expectations, 
performance will suffer. The system is immaterial, the rule holds.

What's worse is it becomes very like "security theater" only its "a 
backup show" where no actual backing up is really happening in any 
useful sense. And god save you picking which version of a file was the 
last "good one".

So in your use case, your git repository of snapshots isn't actually 
"live" on the production server you are archiving, right?

So too, it would be reasonable to btrfs send periodic snapshots to an 
archive system, retain lots and lots of them, and expect reasonable 
performance of your queries.

And you cold expect reasonable performance in your maintenance.

But "reasonable performance" in the maintenance case is massively 
different than reasonable performance in use cases. Indeed if you try to 
balance multiple terabytes of data spread across thousands of snapshots 
you'll be taking a lot of time. A _perfectly_ _reasonable_ lot of time 
for the operation at hand.

But if you expect to be able to do maintenance (like btrfsck your 
production box with its 5k snapshots) in just a few minutes when you've 
got logarithmic-rate meta data to shuffle through... well good luck with 
that.
