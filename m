From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 6 Oct 2011 10:31:41 -0500
Message-ID: <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<4E5FE9FC.9040705@cchtml.com>
	<20110901203442.GA17928@carfax.org.uk>
	<201109101209.40759.Martin@lichtvoll.de>
	<CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
	<20111005061628.GA3702@shiny.elevennetworks.com>
	<CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
	<20111005145843.GA4770@shiny.elevennetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111005145843.GA4770@shiny.elevennetworks.com>
List-ID: <linux-btrfs.vger.kernel.org>

> No, in this case it means we're confident it will get rolled out.

On Aug 18th confidence was high enough to declare a possible release
that very day.  This confidence turned into 7 weeks of silence
followed by another 2 week estimate.

These confident declarations are why things like mniederle's
btrfs_rescue are considered 'interim' and not worth building on.  Had
this confidence of imminent release not been the prevalent message for
the last year, others would have stepped in to fill the void.

> I've given a number of hard dates recently and I'd prefer to show up
> with the code instead. =A0I don't think it makes sense to put a parti=
al
> implementation out there, we'll just have a bunch of people reporting
> problems that I know exist.
>
> -chris
>

This strategy of 'Lone Wolfing it' has delayed the release by a year.
Either you are flying solo because you think that you can make more
meaningful progress without the involvement of the btrfs community, or
you are willing to forfeit the contributions of the community in order
to not have to listen to any complaints.

The other problem of this flying solo plan, is that you are making the
assumption that the problems you know about are more significant than
the problems you are unaware of and could be flushed out with more
eyes on the code.  The longer you delay the release of the source, the
longer it will be until confidence can be generated that major issues
have been resolved.

http://en.wikipedia.org/wiki/Release_early,_release_often
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
