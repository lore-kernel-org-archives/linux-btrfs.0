Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaKUXwh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 18:52:37 -0500
Date: Sat, 22 Nov 2014 00:52:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        "open list:BTRFS FILE SYSTEM" <linux-btrfs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: ctree: reduce args where only fs_info used
Message-ID: <20141121235236.GH8568@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <danieru.dressler@gmail.com>
 <1415767389-29722-1-git-send-email-danieru.dressler@gmail.com>
 <20141121155519.GB8568@twin.jikos.cz>
 <CAGC3nLApxMmbSmPc9WvQ5Uh0prrCY7qzcMABaKs_FcYKdUKCpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGC3nLApxMmbSmPc9WvQ5Uh0prrCY7qzcMABaKs_FcYKdUKCpw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 22, 2014 at 01:03:32AM +0900, Daniel Dressler wrote:
> No problem, I'll redo everything so it is one function per patch. Now
> fair warning: there are about 102 functions to cleanup. I was a bit
> worried that many patches would cause too much maintainer overhead but
> it is no problem for me.

Yeah, I'm aware that it's all over the sources. I'd say send no more
than 30 patches in a burst first and see how it'd work.

> Only a few functions have dependecies on
> other functions needing cleanup. Thus there will be some small patch
> series for those function sets. A big benefit of one function one
> patch is that extent-io.c will no longer be a 34 function monster
> patch.
> 
> Is there any rate limiting I should be doing? I don't want to flood
> the list with burst of dozen plus patches, or is that an okay volume?

Should be fine.
