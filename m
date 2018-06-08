Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57393 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbeFHOJA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Jun 2018 10:09:00 -0400
Subject: Re: [PATCH 00/15] Add delayed-refs support to btrfs-progs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <1528462078-24490-1-git-send-email-nborisov@suse.com>
 <e5b7b849-7d31-b563-0285-919b5732fc04@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <1fe286cc-af72-86e4-743e-1bfb4bff1028@suse.com>
Date: Fri, 8 Jun 2018 17:08:56 +0300
MIME-Version: 1.0
In-Reply-To: <e5b7b849-7d31-b563-0285-919b5732fc04@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.06.2018 16:50, Qu Wenruo wrote:
>  details?
> Personally speaking, I'd like to avoid introducing complex delayed-ref
> into btrfs-progs if possible.
> 
> And in my (possibly wrong) understanding, the main purpose of
> delayed-ref is to reduce the race on extent tree, thus to improve
> performance.
> However in btrfs-progs, it's the least important aspect.
> 
> So extra comment on this is appreciated.

So in order to have freespace tree repair code working I needed to hook
up its add_to_free_space_tree/remove_from_free_space_tree to
alloc_reserved_tree_block/__free_extent. In my testing this lead to a
very deep recursion - it crashed on 58k call frames. So the idea was to
have delayed refs which would record and accumulate modifications and
then the freespace tree freeing code would piggy back on them to rely on
correct operation.

I guess I could try and debug the freespace code and see why I was going
into this infinite recursion so to speak.

Also the delayed refs code in progs is actually a lot simpler than the
kernel counterpart due to the lack of locking. One more benefit of
having this code in progs is the fact one can go through it with a
debugger and really inspect/understand how it works - i.e addition of
refs, selection of refs etc. Furthermore, it at least unifies the logic
between kernel and userspace, since right now there is code which mimics
the delayed refs - check the code being removed in the last patch.
