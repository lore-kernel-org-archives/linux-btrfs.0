From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: abysmal performance
Date: Tue, 3 May 2011 10:42:56 -0500
Message-ID: <BANLkTi=0+UQeBX7Un7b1dqY-D6dA4t1_YQ@mail.gmail.com>
References: <1304088305-sup-3784@localhost>
	<1304089239-sup-5110@think>
	<BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com>
	<20110430235539.6205.qmail@stuge.se>
	<ipolll$2h0$1@dough.gmane.org>
	<1304420831-sup-4737@think>
	<4DBFE75C.2000104@birkenwald.de>
	<1304422493-sup-6212@think>
	<4DBFEA48.3000406@birkenwald.de>
	<1304427015-sup-4772@think>
	<BANLkTi=3DN1NqaJ9dwmqk0J-bUXA0c4ouQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Bernhard Schmidt <berni@birkenwald.de>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=3DN1NqaJ9dwmqk0J-bUXA0c4ouQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 3, 2011 at 9:41 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
>
> It does seem the case generally; on 2.6.39-rc5, writing to a fresh
> filesystem using rsync with BTRFS compression enabled, 128KB extents
> seem very common [1] (filefrag inconsistency noted).
>
> Defragmenting with compression gives a nice linear extent [2]. It
> looks like it'll be a good win to prevent extents being split at
> writeout for the read case on rotational media.
>

Yes, 128KB extents are hardcoded in Btrfs right now.

There are two reasons cited in the comments for this:

(1)  Ease the RAM required when spreading compression across several CPUs.
(2)  Make sure the amount of IO required to do a random read is
reasonably small.

For about 4 months, I've been playing locally with 2 patches to
increase the extent size to 512KB.

I haven't noticed any issues running with these patches.  However, I
only have a Core2duo with 2 CPUs, so I'm probably not running into
issues that someone with more CPUs might encounter.

I'll submit these patches to the list as an RFC so more people can at
least see where this is done.  But with my limited hardware, I can't
assert this change is the best for everyone.
