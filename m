From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 7 Oct 2011 08:40:03 -0500
Message-ID: <CA+JuuGo-iREXO4cZKT61tHZMTAr_edBv=O51-uSA7Bgynbgu6w@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111007025050.GA4767@shiny.Netlink.Wireless>
List-ID: <linux-btrfs.vger.kernel.org>

> For fsck, even the stuff I have here does have a way to go before it =
is
> at the level of an e2fsck or xfs_repair. =A0But I do want to make sur=
e
> that I'm surprised by any bugs before I send it out, and that's just =
not
> the case today. =A0The release has been delayed because I've alternat=
ed
> between a few different ways of repairing, and because I got distract=
ed
> by some important features in the kernel.

I think there is a major difference between touching up a few bugs
before you release the code, and experimenting with a bunch of
different ways of repairing before you release the code.  I know I for
one would get as much value out of reading the code for the strategies
you abandoned as I would get from reading the final code, but I don't
know if having those branches in the main repo would have any value
for the project as a whole.

As the current solution goes, I'd just like to see a stake in the
ground for some sort of process to move away from the one man army
approach, should distractions etc continue.  Given the latest 2 week
estimate, something along the lines of, in 4 or 6 weeks, if it still
isn't 'ready', code will start to be released.


> That's how software goes sometimes, and I'll take the criticism becau=
se
> it hasn't gone as well as it should have. =A0But, I can't stress enou=
gh how
> much I appreciate everyone's contributions and interest in btrfs.
>
> -chris

I'm only criticizing the decision to not release the source, in
particular given the delays.  We all have our priorities and
distractions, and s**t happens.  (Part of why I'd argue against the
flying solo strategy.)  But, I really do appreciate all the stuff
you've built, which is part of why I am so keen on reading it. :-) .

Thanks for all the effort
--jeff
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
