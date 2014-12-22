Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:60732 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519AbaLVLiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 06:38:05 -0500
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 9F51F407F0
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 22:38:04 +1100 (AEDT)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 23492-06 for <linux-btrfs@vger.kernel.org>;
 Mon, 22 Dec 2014 22:38:04 +1100 (AEDT)
Received: from quad.localnet (2001-44b8-41dd-d500-8017-2b93-f171-2d75.static.ipv6.internode.on.net [IPv6:2001:44b8:41dd:d500:8017:2b93:f171:2d75])
	by csamuel.org (Postfix) with ESMTPSA id 325E8406BF
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 22:38:04 +1100 (AEDT)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
Date: Mon, 22 Dec 2014 22:38:04 +1100
Message-ID: <3748928.v6JPJNQWc6@quad>
In-Reply-To: <CAJCQCtQV3tQZ0WpTt0k3geKUfDJ23EDskyxDCTqkx0FFrSWCsA@mail.gmail.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com> <CAJCQCtQV3tQZ0WpTt0k3geKUfDJ23EDskyxDCTqkx0FFrSWCsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 20 Dec 2014 01:38:43 AM Chris Murphy wrote:

> I'm feeling too lazy to actually go look for evidence of this; but I
> made a file system a while ago with 64KB node/leafsize and ran into a
> bug I reported for send/receive. I'm pretty sure this was related to
> xattr being limited to nodesize, and I'm also pretty sure it got
> fixed. But I'm not sure whether the problem was on the send or receive
> side, and I'm not sure when.

I suspect it's this commit and it implies that it's limited to the leafsize:

commit 4395e0c4da486f007dcb45b0336427be7ec08ab1
Author: Filipe Manana <fdmanana@suse.com>
Date:   Wed Aug 20 10:45:45 2014 +0100

    Btrfs: send, lower mem requirements for processing xattrs
    
    Maximum xattr size can be up to nearly the leaf size. For an fs with a
    leaf size larger than the page size, using kmalloc requires allocating
    multiple pages that are contiguous, which might not be possible if
    there's heavy memory fragmentation. Therefore fallback to vmalloc if
    we fail to allocate with kmalloc. Also start with a smaller buffer size,
    since xattr values typically are smaller than a page.
    
    Reported-by: Chris Murphy <lists@colorremedies.com>
    Signed-off-by: Filipe Manana <fdmanana@suse.com>
    Signed-off-by: Chris Mason <clm@fb.com>


-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


