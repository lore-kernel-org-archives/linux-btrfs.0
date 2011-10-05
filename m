From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Wed, 5 Oct 2011 08:59:47 -0500
Message-ID: <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<4E5FE9FC.9040705@cchtml.com>
	<20110901203442.GA17928@carfax.org.uk>
	<201109101209.40759.Martin@lichtvoll.de>
	<CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
	<20111005061628.GA3702@shiny.elevennetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111005061628.GA3702@shiny.elevennetworks.com>
List-ID: <linux-btrfs.vger.kernel.org>

=46urther adoption and more commitment from Oracle for production use i=
s
good news.  The fact that adoption is happening without a working fsck
seems to indicate that folks have given up waiting for it.

Not hearing anything about getting the source into the repositories is
terrible news by omission.  It seems like doubling down on maintaining
a single point of failure.  Having a firm date of when the source
repository will be released regardless of its condition, or
functionality, would go a long way to appeasing the concerns within
the user base.



On Wed, Oct 5, 2011 at 1:16 AM, Chris Mason <chris.mason@oracle.com> wr=
ote:
> On Tue, Sep 13, 2011 at 01:01:00PM -0500, Jeff Putney wrote:
>> Isn't it about time to make some hard decisions about btrfsck? =A0Th=
ree
>> years is enough time to go without this type of functionality in a
>> modern filesystem, especially given btrfs's fragility in the face of
>> power failures.
>
> So this criticism is well deserved. =A0I'm juggling a ton of btrfs to=
dos
> and not doing a great job at communicating the current status of thin=
gs.
>
> Currently we have a pretty big queue of changes that I'm integrating =
for
> 3.2, and I had to delay btrfsck again so that I could start testing
> things. =A0The merge window is pretty short, and there are some
> fantastic changes that deserve to go in.
>
> Inside of Oracle, we've decided to make btrfs the default filesystem =
for
> Oracle Linux. =A0This is going into beta now and we'll increase our u=
sage
> of btrfs in production over the next four to six months. =A0This is a
> really big step forward, but it doesn't cover btrfs in database
> workloads (since we recommend asm for that outside of the filesystem)=
=2E
>
> What this means is that absolutely cannot move forward without btrfsc=
k.
> RH, Fujitsu, SUSE and others have spent a huge amount of time on the =
filesystem
> and it is clearly time to start putting it into customer hands.
>
> So over the next two weeks I'm juggling the merge window and the fsck
> release. =A0My goal is to demo fsck at linuxcon europe. =A0Thanks aga=
in for
> all of your patience and help with Btrfs!
>
> -chris
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
