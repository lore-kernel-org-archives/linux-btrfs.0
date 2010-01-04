From: jim owens <jowens@hp.com>
Subject: [RFC 00/12] btrfs core patches for direct I/O
Date: Mon, 04 Jan 2010 16:11:04 -0500
Message-ID: <4B425968.4020308@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As if a Monday after a long holiday was not bad enough... this series
has some simple patches in existing btrfs code that I want to make for
btrfs directio code.

The RESEND patches 1-5 were sent to Chris in December because IMO
they have value without my directio code.  You need them to apply
some of the subsequent patches.

IMO patch 6 is also of value independent of direct I/O, it reduces
vmalloc use by 42K per worker, though we still use 268K per worker (ouch).

Patches 7 - 12 don't have value without direct I/O.  I'm sending
them RFC as they can be understood by themselves, and they are much
simpler than the directio code that uses them. :)

Note - might as well explain this now as later when I send the big
mess of dio.c for review.  The existing core code for pagecache
doesn't work for directio because the existing I/O routines depend
on peeking inside a struct page to get the valid btrfs inode info.
Sorry, no can do, we don't own that page. And rewriting the whole
pagecache I/O stack to eliminate dependence on struct page would
be too scary IMO.

FWIW, fsx didn't crash on this series.

jim
