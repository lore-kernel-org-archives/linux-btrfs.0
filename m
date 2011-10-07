From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 7 Oct 2011 16:16:09 -0500
Message-ID: <CA+JuuGoTNDjsCPP+tw6QGE3Hwu=2iW0PU+yVr4sfrzam8zVHiA@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<4E5FE9FC.9040705@cchtml.com>
	<20110901203442.GA17928@carfax.org.uk>
	<201109101209.40759.Martin@lichtvoll.de>
	<CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
	<20111005061628.GA3702@shiny.elevennetworks.com>
	<CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
	<20111005145843.GA4770@shiny.elevennetworks.com>
	<CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
	<20111007025050.GA4767@shiny.Netlink.Wireless>
	<CA+JuuGo-iREXO4cZKT61tHZMTAr_edBv=O51-uSA7Bgynbgu6w@mail.gmail.com>
	<4E8F1128.4000508@redhat.com>
	<CA+JuuGopTsEWpeW5GnwjR-NuJgUwte6HGvhSTUfm_Wh0itVpdg@mail.gmail.com>
	<4E8F2418.10603@redhat.com>
	<CA+JuuGrtBF-afDmCbRQbEMicbxdumZPS_-+NE8mDcf0Rrdmatw@mail.gmail.com>
	<CAE5mzvj4ek8sf9J6XF1cHiUKPM7b-gPL0hOGNrfaod9saawdJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvj4ek8sf9J6XF1cHiUKPM7b-gPL0hOGNrfaod9saawdJQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Heh, what sort of "quality" are you thinking would develop? =A0A
> recovery tool by its nature is picking up the pieces where those
> pieces are inconsistent. =A0The nature of those inconsistencies will
> change with every patch that's more than a cleanup.
>

Seriously?  You want to delay the solving of the problems we have
today, because we are going to have different problems in the future?
I hate to be the bearer of bad news, but for the most part, we are
going to have new problems in addition to the ones we already have.
We are not going to get a whole brand new batch of problems that are
somehow going to magically make all our old problems obsolete.  You
also make the assumption that the solution to these new problems is
going to have absolutely no similarity to the current problems,
otherwise it would be beneficial to have a quality solution to similar
problems to build off of.

> Combined with the well-known tendencies of users to not report errors
> that are trivial to work around, and I find myself quite content with
> the status quo: =A0a few general recovery techniques that can be foun=
d
> with some digging, inconvenient enough that the reports don't get
> lost, with enough context that the appropriate warnings and
> alternatives can be given.

If the status quo is an acceptable condition, then you must not see
the need for any fsck utility.  If you see a need for an fsck utility,
then certainly you must see the problem in committing to 'eminently'
deliver that utility repeatedly for a year or so, and never delivering
it.  If you don't see that as a fundamental wrench in the works, I
don't know what would be.


> Yes, a deliberately broken-by-makefile version of what he's looking a=
t
> would be interesting, but I suspect it's not much past what any
> competent programmer would put together given a couple weeks going
> over the disk format, and we already have a couple of those.

Yeah, I am also suspicious that that is all that exists, and I suspect
that may have something to do with the resistance to releasing the
source.  If that is the case, why not just come clean about it, and
let others start contributing, so we can get somewhere with it.

> What we want is still in Chris' head, otherwise we _would_ have
> something.

If it is still only exists in his head, after a year, how long should
we wait before someone else takes the reigns?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
