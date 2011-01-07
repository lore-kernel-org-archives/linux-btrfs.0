From: Olaf van der Spek <olafvdspek@gmail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 15:01:39 +0100
Message-ID: <AANLkTikL+BYkFgkY_NA=vL2aO-8tSsZnHoBHeU6gXc1X@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
	<AANLkTikE2Rr3KdGA5bN77o+BmkD6nsBvDasgx4085MiL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikE2Rr3KdGA5bN77o+BmkD6nsBvDasgx4085MiL@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 7, 2011 at 2:55 PM, Mike Fleetwood
<mike.fleetwood@googlemail.com> wrote:
> On 6 January 2011 20:01, Olaf van der Spek <olafvdspek@gmail.com> wro=
te:
>> Hi,
>>
>> Does btrfs support atomic file data replaces?
>
> Hi Olaf,
>
> Yes btrfs does support atomic replace, since kernel 2.6.30 circa June=
 2009. [1]
>
> Special handling was added to ext3, ext4, btrfs (and probably other
> Linux FSs) for your replace-via-truncate and the alternative
> replace-via-rename application patterns. =C2=A0Try reading "Delayed
> allocation and the zero-length file problem" article and comments by
> Ted Ts'o for further discussion. [2]

According to Ted, via-truncate and via-rename are unsafe. Only fsync,
rename is safe.
Disadvantage of rename is resetting file owner (if non-root), having
issues with meta-data and other stuff.

My proposal was for an open flag, O_ATOMIC, to be introduced to tell
the FS the whole file update should be done atomically.
Ted says this is too hard in ext4, so I was wondering if this would be
possible in btrfs.

Olaf
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
