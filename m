Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:54154 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756630AbcLAPce (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Dec 2016 10:32:34 -0500
Date: Thu, 1 Dec 2016 10:32:09 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: btrfs_destroy_inode warn (outstanding extents)
Message-ID: <20161201153209.kylizqipi7a2wcpj@codemonkey.org.uk>
References: <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2016 at 02:58:45PM -0500, Dave Jones wrote:
 > On Wed, Nov 23, 2016 at 02:34:19PM -0500, Dave Jones wrote:
 > 
 >  > [  317.689216] BUG: Bad page state in process kworker/u8:8  pfn:4d8fd4
 >  > trace from just before this happened. Does this shed any light ?
 >  > 
 >  > https://codemonkey.org.uk/junk/trace.txt
 > 
 > crap, I just noticed the timestamps in the trace come from quite a bit
 > later.  I'll tweak the code to do the taint checking/ftrace stop after
 > every syscall, that should narrow the window some more.
 > 
 > Getting closer..

Ok, this is getting more like it.
http://codemonkey.org.uk/junk/btrfs-destroy-inode-outstanding-extents.txt

Also same bug, different run, but a different traceview http://codemonkey.org.uk/junk/btrfs-destroy-inode-outstanding-extents-function-graph.txt

(function-graph screws up the RIP for some reason, 'return_to_handler'
 should actually be btrfs_destroy_inode)


Anyways, I've got some code that works pretty well for dumping the
ftrace buffer now when things go awry.  I just need to run it enough
times that I hit that bad page state instead of this, or a lockdep bug first.

	Dave

