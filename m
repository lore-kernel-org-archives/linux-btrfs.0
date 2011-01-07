From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 15:10:56 +0100
Message-ID: <AANLkTikudoS6B88-KtVfMOLg3fUHkcPM43O8-d1pUSs+@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<AANLkTikE2Rr3KdGA5bN77o+BmkD6nsBvDasgx4085MiL@mail.gmail.com>
	<AANLkTikL+BYkFgkY_NA=vL2aO-8tSsZnHoBHeU6gXc1X@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikL+BYkFgkY_NA=vL2aO-8tSsZnHoBHeU6gXc1X@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 3:01 PM, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> According to Ted, via-truncate and via-rename are unsafe. Only fsync,
> rename is safe.
> Disadvantage of rename is resetting file owner (if non-root), having
> issues with meta-data and other stuff.
>
> My proposal was for an open flag, O_ATOMIC, to be introduced to tell
> the FS the whole file update should be done atomically.
> Ted says this is too hard in ext4, so I was wondering if this would be
> possible in btrfs.

http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/#comment-2082
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/#comment-2089
http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/#comment-2090
