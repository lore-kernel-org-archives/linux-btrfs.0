Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36166 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731110AbeGSQi0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:38:26 -0400
Received: by mail-yw0-f194.google.com with SMTP id v197-v6so3247374ywg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:54:38 -0700 (PDT)
Date: Thu, 19 Jul 2018 11:54:36 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Subject: Re: [PATCH 17/22] btrfs: don't take the dio_sem in the fsync path
Message-ID: <20180719155436.xcafoxp3xnu3lg27@destiny>
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-17-josef@toxicpanda.com>
 <CAL3q7H69HAc=j8JHqVzNC1qt7mc6=nHzpbhuBBo=hv1sLSSn4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H69HAc=j8JHqVzNC1qt7mc6=nHzpbhuBBo=hv1sLSSn4A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 04:21:58PM +0100, Filipe Manana wrote:
> On Thu, Jul 19, 2018 at 3:50 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> > Since we've changed the fsync() path to always run ordered extents
> > before doing the tree log we no longer need to take the dio_sem in the
> > tree log path.  This gets rid of a lockdep splat that I was seeing with
> > the AIO tests.
> 
> So actually, we still need it (or some other means of sync).
> Because even after the recent changes to fsync, the fast path still
> logs extent items based on the extent maps, and the dio write path
> creates first the extent map and then the ordered extent.
> So the old problem can still happen between concurrent fsync and
> lockless dio write, where fsync logs an extent item for an extent map
> whose ordered extent we never waited for.
> The solution prior to the introduction of dio_sem solved this - make
> the dio write create first the ordered extent, and, only after it,
> create the extent map.
> 

Oooh balls I see.  This is still a problem even if we add the ordered extent
first, because we can easily just start the lockless dio write after we've
waited for ordered extents, so the order we create the extent map and ordered
extent don't actually matter.  We still have this lockdep thing, I think we just
move the dio_sem to the start of fsync, if we're fsyncing you just don't get to
do lockless dio writes while we're doing the fsync.  What do you think?  Thanks,

Josef
