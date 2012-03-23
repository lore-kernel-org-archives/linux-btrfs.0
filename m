From: cwillu <cwillu@cwillu.com>
Subject: Re: heterogeneous raid1
Date: Fri, 23 Mar 2012 00:47:45 -0600
Message-ID: <CAE5mzvgzt3Jf-D+Rrm-8ueppwsPCdvUCP=w1CrfYo6_FFNOD7Q@mail.gmail.com>
References: <20120323061159.GA11099@mcelrath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Bob McElrath <bob@mcelrath.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120323061159.GA11099@mcelrath.org>
List-ID: <linux-btrfs.vger.kernel.org>

> In a nutshell: organize your heterogenous disks into two "halves", th=
e sum of
> which are of roughly equal size, and create a raid1 array across thos=
e two
> halves.
>
[snip]
>
> In the long term, I would like this to be something that btrfs could =
do by
> itself, without LVM. =C2=A0Having absolutely no knowledge of the btrf=
s code, this
> seems easy, I'm sure you'll tell me otherwise. =C2=A0;) =C2=A0But one=
 needs:

It already does this, no organisation necessary.

> While btrfs seems to support multi-disk devices, in trying this, I en=
countered
> the following deadly error: creating a raid1 btrfs with more than 2 d=
evices
> cannot be mounted in degraded mode if one or more are missing. =C2=A0=
(In the above
> plan, a filesystem should be mountable as long as one "half" is intac=
t) =C2=A0With 1
> of 4 devices missing in such a circumstance, I get:

I suspect you didn't make a raid1, but rather a raid1 metadata with
raid0 data.

> Both these errors were encountered with Ubuntu 11.10 (linux 3.0.9). =C2=
=A0I tried
> with 3.0.22 and I got "failed to read chunk tree" instead of the abov=
e "failed
> to read chunk root" and furthermore after mounting it degraded, I cou=
ld not
> mount it non-degraded, even after a balance and a fsck.

3.0 is seriously out of date: anything prior to 3.2 can cause problems
on a hard reboot, and a bunch of other things have also been fixed.


> P.S. why doesn't df work with btrfs raid1? =C2=A0Why is 'btrfs fi df'=
 necessary?

df works fine, but doesn't (and can't) give a complete picture:
there's no way for btrfs to extend the syscall df uses to return more
information without breaking the api for everybody else.

Note that the faq covers all of these points :p
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
