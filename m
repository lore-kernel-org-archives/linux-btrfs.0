Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:52020 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaGCL0p (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 07:26:45 -0400
Received: by mail-ie0-f170.google.com with SMTP id tr6so43511ieb.29
        for <linux-btrfs@vger.kernel.org>; Thu, 03 Jul 2014 04:26:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53B51560.2040603@cn.fujitsu.com>
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
 <53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com>
 <CAKFHe2T3FaXcO2k8NQoLx2x_xyep903hTnNRdOE62uEf+iu42Q@mail.gmail.com> <53B51560.2040603@cn.fujitsu.com>
From: Tobias Geerinckx-Rice <tobias.geerinckx.rice@gmail.com>
Date: Thu, 3 Jul 2014 13:26:24 +0200
Message-ID: <CAKFHe2ShPjfgbYDEHhpOKW0uQS9sD+=o2_cWN7rJRN2jGqwU6g@mail.gmail.com>
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: kreijack@inwind.it, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3 July 2014 10:33, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Oh, sorry for my confusing words.

And I probably should have waited for my frustration with my mail
client/device/public transport to subside before panicking^Creplying.

I use a combination of ro & rw (not insanely nested) subvolumes on a
few pseudo-embedded home/office servers and would like to keep that
arrangement working if possible. I'm also aware that it doesn't
protect against all possible bugs.

> To make it clear, when mentioning 'the whole disk(or partition whatever)' I mean the FS_TREE.
> (Of course not the default subvolume)
>
> The problem is that, even you mount a subvolume ro, you can still change contents in the subvolume
> through its rw parent subvolume.
> And if a subvolume can still be modified, the ro mount lose it meaning.

That makes so much more sense than my original reading, which was
weird and wrong and implied strange subvol-5-only magic. Sorry!

> So we need special rules to prevent such things.

Not that it matters, but: agreed.

   Tobias
