Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:34244 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752678AbdDISK4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Apr 2017 14:10:56 -0400
Received: by mail-yb0-f172.google.com with SMTP id m133so25725428ybb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Apr 2017 11:10:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
References: <5e11b988-05ea-c468-21ef-589c71058436@mendix.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 9 Apr 2017 12:10:45 -0600
Message-ID: <CAJCQCtScqmKRHZpv3aaN8DjSFU0My4sjsvr=_c9Ch7BOfc3wVw@mail.gmail.com>
Subject: Re: About free space fragmentation, metadata write amplification and (no)ssd
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 8, 2017 at 2:19 PM, Hans van Kranenburg
<hans.van.kranenburg@mendix.com> wrote:
> After changing to nossd, another thing happened. The expiry process,
> which normally takes about 1.5 hour to remove ~2500 subvolumes (keeping
> it queued up to a 100 orphans all the time), suddenly took the entire
> rest of the day, not being done before the nightly backups had to start
> again at 10PM...

Is this 'btrfs sub del' with 100 subvolumes listed? What happens if
the delete command is issued with all 2500 at once? Deleting snapshots
is definitely expensive, and deleting them one at a time is more
expensive in total time than deleting them in one whack. But I've
never deleted 100 or more at once.


-- 
Chris Murphy
