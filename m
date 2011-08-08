From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: Unmountable btrfs - part II
Date: Mon, 8 Aug 2011 08:23:13 +0000 (UTC)
Message-ID: <loom.20110808T102049-935@post.gmane.org>
References: <CAMcAH6iyZSE+04USi91xZQ9g_yhPRwO5TX8QQsN_B3cVg-0Msg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Maciej Piechotka <uzytkownik2 <at> gmail.com> writes:

> btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
> `!(path->slots[0] == 0)' failed.

Maciej, I see such "Assertion failed" messages usually while playing around with 
different kernels and different versions of btrfs-progs. Please make sure they 
match, meaning btrfs-progs compiled using the currently running kernel.

Just an idea,
Jan

