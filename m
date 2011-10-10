From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Honest timeline for btrfsck
Date: Mon, 10 Oct 2011 08:59:02 -0400
Message-ID: <1318251388-sup-3431@shiny>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <4E5FE9FC.9040705@cchtml.com> <20110901203442.GA17928@carfax.org.uk> <201109101209.40759.Martin@lichtvoll.de> <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com> <20111005061628.GA3702@shiny.elevennetworks.com> <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com> <20111005145843.GA4770@shiny.elevennetworks.com> <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com> <CAAE6i0i-AsH7TkupkrFDdv26gN_-pshFFwvuH1nOuuSmKWbZdQ@mail.gmail.com> <4E8F4EA9.4090108@shiftmail.org>
Content-Type: text/plain; charset=UTF-8
Cc: Chester <somethingsome2000@gmail.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Asdo <asdo@shiftmail.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E8F4EA9.4090108@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Asdo's message of 2011-10-07 15:10:33 -0400:
> On 10/07/11 04:25, Chester wrote:
> > The problem with this is that people naturally look for a fsck tool
> > when something bad goes wrong. Something as important as a fsck
> > utility shouldn't be released (unofficially or officially) half baked.
> > It can irreparably destroy a filesystem which could've otherwise been
> > repaired with a fully functional fsck.
> >
> > I think Chris is trying to prevent that from happening.
> 
> What I would like to know instead, is WHY we need an btrfsck when ZFS 
> does not. Zfs also has this kind of problems especially on power 
> failures, but you can always mount by rolling back to a previous 
> uberblock, showing an earlier view of the filesystem, which would be 
> consistent.
> 
> It wasn't always like this with ZFS, but this "feature" has been added 
> after ther numerous requests of users who lost their complete 
> filesystems after a power failure or similar events. And there was no 
> zfsck (there still isn't, and it's apparently not needed).

One of my patches here adds a circular ring of past roots for a similar
feature.  The problem is that blocks get reused after a commit, so we
have to either slow that down (making enospc even more complex) or we'd
have to just use the past super and hope.

It gets even worse because things past supers aren't always enough.  The
drive can just plain corrupt an important block, or write-back cache
problems can make corruptions that last much longer than the last 5 or
10 commits.  Bad things do happen to good data, so you just plain need a
real fsck.

-chris
