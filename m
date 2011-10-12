From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Wed, 12 Oct 2011 13:57:01 -0500
Message-ID: <CA+JuuGpJdAPV2WjuVLTxM9LiCHOfgSZsMjSR=DnnbPnd8nLUqg@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<4E8F1D38.7030202@snappymail.ca>
	<20111007192728.5e79f1e0@atmarama.noip.me>
	<201110121641.55974.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201110121641.55974.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

> Even if its a thousand +1 following, it seems to me that its perfectl=
y
> Chris Masons decision...

Obviously.

> Chris seems to have some ideas on when to release the fsck.

Yes, and that idea of when has been drifting in the couple week range
for about a year.

> So what do you
> think you achieve by asking for its release again and again?

Best case scenario, everything just gets released in about a week, as
per the last estimate.  Barring that, a decoupling of the source
release from the tools completion, opening up the possibility of no
longer having a single point of failure (there is only so much one
person can do).  If he doesn't have any code that he feels is worth
building on, and releasing, then he should come clean about that and
open the door for someone else to step in.

> It won=B4t
> happen anytime sooner unless you happen to find the holy mantra that
> convinces Chris to release it now. I bet thats unlikely.

Or if the general consensus is that it is never going to get done, and
someone else should take the reigns.

> So its either do an fsck for yourself or wait...

This would be an appealing option, and one that at least 2 people have
pursued to some extent so far, but who wants to invest their time in
something like this if all of their efforts are just going to be
considered disposable?  This is in fact the single biggest problem
with Chris promising a tool, and perpetually not delivering it, nor
letting anyone see his source.  He is guaranteeing that any effort you
put into helping out with this would be ultimately wasted.


> BTRFS is still experimental software...

And yet Chris and Oracle are moving it into production use.

> I do not argue that having a nice fsck sooner than later is fine, but=
 I
> question the usefulness of repeating reminders. Chris Mason and other
> developers possibly working on the fsck should know by now, that you =
want
> it. So its unlikely that "I want it too" is going to change anything.

I haven't gotten the impression that Chris is quite that tone deaf, or
inconsiderate of the opinions of the community at large.  And the
discussion you are commenting on was about releasing the source code,
not the completed tool.  I don't think anyone is saying that Chris
needs to work harder and finish it faster.  What we are saying is that
it would be better for the progress of btrfs in general if the
development of fsck were done in an open way, and available for others
to contribute to.  The main problem with your statement of "Chris
Mason and other developers..." is that there does not appear to be any
other developers at all.  That's what we'd most like to see changed.

> Ciao,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA =A0B82F 991B EAAC A599 84C7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
