Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:54062 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752288AbcJ0RYT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 13:24:19 -0400
Date: Thu, 27 Oct 2016 13:23:32 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161027172332.krdsrc5rlivq4mrv@codemonkey.org.uk>
References: <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <20161027054133.GM14023@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161027054133.GM14023@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2016 at 04:41:33PM +1100, Dave Chinner wrote:
 
 > And that's indicative of a delalloc metadata reservation being
 > being too small and so we're allocating unreserved blocks.
 > 
 > Different symptoms, same underlying cause, I think.
 > 
 > I see the latter assert from time to time in my testing, but it's
 > not common (maybe once a month) and I've never been able to track it
 > down.  However, it doesn't affect production systems unless they hit
 > ENOSPC hard enough that it causes the critical reserve pool to be
 > exhausted iand so the allocation fails. That's extremely rare -
 > usually takes a several hundred processes all trying to write as had
 > as they can concurrently and to all slip through the ENOSPC
 > detection without the correct metadata reservations and all require
 > multiple metadata blocks to be allocated durign writeback...
 > 
 > If you've got a way to trigger it quickly and reliably, that would
 > be helpful...

Seems pretty quickly reproducable for me in some shape or form.
Run trinity with --enable-fds=testfile and create enough children
to create a fair bit of contention, (for me -C64 seems a good fit on
spinning rust, but if you're running on shiny nvme you might have to pump it up a bit).

	Dave

