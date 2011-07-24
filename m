From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 4/4] btrfs: Moved repair code from inode.c to extent_io.c
Date: Mon, 25 Jul 2011 01:01:43 +0200
Message-ID: <20110724230143.GY8006@one.firstfloor.org>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net> <31a5f07325d66bd6691673eafee2c242afd8b833.1311344751.git.list.btrfs@jan-o-sch.net> <m21uxftzo7.fsf@firstfloor.org> <4E2C5628.1020406@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2C5628.1020406@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

> I wasn't clear enough on that: We only track read errors, here. Ans
> error correction can only happen on the read path. So if the write
> attempt fails, we can't go into a loop.

Not in a loop, but you trigger more IO errors, which can be nasty 
if the IO error logging triggers more IO (pretty common because
syslogd calls fsync). And then your code does even more IO, floods
more etc.etc. And the user will be unhappy if their
console gets flooded.

We've have a similar problems in the past with readahead causing
error flooding.

Any time where an error can cause more IO you have to be extremly
careful.

Right now this seems rather risky to me.

-Andi
