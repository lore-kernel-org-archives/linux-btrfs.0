From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [build breakage] Re: [GIT PULL] Btrfs pull round two
Date: Fri, 19 Aug 2011 08:14:02 -0700
Message-ID: <CA+55aFwvwSgHgGd-x02GPAKnD3UfcGcWZf8zCVvvLwTFg9FxqQ@mail.gmail.com>
References: <1312315404-sup-6084@shiny> <20110819130615.GA6307@kernel.org> <CA+5PVA5QMZ3i7Pr1jsis+r4CeZZCWEt59oZXNhtf4Ea-yeAgGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Ingo Molnar <mingo@kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Josh Boyer <jwboyer@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+5PVA5QMZ3i7Pr1jsis+r4CeZZCWEt59oZXNhtf4Ea-yeAgGA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 19, 2011 at 6:24 AM, Josh Boyer <jwboyer@gmail.com> wrote:
>
> FYI, this was noticed and a patch was posted to linux-btrfs:
>
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/12673
>
> Josef bugged them to send it upstream.

Oh Christ!

Please don't send that upstream.

This:

-		min_free /= 2;
+		do_div(min_free, 2);

is just moronic. Guys, YOU ARE DIVIDING A UNSIGNED VALUE BY TWO. Has
anybody ever looked at a real computer? Doesn't anybody know how
computer math works any more? Doing that as a (slow) double division
on 32-bit is so stupid that it's past even just "wrong". It's way off
in la-la-land, sitting in a corner, all hopped up on drugs and
painting its nails purple.

Also, the change that is definitely correct:

-		min_free /= dev_min;
+		do_div(min_free, dev_min);

should still be something that people think about. Why is "dev_min" a
signed integer? That looks wrong. You wanted an unsigned divide,
didn't you (and that is what "do_div()" is designed for).

So guys, please: when you get an error like this, don't just go into
that mindless place where you paper things over. Think about what is
going on, and WHY you got the error. Big 64-bit divides are bad bad
bad. They are so horrendously bad on 32-bit that we don't even support
them (which is the reason I refuse to put that __udiv into the 32-bit
libraries), but that are often bad on 64-bit too. So you need to spend
some time thinking about it when you get that __udivdi3 error.

                             Linus
