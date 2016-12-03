Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:58482 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750917AbcLCR1q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 12:27:46 -0500
Date: Sat, 3 Dec 2016 11:48:33 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: btrfs_destroy_inode warn (outstanding extents)
Message-ID: <20161203164833.bjc3tu7o5in6okg5@codemonkey.org.uk>
References: <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
 <20161201153209.kylizqipi7a2wcpj@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161201153209.kylizqipi7a2wcpj@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 01, 2016 at 10:32:09AM -0500, Dave Jones wrote:
 > http://codemonkey.org.uk/junk/btrfs-destroy-inode-outstanding-extents.txt
 > 
 > Also same bug, different run, but a different traceview http://codemonkey.org.uk/junk/btrfs-destroy-inode-outstanding-extents-function-graph.txt
 > 
 > (function-graph screws up the RIP for some reason, 'return_to_handler'
 >  should actually be btrfs_destroy_inode)

Chris pointed me at a pending patch that took care of this warning.

 > Anyways, I've got some code that works pretty well for dumping the
 > ftrace buffer now when things go awry.  I just need to run it enough
 > times that I hit that bad page state instead of this, or a lockdep bug first.

Which allowed me to run long enough to get this trace..
http://codemonkey.org.uk/junk/bad-page-state.txt

Does this shed any light ?
The interesting process here seems to be kworker/u8:17, and the trace
captures some of what that was doing before that bad page was hit.

I've got another run going now, so I'll compare that trace when it
happens to see if it matches my current theory that it's something to
do with that btrfs_scrubparity_helper. I've seen that show up in stack
traces a few times while chasing this.

	Dave

