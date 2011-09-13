From: Jeff Putney <jeffrey.putney@gmail.com>
Subject: Re: Honest timeline for btrfsck
Date: Tue, 13 Sep 2011 13:01:00 -0500
Message-ID: <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com>
	<4E5FE9FC.9040705@cchtml.com>
	<20110901203442.GA17928@carfax.org.uk>
	<201109101209.40759.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201109101209.40759.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

Isn't it about time to make some hard decisions about btrfsck?  Three
years is enough time to go without this type of functionality in a
modern filesystem, especially given btrfs's fragility in the face of
power failures.

Given the lack of progress, and the inability to provide remotely
realistic time lines, I'd say it is inappropriate for development to
remain in secret.  I am aware of the type of noise that could be
created by releasing this code out to the public, but that noise will
help drive fixes and development of the tool.  We have seen months
worth of wasted effort spent on stop gap measures that could have been
funneled into the real utility, if people just had access to the code.

If we can't get btrfsck checked into btrfs-progs-unstable, should we
just cut our losses and start a recovery tool from scratch.  There was
a btrfs_rescue utility mentioned at
http://article.gmane.org/gmane.comp.file-systems.btrfs/8309/match=3Dbtr=
fs_rescue,
but the source doesn't seem to be available anymore.

I had started to work on my own repair tool/script/hack.  I was
looking into some of the current btrfs progs code, and the biggest
issue I had was all of the data validation that disk_io.c and other
code does that makes sure the FS is in a good state before you can do
anything with it.  This makes those utility methods pretty much
useless for exploring a broken FS.  So, understanding how to
incrementally read the FS without doing all of the validations
beforehand was the biggest hurdle I encountered.


On Sat, Sep 10, 2011 at 5:09 AM, Martin Steigerwald <Martin@lichtvoll.d=
e> wrote:
> Am Donnerstag, 1. September 2011 schrieb Hugo Mills:
>> On Thu, Sep 01, 2011 at 03:24:28PM -0500, Michael Cronenworth wrote:
>> > On 09/01/2011 03:20 PM, Hugo Mills wrote:
>> > > =A0 =A0You may have missed the "on vacation" bit.
>> >
>> > I did read the "on vacation" bit. Not that it is any of my busines=
s,
>> > but how long is that vacation?
>>
>> =A0 =A0Your guess is as good as mine. It's only been two weeks...
>>
>> > > =A0 =A0The canonical place to look for btrfsck updates is the re=
levant
>> > > =A0 =A0FAQ
>> > >
>> > >item on the btrfs wiki.
>> >
>> > I know this. No need to repeat it. I'm not a complete idiot.
>>
>> =A0 =A0I never claimed you were. Many people either don't realise th=
at
>> that is the right place, or don't realise that it really is updated
>> pretty much as soon as possible with all the information that's been
>> made public on the subject.
>
> Well, I do think that a release of the fsck for BTRFS is important en=
ough
> to announce it on this mailinglist, too ;).
>
> Fortunately I didn=B4t have any major problems so far. I once had to =
use
> btrfs-zero-log. And I am still not using BTRFS for my main machine=B4=
s home
> directory. For this I intend to wait till it is marked stable in kern=
el
> sources + fsck available.
>
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
