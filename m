From: Chester <somethingsome2000@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Thu, 6 Oct 2011 21:25:19 -0500
Message-ID: <CAAE6i0i-AsH7TkupkrFDdv26gN_-pshFFwvuH1nOuuSmKWbZdQ@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
 <4E5FE9FC.9040705@cchtml.com> <20110901203442.GA17928@carfax.org.uk>
 <201109101209.40759.Martin@lichtvoll.de> <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
 <20111005061628.GA3702@shiny.elevennetworks.com> <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
 <20111005145843.GA4770@shiny.elevennetworks.com> <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jeff Putney <jeffrey.putney@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 6, 2011 at 10:31 AM, Jeff Putney <jeffrey.putney@gmail.com>=
 wrote:
>> No, in this case it means we're confident it will get rolled out.
>
> On Aug 18th confidence was high enough to declare a possible release
> that very day. =A0This confidence turned into 7 weeks of silence
> followed by another 2 week estimate.
>
> These confident declarations are why things like mniederle's
> btrfs_rescue are considered 'interim' and not worth building on. =A0H=
ad
> this confidence of imminent release not been the prevalent message fo=
r
> the last year, others would have stepped in to fill the void.
>
>> I've given a number of hard dates recently and I'd prefer to show up
>> with the code instead. =A0I don't think it makes sense to put a part=
ial
>> implementation out there, we'll just have a bunch of people reportin=
g
>> problems that I know exist.
>>
>> -chris
>>
>
> This strategy of 'Lone Wolfing it' has delayed the release by a year.
> Either you are flying solo because you think that you can make more
> meaningful progress without the involvement of the btrfs community, o=
r
> you are willing to forfeit the contributions of the community in orde=
r
> to not have to listen to any complaints.
>
> The other problem of this flying solo plan, is that you are making th=
e
> assumption that the problems you know about are more significant than
> the problems you are unaware of and could be flushed out with more
> eyes on the code. =A0The longer you delay the release of the source, =
the
> longer it will be until confidence can be generated that major issues
> have been resolved.
>
> http://en.wikipedia.org/wiki/Release_early,_release_often
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

The problem with this is that people naturally look for a fsck tool
when something bad goes wrong. Something as important as a fsck
utility shouldn't be released (unofficially or officially) half baked.
It can irreparably destroy a filesystem which could've otherwise been
repaired with a fully functional fsck.

I think Chris is trying to prevent that from happening.

Perhaps Chris can set up a private developer repo and ask for help
from redhat, fujitsu, etc..?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
