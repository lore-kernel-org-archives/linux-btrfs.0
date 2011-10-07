From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 6 Oct 2011 22:50:50 -0400
Message-ID: <20111007025050.GA4767@shiny.Netlink.Wireless>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <4E5FE9FC.9040705@cchtml.com>
 <20110901203442.GA17928@carfax.org.uk>
 <201109101209.40759.Martin@lichtvoll.de>
 <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
 <20111005061628.GA3702@shiny.elevennetworks.com>
 <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
 <20111005145843.GA4770@shiny.elevennetworks.com>
 <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Putney <jeffrey.putney@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 06, 2011 at 10:31:41AM -0500, Jeff Putney wrote:
> > No, in this case it means we're confident it will get rolled out.
>=20
> On Aug 18th confidence was high enough to declare a possible release
> that very day.  This confidence turned into 7 weeks of silence
> followed by another 2 week estimate.
>=20
> These confident declarations are why things like mniederle's
> btrfs_rescue are considered 'interim' and not worth building on.  Had
> this confidence of imminent release not been the prevalent message fo=
r
> the last year, others would have stepped in to fill the void.
>=20
> > I've given a number of hard dates recently and I'd prefer to show u=
p
> > with the code instead. =A0I don't think it makes sense to put a par=
tial
> > implementation out there, we'll just have a bunch of people reporti=
ng
> > problems that I know exist.
> >
> > -chris
> >
>=20
> This strategy of 'Lone Wolfing it' has delayed the release by a year.
> Either you are flying solo because you think that you can make more
> meaningful progress without the involvement of the btrfs community, o=
r
> you are willing to forfeit the contributions of the community in orde=
r
> to not have to listen to any complaints.
>=20
> The other problem of this flying solo plan, is that you are making th=
e
> assumption that the problems you know about are more significant than
> the problems you are unaware of and could be flushed out with more
> eyes on the code.  The longer you delay the release of the source, th=
e
> longer it will be until confidence can be generated that major issues
> have been resolved.
>=20
> http://en.wikipedia.org/wiki/Release_early,_release_often

[ Thanks for everyone's comments! ]

Keep in mind that btrfs was released and ran for a long time while
intentionally crashing when we ran out of space.   This was a really
important part of our development because we attracted a huge number of
contributors, and some very brave users.

=46or fsck, even the stuff I have here does have a way to go before it =
is
at the level of an e2fsck or xfs_repair.  But I do want to make sure
that I'm surprised by any bugs before I send it out, and that's just no=
t
the case today.  The release has been delayed because I've alternated
between a few different ways of repairing, and because I got distracted
by some important features in the kernel.

That's how software goes sometimes, and I'll take the criticism because
it hasn't gone as well as it should have.  But, I can't stress enough h=
ow
much I appreciate everyone's contributions and interest in btrfs.

-chris

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
