Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from celine.tisys.org ([85.25.117.166]:34840 "EHLO celine.tisys.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941509AbcLVVqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 16:46:34 -0500
Date: Thu, 22 Dec 2016 22:46:11 +0100
From: Nils Holland <nholland@tisys.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: OOM: Better, but still there on
Message-ID: <20161222214611.GA3015@boerne.fritz.box>
References: <20161216184655.GA5664@boerne.fritz.box>
 <20161217000203.GC23392@dhcp22.suse.cz>
 <20161217125950.GA3321@boerne.fritz.box>
 <862a1ada-17f1-9cff-c89b-46c47432e89f@I-love.SAKURA.ne.jp>
 <20161217210646.GA11358@boerne.fritz.box>
 <20161219134534.GC5164@dhcp22.suse.cz>
 <20161220020829.GA5449@boerne.fritz.box>
 <20161221073658.GC16502@dhcp22.suse.cz>
 <20161222101028.GA11105@ppc-nas.fritz.box>
 <20161222191719.GA19898@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161222191719.GA19898@dhcp22.suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 22, 2016 at 08:17:19PM +0100, Michal Hocko wrote:
> TL;DR I still do not see what is going on here and it still smells like
> multiple issues. Please apply the patch below on _top_ of what you had.

I've run the usual procedure again with the new patch on top and the
log is now up at:

http://ftp.tisys.org/pub/misc/boerne_2016-12-22_2.log.xz

As a little side note: It is likely, but I cannot completely say for
sure yet, that this issue is rather easy to reproduce. When I had some
time today at work, I set up a fresh Debian Sid installation in a VM
(32 bit PAE kernel, 4 GB RAM, btrfs as root fs). I used some late 4.9rc(8?)
kernel supplied by Debian - they don't seem to have 4.9 final yet and I
didn't come around to build and use a custom 4.9 final kernel, probably
even with your patches. But the 4.9rc kernel there seemed to behave very much
the same as the 4.9 kernel on my real 32 bit machines does: All I had
to do was unpack a few big tarballs - firefox, libreoffice and the
kernel are my favorites - and the machine would start OOMing.

This might suggest - although I have to admit, again, that this is
inconclusive, as I've not used a final 4.9 kernel - that you could
very easily reproduce the issue yourself by just setting up a 32 bit
system with a btrfs filesystem and then unpacking a few huge tarballs.
Of course, I'm more than happy to continue giving any patches sent to
me a spin, but I thought I'd still mention this in case it makes
things easier for you. :-)

Greetings
Nils
