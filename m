Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:45212 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731126AbeGSQle (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 12:41:34 -0400
Received: by mail-ua0-f195.google.com with SMTP id k8-v6so5513797uaq.12
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 08:57:45 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20180719155436.xcafoxp3xnu3lg27@destiny>
References: <20180719145006.17532-1-josef@toxicpanda.com> <20180719145006.17532-17-josef@toxicpanda.com>
 <CAL3q7H69HAc=j8JHqVzNC1qt7mc6=nHzpbhuBBo=hv1sLSSn4A@mail.gmail.com> <20180719155436.xcafoxp3xnu3lg27@destiny>
From: Filipe Manana <fdmanana@gmail.com>
Date: Thu, 19 Jul 2018 16:57:44 +0100
Message-ID: <CAL3q7H6+yLYG6os_4JmhLxpGMAETEYuY4cngBLsMBX=Pu+SfQQ@mail.gmail.com>
Subject: Re: [PATCH 17/22] btrfs: don't take the dio_sem in the fsync path
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 4:54 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> On Thu, Jul 19, 2018 at 04:21:58PM +0100, Filipe Manana wrote:
>> On Thu, Jul 19, 2018 at 3:50 PM, Josef Bacik <josef@toxicpanda.com> wrote:
>> > Since we've changed the fsync() path to always run ordered extents
>> > before doing the tree log we no longer need to take the dio_sem in the
>> > tree log path.  This gets rid of a lockdep splat that I was seeing with
>> > the AIO tests.
>>
>> So actually, we still need it (or some other means of sync).
>> Because even after the recent changes to fsync, the fast path still
>> logs extent items based on the extent maps, and the dio write path
>> creates first the extent map and then the ordered extent.
>> So the old problem can still happen between concurrent fsync and
>> lockless dio write, where fsync logs an extent item for an extent map
>> whose ordered extent we never waited for.
>> The solution prior to the introduction of dio_sem solved this - make
>> the dio write create first the ordered extent, and, only after it,
>> create the extent map.
>>
>
> Oooh balls I see.  This is still a problem even if we add the ordered extent
> first, because we can easily just start the lockless dio write after we've
> waited for ordered extents, so the order we create the extent map and ordered
> extent don't actually matter.  We still have this lockdep thing, I think we just
> move the dio_sem to the start of fsync, if we're fsyncing you just don't get to
> do lockless dio writes while we're doing the fsync.  What do you think?  Thanks,

On first though, it seems to be the simplest and sanest solution :)
Thanks.

>
> Josef



-- 
Filipe David Manana,

“Whether you think you can, or you think you can't — you're right.”
