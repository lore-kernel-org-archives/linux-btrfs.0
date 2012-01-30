From: Rohit Mehta <pigdog@gmail.com>
Subject: Re: newbie problems (difficulty with mkfs.btrfs and learning how to
 navigate trees
Date: Mon, 30 Jan 2012 11:38:51 -0500
Message-ID: <CAHb3AmJWh-0W-f5AjZxstu8xtd+evA2VFidJPu+XecA4_O-t-Q@mail.gmail.com>
References: <CAHb3AmJiv3Leq1QUO3JNQ3tuZ06jFQXWv=Jba65AW9qbk-T4Qw@mail.gmail.com>
	<pan.2012.01.30.05.56.40@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.30.05.56.40@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 30, 2012 at 12:56 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> First, a general point. =A0You don't mention what kernel or tools sou=
rces
> you are using.

My apologies! I was using the 3.2.2 kernel and the unstable btrfs
tools from the Integration repository as of last night
( http://git.darksatanic.net/repo/btrfs-progs-unstable.git )  Although
I did try with certain other permutations of kernels and versions of
btrfs-progs.

I'm only playing with BTRFS in UML, trying to understand how it works
at this point.

> It's quite likely that mixed-mode simply won't yet work on that tiny =
a
> filesystem created with raid1 mode data, but for sure I'd try it with=
 the
> latest code, in case the problem is now fixed.
>
> So, I'd say try it with something larger, probably 1/8 gig to 1/4 gig=
 at
> least. =A0Or if that's not convenient at present, run as you mentione=
d,
> either raid0 mode or one device, no-raid, for now.

Thanks, it does seem to work on larger filesystems.  I'll work with
500 MB virtual disks.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
