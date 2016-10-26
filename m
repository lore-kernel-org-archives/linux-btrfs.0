Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:37752 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933180AbcJZQa1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 12:30:27 -0400
Date: Wed, 26 Oct 2016 12:30:18 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026163018.wx57yy554576s6e2@codemonkey.org.uk>
References: <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2016 at 06:39:03PM -0700, Linus Torvalds wrote:
 > On Tue, Oct 25, 2016 at 6:33 PM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > Completely untested. Maybe there's some reason we can't write to the
 > > whole thing like that?
 > 
 > That hack boots and seems to work for me, but doesn't show anything.
 > 
 > Dave, mind just trying that oneliner?

I gave this a go last thing last night. It crashed within 5 minutes,
but it was one we've already seen (the bad page map trace) with nothing
additional that looked interesting.  I rebooted, and tried again and
went to bed.

12 hours later, it's still doing it's thing.

Heisenbugs man, literally the worst.

	Dave

