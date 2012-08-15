Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61842 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab2HOR3M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 13:29:12 -0400
Received: by obbuo13 with SMTP id uo13so2452725obb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Aug 2012 10:29:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344975738-1415-1-git-send-email-jbacik@fusionio.com>
References: <1344975738-1415-1-git-send-email-jbacik@fusionio.com>
Date: Wed, 15 Aug 2012 12:29:11 -0500
Message-ID: <CAKcLGm9rra1v8t5rRB2DAw0YM0QC+JHMTZK=uzMOXOv9hAZfMw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not allocate chunks as agressively
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 3:22 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> Swinging this pendulum back the other way.  We've been allocating chunks up
> to 2% of the disk no matter how much we actually have allocated.  So instead
> fix this calculation to only allocate chunks if we have more than 80% of the
> space available allocated.  Please test this as it will likely cause all
> sorts of ENOSPC problems to pop up suddenly.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

I've been testing this patch with my multiple rsync test (On a 3.5.1
kernel merged with for-linus).

I tested without compression, and with lzo compression, and I haven't
run into any ENOSPC issues.  I still have ENOSPC issues with zlib,
with or without this patch.

I made a series of  runs with and without this patch (on an
uncompressed, newly formatted partition), and some of the results were
not what I anticipated.

1) I found that *MORE* metadata space was being allocated with this
patch than when using an unpatched baseline kernel.  The total
allocated space was exactly the same in each run (I saw a slight
variation in the amount of used Metadata).

On the unpatched baseline kernel, at the end of the run, the 'btrfs fi
df' command would show:

# btrfs fi df /mnt/benchmark/
Data: total=10.01GB, used=6.99GB
System: total=4.00MB, used=4.00KB
Metadata: total=776.00MB, used=481.38MB

With this patch applied, the 'btrfs fi df' command would show:

# btrfs fi df /mnt/benchmark/
Data: total=10.01GB, used=6.99GB
System: total=4.00MB, used=4.00KB
Metadata: total=1.01GB, used=480.94MB


2)  The multiple rsync's would run significantly faster with the patched kernel.

Unpatched baseline kernel:  Time to run 7 rysncs:  348.3 sec (+/- 9.7 sec)
Patched kernel: Time to run 7 rsyncs:  316.6 sec (+/- 6.5 sec)

Perhaps the extra allocated metadata space made things run better, or
perhaps something else was going on.
