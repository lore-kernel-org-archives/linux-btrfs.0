Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:9343 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932394AbdEVA7R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 20:59:17 -0400
Subject: Re: QGroups Semantics
To: Sargun Dhillon <sargun@sargun.me>, BTRFS ML <linux-btrfs@vger.kernel.org>
References: <CAMp4zn8CfdzPn7UAHf7S2PT1F8ysf95jMi7F8RBUuyBvqYT5xw@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <c2e1824a-b395-53da-8cd2-cade09449313@cn.fujitsu.com>
Date: Mon, 22 May 2017 08:59:13 +0800
MIME-Version: 1.0
In-Reply-To: <CAMp4zn8CfdzPn7UAHf7S2PT1F8ysf95jMi7F8RBUuyBvqYT5xw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/19/2017 05:07 PM, Sargun Dhillon wrote:
> I have some questions about the *intended* qgroups semantics, and why
> we allow certain operations:
> 
> 1) Why can you create a level 0 qgroup for a non-existent subvolume?
> It looks like it just gets reset when you create the subvol anyway?
> Should we prevent this?

Personally speaking, I didn't see much meaning of allowing this, except 
setting limit before creating the subvolume.

But that can also be done by setting up higher level qgroup and attach 
new subvolume to that higher level qgroup.

IIRC there are some guys hoping to disable multi-level qgroup 
completely, if one day we decide to do that, then current behavior may 
be quite important.

> 
> 2) Why do we allow deleting a level 0 qgroup for a currently existing
> subvolume? It seems to me that just setting the limit to 0, and/or
> removing relations would work equally well? Perhaps a new ioctl to
> clear the qgroup would make sense to do this.

At least I didn't see the meaning to allow deleting qgroup for existing 
subvolume.

It won't even improve any performance since we still need to do the time 
consuming backref walk.

> 
> 3) Why don't we remove the associated level 0 qgroup when you remove
> the subvol with that id?
This may be related to question 1).
Sometimes we may want to keep the limit?

Despite of that, I didn't see any reason to keep the orphan level 0 qgroup.

> 
> 4) I noticed in qgroup.c, one of the outstanding items is to determine
> how to autocleanup. Are there any stated semantics around that, or
> opinions?

As long as we're going to stick with multi level qgroups, then 
autocleanup seems to be a good idea.

Thanks,
Qu

> 
> PS:
> If the answer to any of these is "it just needs to be worked on" --
> I'm currently poking around this code path for some enhancements we're
> doing for our usecase. I'm just trying to figure out how much of what
> I'm doing is generalizable.
> 
> -Thanks,
> Sargun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


