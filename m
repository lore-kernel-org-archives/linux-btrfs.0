Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60814 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758784Ab2HQS2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Aug 2012 14:28:50 -0400
Date: Fri, 17 Aug 2012 14:28:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not allocate chunks as agressively
Message-ID: <20120817182846.GD2133@localhost.localdomain>
References: <1344975738-1415-1-git-send-email-jbacik@fusionio.com>
 <CAKcLGm9rra1v8t5rRB2DAw0YM0QC+JHMTZK=uzMOXOv9hAZfMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAKcLGm9rra1v8t5rRB2DAw0YM0QC+JHMTZK=uzMOXOv9hAZfMw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2012 at 11:29:11AM -0600, Mitch Harder wrote:
> On Tue, Aug 14, 2012 at 3:22 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> > Swinging this pendulum back the other way.  We've been allocating chunks up
> > to 2% of the disk no matter how much we actually have allocated.  So instead
> > fix this calculation to only allocate chunks if we have more than 80% of the
> > space available allocated.  Please test this as it will likely cause all
> > sorts of ENOSPC problems to pop up suddenly.  Thanks,
> >
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> I've been testing this patch with my multiple rsync test (On a 3.5.1
> kernel merged with for-linus).
> 
> I tested without compression, and with lzo compression, and I haven't
> run into any ENOSPC issues.  I still have ENOSPC issues with zlib,
> with or without this patch.
> 
> I made a series of  runs with and without this patch (on an
> uncompressed, newly formatted partition), and some of the results were
> not what I anticipated.
> 
> 1) I found that *MORE* metadata space was being allocated with this
> patch than when using an unpatched baseline kernel.  The total
> allocated space was exactly the same in each run (I saw a slight
> variation in the amount of used Metadata).
> 
> On the unpatched baseline kernel, at the end of the run, the 'btrfs fi
> df' command would show:
> 
> # btrfs fi df /mnt/benchmark/
> Data: total=10.01GB, used=6.99GB
> System: total=4.00MB, used=4.00KB
> Metadata: total=776.00MB, used=481.38MB
> 
> With this patch applied, the 'btrfs fi df' command would show:
> 
> # btrfs fi df /mnt/benchmark/
> Data: total=10.01GB, used=6.99GB
> System: total=4.00MB, used=4.00KB
> Metadata: total=1.01GB, used=480.94MB
> 
> 
> 2)  The multiple rsync's would run significantly faster with the patched kernel.
> 
> Unpatched baseline kernel:  Time to run 7 rysncs:  348.3 sec (+/- 9.7 sec)
> Patched kernel: Time to run 7 rsyncs:  316.6 sec (+/- 6.5 sec)
> 
> Perhaps the extra allocated metadata space made things run better, or
> perhaps something else was going on.

Well that's odd, I wonder if we're doing the limited dance more often.  Once
I've finished my fsync work I'll come back to this.  I know for sure in my
tests it's allocating chunks way too often, so I imagine your test is just
tickling a different aspect of the chunk allocator.  Thanks,

Josef
