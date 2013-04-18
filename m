Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:44868 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3DRV67 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Apr 2013 17:58:59 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id B74759A0420
	for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2013 15:58:58 -0600 (MDT)
Date: Thu, 18 Apr 2013 17:58:56 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Matt Pursley <mpursley@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
Message-ID: <20130418215856.GA2305@localhost.localdomain>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda>
 <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
 <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 17, 2013 at 07:50:09PM -0600, Matt Pursley wrote:
> Hey All,
> 
> Here are the results of making and reading back a 13GB file on
> "mdraid6 + ext4",  "mdraid6 + btrfs", and "btrfsraid6 + btrfs".
> 
> Seems to show that:
> 1) "mdraid6 + ext4" can do ~1100 MB/s for these sequential reads with
> either one or two files at once.
> 2) "btrfsraid6 + btrfs" can do ~1100 MB/s for sequential reads with
> one file at a time, but only ~750 MB/s with two (or more).
> 3) "mdraid6 + btrfs" can only do ~750 MB/s for these sequential reads
> with either one or two files at once.
> 
> 
> So, seems like the speed drop is related more to the btrfs files
> system, then the experimental raid.
> Although it is interesting that btrfs can only do the full ~1100 MB/s
> with a single file on the btrfsraid6, but not mdraid6.
> 
> 
> Anyway, just some more info and reproducible results.
> 
> I have also opened a ticket in bugzilla.kernel.org for this issue here...
> https://bugzilla.kernel.org/show_bug.cgi?id=56771
>

This is strange, and I can't see any reason why this would happen.  I'll try and
reproduce next week when I'm back from LSF.  Thanks,

Josef 
