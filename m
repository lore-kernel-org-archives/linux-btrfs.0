Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:40022 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933528AbcJUVLd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Oct 2016 17:11:33 -0400
Date: Fri, 21 Oct 2016 17:11:02 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Josef Bacik <jbacik@fb.com>
Cc: Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161021211102.emoxdpfr635ujtxb@codemonkey.org.uk>
References: <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <e094eb48-3007-f28a-12f6-6a162a43ad32@fb.com>
 <20161021202325.q6uh7k2pgnv276rg@codemonkey.org.uk>
 <0cbc7ee4-9268-9765-dde7-1e28c4cdf8f0@fb.com>
 <411b54cd-c23c-765a-9547-0b43bf422546@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <411b54cd-c23c-765a-9547-0b43bf422546@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 21, 2016 at 04:41:09PM -0400, Josef Bacik wrote:

 > >>  >
 > >>  > btrfs inspect inode 130654 mntpoint
 > >>
 > >> Interesting, they all return
 > >>
 > >> ERROR: ino paths ioctl: No such file or directory
 > >>
 > >> So these files got deleted perhaps ?
 > >>
 > > Yeah, they must have.
 > >
 > 
 > So one thing that will cause spurious csum errors is if you do things like 
 > change the memory while it is in flight during O_DIRECT.  Does trinity do that? 
 > If so then that would explain it.  If not we should probably dig into it.  Thanks,

Yeah, that's definitely possible. And it wasn't that long ago I added
some code to always open testfiles multiple times with different modes,
so the likely of O_DIRECT went up. That would explain why I've started
seeing this more.

	Dave

