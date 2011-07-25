From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC PATCH 4/4] btrfs: Moved repair code from inode.c to extent_io.c
Date: Mon, 25 Jul 2011 10:52:49 +0200
Message-ID: <4E2D2EE1.7090500@jan-o-sch.net>
References: <cover.1311344751.git.list.btrfs@jan-o-sch.net> <31a5f07325d66bd6691673eafee2c242afd8b833.1311344751.git.list.btrfs@jan-o-sch.net> <m21uxftzo7.fsf@firstfloor.org> <4E2C5628.1020406@jan-o-sch.net> <20110724230143.GY8006@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-raid <linux-raid@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110724230143.GY8006@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 25.07.2011 01:01, Andi Kleen wrote:
>> I wasn't clear enough on that: We only track read errors, here. Ans
>> error correction can only happen on the read path. So if the write
>> attempt fails, we can't go into a loop.
> 
> Not in a loop, but you trigger more IO errors, which can be nasty 
> if the IO error logging triggers more IO (pretty common because
> syslogd calls fsync). And then your code does even more IO, floods
> more etc.etc. And the user will be unhappy if their
> console gets flooded.

Okay, I see your point now. Thanks for pointing that out.

> We've have a similar problems in the past with readahead causing
> error flooding.
> 
> Any time where an error can cause more IO you have to be extremly
> careful.
> 
> Right now this seems rather risky to me.

Hum. This brings up a lot of questions. Would you consider throttling an
appropriate solution to prevent error flooding? What would you use as a
base? A per device counter (which might be misleading if there are more
layers below)? A per filesystem counter (which might need
configurability)? Should those "counters" regenerate over time? Any
other approaches?

-Jan
