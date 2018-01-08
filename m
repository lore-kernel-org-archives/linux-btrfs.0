Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44764 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756796AbeAHWSU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 17:18:20 -0500
Date: Mon, 8 Jan 2018 22:18:18 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tom Worster <fsb@thefsb.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Recommendations for balancing as part of regular maintenance?
Message-ID: <20180108221818.GA3807@carfax.org.uk>
References: <C11AC11F-C4CC-41B8-BE2F-52486E42C987@thefsb.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <C11AC11F-C4CC-41B8-BE2F-52486E42C987@thefsb.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 08, 2018 at 04:43:02PM -0500, Tom Worster wrote:
> On 01/08/2018 04:55 PM, Austin S. Hemmelgarn wrote:
> 
> >On 2018-01-08 11:20, ein wrote:
> >
> >> On 01/08/2018 04:55 PM, Austin S. Hemmelgarn wrote:
> >>
> >> > [...]
> >> >
> >> > And here's the FAQ entry:
> >> >
> >> > Q: Do I need to run a balance regularly?
> >> >
> >> > A: In general usage, no. A full unfiltered balance typically
> >takes a
> >> > long time, and will rewrite huge amounts of data
> >unnecessarily. You may
> >> > wish to run a balance on metadata only (see Balance_Filters)
> >if you find
> >> > you have very large amounts of metadata space allocated but
> >unused, but
> >> > this should be a last resort.
> >>
> >> IHMO three more sentencens and the answer would be more useful:
> >> 1. BTRFS balance command example with note check the man first.
> >> 2. What use case may cause 'large amounts of metadata space
> >allocated
> >> but unused'.
> >
> >That's kind of what I was thinking as well, but I'm hesitant to
> >get too heavily into stuff along the lines of 'for use case X, do
> >1, for use case Y, do 2, etc', as that tends to result in
> >pigeonholing (people just go with what sounds closest to their use
> >case instead of trying to figure out what actually is best for
> >their use case).
> >
> >Ideally, I think it should be as generic as reasonably possible,
> >possibly something along the lines of:
> >
> >A: While not strictly necessary, running regular filtered balances
> >(for example `btrfs balance start -dusage=50 -dlimit=2 -musage=50
> >-mlimit=4`, see `man btrfs-balance` for more info on what the
> >options mean) can help keep a volume healthy by mitigating the
> >things that typically cause ENOSPC errors. Full balances by
> >contrast are long and expensive operations, and should be done
> >only as a last resort.
> 
> As the BTRFS noob who started the conversation on netdata's Github
> issues, I'd like to describe my experience.
> 
> I got an alert that unallocated space on a BTRFS filesystem on one
> host was low. A netdata caption suggested btrfs-balance and directed
> me to its man page. But I found it hard to understand since I don't
> know how BTRFS works or its particular terminology. The FAQ was
> easier to understand but didn't help me find a solution to my
> problem.

   The information is there in the FAQ, but only under headings that
you'd find if you'd actually hit the problems, rather than being warned
that the problems might be happening (which is your situation):

https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21

> It's a 420GiB NVMe with single data and metadata. It has a MariaDB
> datadir with an OLTP workload and a small GlusterFS brick for
> replicating filesystem with little activity. I recall that
> unallocated space was under 2G, metadata allocation was low, a few G
> and about 1/3 used. Data allocation was very large, almost
> everything else, with ~25% used.
> 
> Given the documentation and the usage stats, I did not know what
> options to use with balance. I spent some time reading and
> researching and trying to understand the filters and how they should
> relate to my situation. Eventually I abandoned that effort and ran
> balance without options.

   That'll certainly work, although it's wasteful of I/O bandwidth and
time.

> While general recommendations about running balance would be
> welcome, what I needed was a dummy's guide to what the output of
> btrfs usage _means_ and how to use balance to tackle problems with
> it.

   In this kind of situation, it's generally recommended to balance
data chunks only (because that's where the overallocation usually
happens). There's not much point in balancing everything, so the
question is how much work to do... Ideally, you want to end up
compacting everything into the smallest number of chunks, which will
be the number of GiB of actual data.

   There's a couple of ways to limit the work done. One way is to only
pick the chunks less than some threshold fraction used. This is the
usage=N option (-dusage=30, for example). It allows you to do (in
theory) the minimum amount of actual balance work neded. Drawbacks are
that you don't know how many such chunks there are for any given N, so
you end up searching manually for an appropriate N.

   The other way is to tell balance exactly how many chunks it should
operate on. This is the limit=N option. This gives you precise control
over the number of chunks to balance, but doesn't specify which
chunks, so you may end up moving N GiB of data (whereas usage=N could
move much less actual data).

   Personally, I recommend using limit=N, where N is something like
(Allocated - Used)*3/4 GiB.

   Note the caveat below, which is that using "ssd" mount option on
earlier kernels could prevent the balance from doing a decent job.

> The other mystery is how the data allocation became so large.

   You have a non-rotational device. That means that it'd be mounted
automatically with the "ssd" mount option. Up to 4.13 (or 4.14, I
always forget), the behaviour of "ssd" leads to highly fragmented
allocation of extents, which in turn results in new data chunks being
allocated when there's theoretically loads of space available to use
(but which it may not be practical to use, due to the fragmented free
space).

   After 4.13 (or 4.14), the "ssd" mount option has been fixed, and it
no longer has the bad long-term effects that we've seen before, but it
won't deal with the existing fragmented free space without a data
balance.

   If you're running an older kernel, it's definitely recommended to
mount all filesystems with "nossd" to avoid these issues.

   Hugo.

-- 
Hugo Mills             | As long as you're getting different error messages,
hugo@... carfax.org.uk | you're making progress.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJaU+4qAAoJEFheFHXiqx3kTXAP/jWokOlQFUCNQSNBq3752R55
vPNAlNuVqaRHZbSNLb9CLRwZmYfxGoA7/7IHE46TfUl7Gfr4hWSQXBaS4B36Mcf6
2acej6rXciEQjTTCVWu4Yt/o7XNUkiwZBAJf/etgc/wWs5vfvG9B2qFTm+4ZXVkH
ljfcNm0y99IkutkWKDrd5IRyRk0PdfC58Ym4zKKA/mdNYihn7OWWz15Pbk2T/Q6q
SE+LewWtDc7a7eZJ+UaDshE42xZwT4q+XvHXwRCl2sOHnZsJmB7ntoOHtOTr+37Z
xGQ9unZGigxDTDwY9ij/nh7Dg7ZCMwTrgGbctl0dP6OAHCttelOazDp2NUKfeStD
KTGtJywMzu0I77yAQsVY6E4eYjVMORLfJ2TCtojj9UZI0KFur6fQNBZtZPA1IgA5
KvfqJEswDQYB7iVz8Myg8A7GOtfrAWJziQNsrtptxKqB7bUBMYhHgEx1jv74hhsO
eGuYc8l2nsAU3Fj9yj1b3OB6cDAFavxVmzhKIZUWTluNywzQuu31WYf1QFlQvkNo
X2qcK0fzkaO4N77g18buaDrO9F5hZoiOLwOjrGih6CeUpOqRomg0/KRrt1yg2/+j
3Dji0wOr+1RFxkQ0g4iV5FB4ujT2ME8OG6unWPapufsrqpIsbfQSIQaWvaHmJMr7
mPMJHNcdPWx1xCVKF3DQ
=aJwm
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
