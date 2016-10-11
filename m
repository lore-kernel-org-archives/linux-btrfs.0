Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:48542 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752565AbcJKPUt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 11:20:49 -0400
Date: Tue, 11 Oct 2016 11:19:04 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs bio linked list corruption.
Message-ID: <20161011151904.qimdy3rra63fri7n@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161011151139.GD19539@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161011151139.GD19539@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 04:11:39PM +0100, Al Viro wrote:
 > On Tue, Oct 11, 2016 at 10:45:08AM -0400, Dave Jones wrote:
 > > This is from Linus' current tree, with Al's iovec fixups on top.
 > 
 > Those iovec fixups are in the current tree...

ah yeah, git quietly dropped my local copy when I rebased so I didn't notice.

 > TBH, I don't see anything
 > in splice-related stuff that could come anywhere near that (short of
 > some general memory corruption having random effects of that sort).
 > 
 > Could you try to bisect that sucker, or is it too hard to reproduce?

Only hit it the once overnight so far. Will see if I can find a better way to
reproduce today.

	Dave

