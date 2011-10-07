From: cwillu <cwillu@cwillu.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 7 Oct 2011 12:23:07 -0600
Message-ID: <CAE5mzvj4ek8sf9J6XF1cHiUKPM7b-gPL0hOGNrfaod9saawdJQ@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Putney <jeffrey.putney@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+JuuGrtBF-afDmCbRQbEMicbxdumZPS_-+NE8mDcf0Rrdmatw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 7, 2011 at 11:07 AM, Jeff Putney <jeffrey.putney@gmail.com>=
 wrote:
> You jest, but in fact that is the result you've achieved, through
> conspiring or not.
>
> Do you honestly believe that had the source been public from the
> start, that after a year there would still be no quality fsck tool?
> Contributions are, de facto, blocked.
> Had there not been repeated promise of an fsck utility for the last
> year, do you honestly believe no one else would have begun
> development? =C2=A0Call it under your thumb if you'd like, but you'll=
 argue
> these declarations didn't have a stifling effect in vain.

Heh, what sort of "quality" are you thinking would develop?  A
recovery tool by its nature is picking up the pieces where those
pieces are inconsistent.  The nature of those inconsistencies will
change with every patch that's more than a cleanup.

Combined with the well-known tendencies of users to not report errors
that are trivial to work around, and I find myself quite content with
the status quo:  a few general recovery techniques that can be found
with some digging, inconvenient enough that the reports don't get
lost, with enough context that the appropriate warnings and
alternatives can be given.

Yes, a deliberately broken-by-makefile version of what he's looking at
would be interesting, but I suspect it's not much past what any
competent programmer would put together given a couple weeks going
over the disk format, and we already have a couple of those.  What we
want is still in Chris' head, otherwise we _would_ have something.

--cwillu

Warning: while cwillu is never "wrong", he may not correspond to
reality.  cwillu should not be taken with caffeine or alcohol.
Contact a doctor immediately if cwillu submits patches, rants, or
directives.  Do not leave cwillu within reach of children or
ubuntuforums users.  Always make sufficient backups before taking
cwillu.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
