From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 21:05:56 -0500
Message-ID: <BANLkTinYHoy1PR-VCdgjo_emHcCjwPXNfQ@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105061009.29756.CACook@quantum-sci.com>
	<20110506205137.29666.qmail@stuge.se>
	<201105061420.49077.CACook@quantum-sci.com>
	<BANLkTinr-EbdTkhkOpEGLc2PPtQ1+NDDKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinr-EbdTkhkOpEGLc2PPtQ1+NDDKw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 6, 2011 at 8:51 PM, C Anthony Risinger <anthony@extof.me> w=
rote:
> On May 6, 2011 4:20 PM, <CACook@quantum-sci.com> wrote:
>>
>> On Friday 6 May, 2011 13:51:37 Peter Stuge wrote:
>> > CACook@quantum-sci.com wrote:
>> > > I don't understand this.
>> >
>> > Clearly. Please continue the discussion in a debian or grub forum.=
=2E
>> > It really has nothing to do with btrfs.
>>
>> No thanks. =A0This is a BTRFS problem, and if you people don't want =
to face it, that's fine.
>>
>> I'm tearing out BTRFS and using another filesystem. =A0And rest assu=
red, I'm warning others too.
>>
>> That's enough.
>
> i am sorry you've found yourself in this position, i really am, as
> i've been there myself, but please do try and acknowledge the
> considerations already extended your way -- my post marks the 51st
> message in this thread.

i see now that you're running a .32 kernel ... a bit after the fact,
but i really wouldn't recommend using anything that old for something
that's in such active development; IIRC, there were many feature gaps
at that point (ENOSPC being the big one), and unless Debian is doing
something special, .32 was when btrfs was declared "ready for early
adopters" ... ie. stable was still way out on the horizon, no one even
knew what she might look like yet :-)

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
