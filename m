Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:46560 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3CJGaJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 01:30:09 -0500
Received: by mail-la0-f45.google.com with SMTP id er20so2939077lab.32
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Mar 2013 22:30:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <khh6er$nmk$1@ger.gmane.org>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <khgcsi$1k4$1@ger.gmane.org> <20130310014434.GB30771@carfax.org.uk> <khh6er$nmk$1@ger.gmane.org>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 10 Mar 2013 07:29:47 +0100
Message-ID: <CAFWF=anqt8ssajAQtVR2CBCLVXJJSneLjuvRZERm7m-oPkK=Ug@mail.gmail.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 10, 2013 at 6:41 AM, Roger Binns <rogerb@rogerbinns.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 09/03/13 17:44, Hugo Mills wrote:
>> You've got at least three independent parameters to the system in order
>> to make that choice, though, and it's a fairly fuzzy decision problem.
>> You've got:
>>
>> - Device redundancy - Storage overhead - Performance
>
> Overhead and performance aren't separate goals.  More accurately the goal
> is best performance given the devices available and constrained by redundancy.
>
> If I have 1GB of unique data and 10GB of underlying space available then
> feel free to make 9 additional copies of each piece of data if that helps
> performance.  As I increase the unique data the overhead available will
> decrease, but I doubt anyone has a goal of micromanaging overhead usage.
> Why can't the filesystem just figure it out and do the best job available
> given minimal constraints?
>
>> I definitely want to report the results in nCmSpP form, which tells you
>> what it's actually done. The internal implementation, while not
>> expressing the full gamut of possibilities, maps directly from the
>> internal configuration to that form, and so it should at least be an
>> allowable input for configuration (e.g. mkfs.btrfs and the restriper).
>
> Agreed on that for the micromanagers :-)
>
>> If you'd like to suggest a usable set of configuration axes [say,
>> (redundancy, overhead) ], and a set of rules for converting those
>> requirements to the internal representation, then there's no reason we
>> can't add them as well in a later set of patches.
>
> The only constraints that matter are surviving N device failures, and data
> not lost if at least N devices are still present.  Under the hood the best
> way of meeting those can be heuristically determined, and I'd expect
> things like overhead to dynamically adjust as storage fills up or empties.
>
> Roger
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
>
> iEYEARECAAYFAlE8HR0ACgkQmOOfHg372QSyngCgpE9PTyBl3MsJ1kCYODtQWno/
> 85cAn0dcqE8ZWhOpFbZnQISmpe/KYceN
> =LTf8
> -----END PGP SIGNATURE-----
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Very good points,

I was also gonna write something by the lines of 'all that matters is
achieving the minimum amount of redundancy, as requested by the user,
at the maximum possible performance'.

After reading your post now, Roger, I'm much more clear on what I
actually wanted to say, which is pretty much the same thing:

In paradise really all I would have to tell btrfs is how many drives
I'm willing to give away so that they will be used exclusively for
redundancy. Everything else btrfs should figure out by itself. Not
just because it's simpler for the user, but also because btrfs
actually is in a position to KNOW better.

As Roger said, as long as the given minimum redundancy quota is
filled, btrfs could make choices that favor either even more
redundancy or more performance based on my usage of the filesystem by
meassuring things like throughput, ioops or space used. I could
imagine that a snail filesystem that barely fills and doesn't do whole
lot could easily work itself up on building huge redunancy, while a
filesystem that requires high performance would do excessive striping
to achieve maximum performance, while only keeping the minimum
requested redundancy intact.

It sounds quite futuristic to me, but it is definitely something that
we have to achieve hopefully rather sooner than later :)

I'm looking forward to it!
