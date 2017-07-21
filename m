Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:59166 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdGUKfe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 06:35:34 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 0BABA9B6E7
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 11:27:08 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id C3E185FBB3
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 11:27:07 +0100 (BST)
Subject: Re: kernel btrfs file system wedged -- is it toast?
To: linux-btrfs@vger.kernel.org
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
 <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com>
 <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
 <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <757189da-6e2b-7585-4b37-a0e86049e1bf@cobb.uk.net>
Date: Fri, 21 Jul 2017 11:27:07 +0100
MIME-Version: 1.0
In-Reply-To: <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21/07/17 07:06, Paul Jackson wrote:
> What in god green's earth can kernel file system code be
> doing that takes fifteen minutes (so far, in this case) or
> fifty minutes (in the case I first reported on this thread?

I find that just doing a balance on a disk with lots of snapshots can
cause this sort of effect.  If I understand correctly, this is because
btrfs does not have an efficient structure to help find all the
references in different subvolumes to an extent which is being
manipulated and many trees have to be searched. My understanding may be
wrong but, in any case, the effect is that many operations can take
massive amounts of processing time if there are lots of shared extents.

This caused my early experiments with using btrfs snapshots on my main
data disk (full of mail files, etc) to make the system lock up for many
**hours** at a time (preventing mail processing, etc).

I took the advice on this list to significantly decrease the number of
snapshots I kept on the disk (I keep more on a separate backup disk,
which has no day-to-day transactions happening, and can also better
tolerate any issues).

I also created a very hacky script to try to limit the impact of the
balances which I do weekly. See
https://github.com/GrahamCobb/btrfs-balance-slowly if you are
interested. Between these things, the serious disruption is now gone.

Note: despite all the hangs, I never saw any disk corruption.

Graham
