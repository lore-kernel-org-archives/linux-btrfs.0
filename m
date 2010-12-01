From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 12:24:28 -0800
Message-ID: <AANLkTink81Mcc9yEUF2cw3TZg=7F6=H52A-tfbtb8E39@mail.gmail.com>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com>
	<20101201163800.GA4087@carfax.org.uk>
	<20101201173830.GA7021@localhost.localdomain>
	<20101201193512.GB4087@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@lst.de,
	ssorce@redhat.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101201193512.GB4087@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 1, 2010 at 11:35 AM, Hugo Mills <hugo-lkml@carfax.org.uk> w=
rote:
> On Wed, Dec 01, 2010 at 12:38:30PM -0500, Josef Bacik wrote:
>> If you delete your subvolume A, like use the btrfs tool to delete it=
, you will
>> only be stuck with what you changed in snapshot B. =C2=A0So if you o=
nly changed 5gig
>> worth of information, and you deleted the original subvolume, you wo=
uld have
>> 5gig charged to your quota.
>
> =C2=A0 This doesn't work, though, if the owners of the "original" and
> "new" subvolume are different:
>
> Case 1:
>
> =C2=A0* Porthos creates 10G data.
> =C2=A0* Athos makes a snapshot of Porthos's data.
> =C2=A0* A sysadmin (Richelieu) changes the ownership on Athos's snaps=
hot of
> =C2=A0 Porthos's data to Athos.
> =C2=A0* Porthos deletes his copy of the data.
>
> Case 2:
>
> =C2=A0* Porthos creates 10G of data.
> =C2=A0* Athos makes a snapshot of Porthos's data.
> =C2=A0* Porthos deletes his copy of the data.
> =C2=A0* A sysadmin (Richelieu) changes the ownership on Athos's snaps=
hot of
> =C2=A0 Porthos's data to Athos.
>
> Case 3:
>
> =C2=A0* Porthos creates 10G data.
> =C2=A0* Athos makes a snapshot of Porthos's data.
> =C2=A0* Aramis makes a snapshot of Porthos's data.
> =C2=A0* A sysadmin (Richelieu) changes the ownership on Athos's snaps=
hot of
> =C2=A0 Porthos's data to Athos.
> =C2=A0* Porthos deletes his copy of the data.
>
> Case 4:
>
> =C2=A0* Porthos creates 10G data.
> =C2=A0* Athos makes a snapshot of Porthos's data.
> =C2=A0* Aramis makes a snapshot of Athos's data.
> =C2=A0* Porthos deletes his copy of the data.
> =C2=A0 [Consider also Richelieu changing ownerships of Athos's and Ar=
amis's
> =C2=A0 data at alternative points in this sequence]
>
> =C2=A0 In each of these, who gets charged (and how much) for their co=
py of
> the data?
>
>> =C2=A0The idea is you are only charged for what blocks
>> you have on the disk. =C2=A0Thanks,
>
> =C2=A0 My point was that it's perfectly possible to have blocks on th=
e
> disk that are effectively owned by two people, and that the person to
> charge for those blocks is, to me, far from clear. You either end up
> charging twice for a single set of blocks on the disk, or you end up
> in a situation where one person's actions can cause another person's
> quota to fill up. Neither of these is particularly obvious behaviour.

As a sysadmin and as a user, quotas shouldn't be about "physical
blocks of storage used" but should be about "logical storage used".

IOW, if the filesystem is compressed, using 1 GB of physical space to
store 10 GB of data, my "quota used" should be 10 GB.

Similar for deduplication.  The quota is based on the storage *before*
the file is deduped.  Not after.

Similar for snapshots.  If UserA has 10 GB of quota used, I snapshot
their filesystem, then my "quota used" would be 10 GB as well.  As
data in my snapshot changes, my "quota used" is updated to reflect
that (change 1 GB of data compared to snapshot, use 1 GB of quota).

You have to (or at least should) keep two sets of stats for storage usa=
ge:
  - logical amount used ("real" file size, before compression, before
de-dupe, before snapshots, etc)
  - physical amount used (what's actually written to disk)

User-level quotas are based on the logical storage used.
Admin-level quotas (if you want to implement them) would be based on
physical storage used.

Thus, the output of things like df, du, ls would show the "logical"
storage used and file sizes.  And you would either have an additional
option to those apps (--real or something) to show the "actual"
storage used and file sizes as stored on disk.

Trying to make quotas and disk usage utilities to work based on what's
physically on disk is just backwards, imo.  And prone to a lot of
confusion.

--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
