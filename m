Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.nethype.de ([5.9.56.24]:42523 "EHLO mail.nethype.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbeFFTW0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Jun 2018 15:22:26 -0400
Date: Wed, 6 Jun 2018 21:06:35 +0200
From: Marc Lehmann <schmorp@schmorp.de>
To: james harvey <jamespharvey20@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Michal Hocko <mhocko@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        bugzilla-daemon@bugzilla.kernel.org, bugzilla.kernel.org@plan9.de,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, linux-mm@kvack.org,
        Jan Kara <jack@suse.cz>
Subject: Re: [Bug 199931] New: systemd/rtorrent file data corruption when
 using echo 3 >/proc/sys/vm/drop_caches
Message-ID: <20180606190635.meodcz3mchhtqprb@schmorp.de>
References: <bug-199931-27@https.bugzilla.kernel.org/>
 <20180605130329.f7069e01c5faacc08a10996c@linux-foundation.org>
 <CA+X5Wn5_iJYS9MLFdArG9sDHQO2n=BkZmaYAOexhdoVc+tQnmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+X5Wn5_iJYS9MLFdArG9sDHQO2n=BkZmaYAOexhdoVc+tQnmw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 05:52:38PM -0400, james harvey <jamespharvey20@gmail.com> wrote:
> >> This is not always reproducible, but when deleting our journal, creating log
> >> messages for a few hours and then doing the above manually has a ~50% chance of
> >> corrupting the journal.
> ...
> 
> My strong bet is you have a hardware issue.

Strange, what kind of harwdare bug would affect multiple very different
computers in exactly the same way?

> going bad, bad cables, bad port, etc.  My strong bet is you're also
> using BTRFS mirroring.

Not sure what exactly you mean with btrfs mirroring (there are many btrfs
features this could refer to), but the closest thing to that that I use is
dup for metadata (which is always checksummed), data is always single. All
btrfs filesystems are on lvm (not mirrored), and most (but not all) are
encrypted. One affected fs is on a hardware raid controller, one is on an
ssd. I have a single btrfs fs in that box with raid1 for metadata, as an
experiment, but I haven't used it for testing yet.

> You're describing intermittent data corruption on files that I'm
> thinking all have NOCOW turned on.

The systemd journal files are nocow (I re-enabled that after I turned it
off for a while), but the rtorrent directory (and the files in it) are
not.

I did experiment (a year ago) with nocow for torrent files and, more
importantly, vm images, but it didn't really solve the "millions of
fragments slow down" problem with btrfs, so I figured I can keep them cow
and regularly copy them to defragment them. Thats why I am quite sure cow
is switched on long before I booted my first 4.14 kernel (and it still
is).

> it's done writing to a journal file, but in a way that guarantees it
> to fail.  This has been reported to systemd at
> https://github.com/systemd/systemd/issues/9112 but poettering has

I am aware that systemd tries to turn on nocow, and I think this is actually
a bug, but this wouldn't have an an effect on rtorrent, which has corruption
problems on a different fs. And boy would it be wonderufl if Debian switched
away form systemd, I feel I personally ran into every single bug that
exists...

However, no matter how much systemd plays with btrfs flags, it shouldn't
corrupt data.

> The context I ran into this problem was with several other bugs
> interacting, that "btrfs replace" has been guaranteed to corrupt
> non-checksummed (NOCOW) compressed data, which the combination of
> those shouldn't happen, but does in some defragmentation situations
> due to another bug.  In my situation, I don't have a hardware issue.

Yeah, btrfs is full of bugs that I constantly run into, but most of them
are containable, unlikely this problem, which might or might not be a
btrfs bug - especially since all your bets seem to be wrong here.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\
