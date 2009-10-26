From: David Nicol <davidnicol@gmail.com>
Subject: an idea for increasing responsiveness during write bursts
Date: Mon, 26 Oct 2009 09:22:18 -0500
Message-ID: <934f64a20910260722r6e93c456x8c487afdacd86287@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I don't know if btrfs does this already; the idea is, defer reference
count decrements until the spindle is available, instead of keeping up
with them as writes occur.

Risk: a system crash could occur between change and decrementing,
causing space that should get recycled to get stuck

Engineering complexity: more memory would be required to maintain a
queue of deferred decrements. Logic would need to be worked out about
when to include a decrement within the current critical section and
when to defer it.

History of concept: I was thinking about reference counting extents
and wondering if mark and sweep instead would make any sense, and
realized that the benefit (don't have to do another write right away)
could also be gained by deferring decrements until the disk is idle
instead of deferring them to a GC sweep.
