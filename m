From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Wed, 7 Sep 2011 00:11:25 +0700
Message-ID: <CAG1y0sd=fYDT4Z4J=HqYXSsuZGjyMbUgpbLiguqdnibwt9qqOw@mail.gmail.com>
References: <4E64D3D5.7020407@petaramesh.org>
	<20110905222523.4531abe0@sf.home>
	<15663472.1RTxtZJx8a@tethys>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <15663472.1RTxtZJx8a@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 6, 2011 at 10:30 PM, Sw=E2mi Petaramesh <swami@petaramesh.o=
rg> wrote:
> On Monday 5 September 2011 22:25:23 Sergei Trofimovich wrote:
>> I've seen similar problem on Ubuntu-11 + Aspire One (8GB of slow "SS=
D").
>> More specifically half of ubuntu install went very fast and when
>> disk was ~50% free things suddenly gone slow.
>
> I'm just about to give up and definitely quit using BTRFS. My system =
has become
> so slow after upgrade Ubuntu Natty =3D> Oneiric Beta, that's it's pur=
ely and
> simply unusable (although I'm the kind of old, white-haired, experien=
ced, used
> to prehistoric systems, thus very patient, IT guy...)

Compared to ext3/4, btrfs or zfs (on linux) in its current state would
seem like snail. The only way I can get decent speed with btrfs on my
laptop is after using sandforce-based SSD (which helps offset some of
the slowness). But since I like lzo compression and snapshot feature,
I'll keep on using btrfs on this one :)

>
> It'a most probable that all of my usage patterns, i.e. read my mail, =
browse
> the web, etc, definitely do not correspond to what BTRFS was designed=
 for.
> (Sorry for the rant, but this really pisses me off...)
>
> So I'm only wonderign whether I reformat my system to ext4 or ZFS, an=
d whether
> I do it right now or on thursday...

Reading your post, at this point I'd actually recommend you stick with
ext4. Both btrfs and zfs are great, but IMHO btrfs is not ready for
daily use by "ordinary" user yet, while zfs is a memory hog
(especially for laptops, which is part of the reason why I'm using
btrfs instead of zfs on this one).

=46WIW I have another laptop with 4GB ram and Ubuntu + zfs root on it,
and it would seem "stall" on some operations with no apparent cpu or
disk activity. zfs compression and snapshot feature works great though
(and much more stable compared to btrfs, which stiil doesn't have a
functioning fsck), so if you have the resource to spare you might want
to give zfs another try later.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
