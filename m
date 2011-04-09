From: Peter Stuge <peter@stuge.se>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Sat, 9 Apr 2011 21:35:49 +0200
Message-ID: <20110409193549.1809.qmail@stuge.se>
References: <1302370000.23240.10.camel@nayuki> <BjX0wGIi1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BjX0wGIi1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Helmut Hullen wrote:
> If the value of "available" is unresolvable then btrfs should not
> show any value.

Disagree strongly. I think a pessimistic estimate would be much
better to show, than no value at all. This may be what is currently
shown.

As for solving this with a high degree of usability, that's not
really possible when constrained to the traditional paradigm that one
filesystem will have completely consistent behavior backing all of
it.

I think the only answer is to have btrfs-specific tools that know
more about the filesystem, and can present the relevant facts.

Taking the example of part fs being raid0 and part being raid5, such
a tool would then list calculated values for both those parts of the
fs. One showing how much could go into the raid0 part, the other how
much could go into the raid5 part.

But for such filesystems, Linux can't do what Helmut would like.

Maybe it would be possible to optimize the reported numbers, to be
what the user actually wants as often as possible. Ie. if there is
only one type of backing storage (sorry, don't know the terms) then
the calculation would be easier to get right, following the simple
formula that was just given. This is all eye candy however,
completely irrelevant IMO as long as the filesystem oopses, or eats
root nodes. :)


//Peter
