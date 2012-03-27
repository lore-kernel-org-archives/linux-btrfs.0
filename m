From: Not Zippy <notzippy@gmail.com>
Subject: Re: btrfs: open_ctree failed
Date: Tue, 27 Mar 2012 08:21:07 -0700
Message-ID: <CANDob0Lx-kX7LHsup8m5sY=_UmyA2qXOtsxbnwtV5p+eR-2ERQ@mail.gmail.com>
References: <CANDob0+rwkLGeJg4kP+TpPpN8VOdrOV684F5YiLC6+BkzYehHA@mail.gmail.com>
 <CANDob0+cBXnNH1dZ5socF7vaNoAB8wHACA4cN-w_1Z4T=VKUbA@mail.gmail.com>
 <20120326215740.GA2597@carfax.org.uk> <CANDob0JDQKObq8L2s8E7D9x_=k=MgsaMu=g0DBaZqGqCO_O70Q@mail.gmail.com>
 <20120326224729.GB2597@carfax.org.uk> <CANDob0KMJXQT47MusDnwTMLV5E=whSOSp+E8zAw2ZF6hTsNyOg@mail.gmail.com>
 <20120327130208.GC2597@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Not Zippy <notzippy@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120327130208.GC2597@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

I had found that note on the restore but my restore.c does not allow
that flag (it is also missing the "m" flag as well), I used the branch
dangerousdonteveruse on
https://git.kernel.org/?p=3Dlinux/kernel/git/mason/btrfs-progs.git I
switched to the master branch to see if there was a difference but it
does not appear to be any different. (I did find a btrfs-progs on
git-hub which appears to have those flags, but i thought the best to
use would be on git.kernel. )

Assuming I can locate the correct restore.c, is there a some other
software to determine the object id of the subvolume ?  the root
object id was 5

thanks
Nz

On Tue, Mar 27, 2012 at 6:02 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Mar 27, 2012 at 05:58:17AM -0700, Not Zippy wrote:
>> One entire subvolume was restored. But there were 4 subvolumes on th=
at
>> partition. Is there a way to specify/force the restore of a differen=
t
>> subvolume ?
>>
>> find-root seems to only find a single root.
>
> =A0 There is only a single root tree, so that's understandable. If yo=
u
> have a look at the documentation for restore[1], it mentions (right
> near the bottom of the page) that -r will allow you to select an
> alternative subvolume to recover from.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
