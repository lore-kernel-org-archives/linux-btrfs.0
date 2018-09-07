Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727786AbeIGP5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 11:57:55 -0400
Date: Fri, 7 Sep 2018 13:17:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: extent-tree.c: Remove redundant variable from
 btrfs_cross_ref_exist()
Message-ID: <20180907111709.GM24025@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1535593351.git.misono.tomohiro@jp.fujitsu.com>
 <90c3c33c-0f7d-7121-feb8-4a74e5e78b93@jp.fujitsu.com>
 <20180906155757.GC24025@twin.jikos.cz>
 <ed103469-264b-f556-c34b-81ab8e64e509@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ed103469-264b-f556-c34b-81ab8e64e509@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 07, 2018 at 12:01:21PM +0900, Misono Tomohiro wrote:
> On 2018/09/07 0:57, David Sterba wrote:
> > On Thu, Aug 30, 2018 at 10:59:16AM +0900, Misono Tomohiro wrote:
> >> Since commit d7df2c796d7e ("Btrfs attach delayed ref updates to
> >> delayed ref heads"), check_delaed_ref() won't return -ENOENT.
> >>
> >> In btrfs_cross_ref_exist(), two variable 'ret' and 'ret2' is
> >> originally used to handle -ENOENT error case.
> >>
> >> Since the code is not needed anymore, let's just remove 'ret2'.
> > 
> > Good cleanup and the patch would be ok as-is. I've noticed that
> > check_delayed_ref now returns only two values so it might make sense to
> > turn it to bool and update the name of check_delayed_ref to make it
> > clear what the return value means in the loop.
> 
> check_delaed_ref()'s return value is:
>  0       ... no cross ref found in delayed ref
>  1       ... cross ref found in delayed ref
>  -EAGAIN ... cannot acquire lock and try again later
> 
> so I don't think we can convert it to bool directly or
> do you mean we should handle -EAGAIN in check_delayed_ref()?

Oh right, I missed there's ret = 1 in one of the branches, that makes my
point moot.
