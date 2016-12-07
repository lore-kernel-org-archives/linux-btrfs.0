Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:37030 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752195AbcLGQ5p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Dec 2016 11:57:45 -0500
Date: Wed, 7 Dec 2016 11:15:21 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: btrfs_destroy_inode warn (outstanding extents)
Message-ID: <20161207161521.ycjkjeod5bb3jbwd@codemonkey.org.uk>
References: <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
 <20161201153209.kylizqipi7a2wcpj@codemonkey.org.uk>
 <20161203164833.bjc3tu7o5in6okg5@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161203164833.bjc3tu7o5in6okg5@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2016 at 11:48:33AM -0500, Dave Jones wrote:

 > The interesting process here seems to be kworker/u8:17, and the trace
 > captures some of what that was doing before that bad page was hit.

I'm travelling next week, so I'm trying to braindump the stuff I've
found so far and summarise so I can pick it back up later if no-one else
figures it out first.

I've hit the bad page map spew with enough regularity that I've now got a handful of
good traces.

http://codemonkey.org.uk/junk/btrfs/bad-page-state1.txt
http://codemonkey.org.uk/junk/btrfs/bad-page-state2.txt
http://codemonkey.org.uk/junk/btrfs/bad-page-state3.txt
http://codemonkey.org.uk/junk/btrfs/bad-page-state4.txt
http://codemonkey.org.uk/junk/btrfs/bad-page-state5.txt
http://codemonkey.org.uk/junk/btrfs/bad-page-state6.txt

It smells to me like a race between truncate and the writeback
workqueue. The variety of traces here seem to show both sides
of the race, sometimes it's kworker, sometimes a trinity child process.

bad-page-state3.txt onwards have some bonus trace_printk's from
btrfs_setsize as I was curious what sizes we were passing down to
truncate. The only patterns I see are going from very large to very
small sizes. Perhaps that causes truncate to generate so much
writeback that it makes the race apparent ?



Other stuff I keep hitting:

Start transaction spew:
http://codemonkey.org.uk/junk/btrfs/start_transaction.txt
That's the WARN_ON(h->use_count > 2);
I hit this with enough regularity that I had to comment it out.
It's not clear to me whether this is related at all.

Lockdep spew:
http://codemonkey.org.uk/junk/btrfs/register_lock_class1.txt
http://codemonkey.org.uk/junk/btrfs/register_lock_class2.txt
This stuff has been around for a while (4.6ish iirc)

Sometimes the fs got into a screwed up state that needed btrfscking.
http://codemonkey.org.uk/junk/btrfs/replay-log-fail.txt

	Dave
